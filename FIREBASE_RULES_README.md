# Firebase Security Rules

This directory contains **enhanced and comprehensive** security rules for Firestore and Cloud Storage that protect your chat application.

## Recent Updates (Latest)

✅ **Profile Rules & Indexes**: Added firestore.indexes.json with indexes for profile queries (username, email, phone)  
✅ **Firebase Configuration**: Created firebase.json to configure rules and indexes deployment  
✅ **Enhanced Documentation**: All rules now include detailed inline comments explaining their purpose and security rationale  
✅ **Field Validation**: Added explicit validation for required fields in messages, profiles, and groups  
✅ **Security Improvements**: Enhanced comments clarifying authentication flows and security measures  
✅ **Better Organization**: Rules organized with clear section headers for easy navigation  
✅ **Login Support**: Rules explicitly support email, username, and phone authentication methods  

## Files

- `firestore.rules` - Security rules for Firestore database (enhanced with comprehensive documentation)
- `firestore.indexes.json` - Index definitions for efficient profile queries
- `firebase.json` - Firebase project configuration for rules and indexes
- `storage.rules` - Security rules for Cloud Storage (enhanced with comprehensive documentation)
- `PROFILE_RULES_INDEXES.md` - Detailed documentation for profile rules and indexes

## Deploying the Rules

### Option 1: Using Firebase Console (Web Interface)

#### Firestore Rules:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **g19-chathub**
3. Navigate to **Firestore Database** → **Rules** tab
4. Copy the contents of `firestore.rules` and paste into the editor
5. Click **Publish**

#### Storage Rules:
1. In Firebase Console, navigate to **Storage** → **Rules** tab
2. Copy the contents of `storage.rules` and paste into the editor
3. Click **Publish**

### Option 2: Using Firebase CLI

If you have Firebase CLI installed, you can deploy rules and indexes together:

```bash
# Install Firebase CLI (if not already installed)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project (if not already done)
firebase init

# Deploy rules and indexes together
firebase deploy --only firestore

# Or deploy individually:
# Deploy only rules
firebase deploy --only firestore:rules,storage:rules

# Deploy only indexes
firebase deploy --only firestore:indexes
```

## Security Features

### Firestore Indexes

The `firestore.indexes.json` file defines indexes for efficient profile queries:

1. **username** - For username-based login and user search
2. **emailLower** - For case-insensitive email authentication
3. **email** - For direct email queries
4. **phone** - For phone number authentication

These indexes enable:
- Fast user lookup during login (by email, username, or phone)
- Efficient user search for starting chats
- Quick profile queries for group invitations

**Note**: These are single-field indexes that Firestore can automatically create when needed, but defining them explicitly ensures consistent performance and prevents runtime index creation prompts.

For detailed information about profile rules and indexes, see [PROFILE_RULES_INDEXES.md](PROFILE_RULES_INDEXES.md).

### Firestore Rules

The **enhanced** Firestore rules protect:

1. **User Profiles** (`/users/{userId}`)
   - ✅ Anyone authenticated can read user profiles (needed to search for chat partners)
   - ✅ Users can only create/update their own profile
   - ✅ **NEW**: Explicit validation - 'name' field is required on profile creation
   - ✅ Supports email, username, and phone authentication methods
   - ✅ Enables profile photo uploads and status updates
   - ❌ No one can delete profiles (maintains chat history integrity)

2. **Chat Messages** (`/chats/{chatId}/messages/{messageId}`)
   - ✅ Only chat participants can read messages
   - ✅ Participants can send messages with their own senderId
   - ✅ **NEW**: Explicit validation - messages must include senderId, type, and timestamp
   - ✅ Messages are immutable (no updates/deletes) to preserve chat history
   - ✅ Messages persist forever - chat history never disappears
   - ✅ Self-chat support (user can chat with themselves)
   - ✅ Server timestamp validation
   - ✅ Protection against message spoofing

3. **Group Chats** (`/groups/{groupId}`)
   - ✅ Anyone authenticated can discover groups
   - ✅ **NEW**: Groups must have name, members, and admins on creation
   - ✅ Only admins can update group settings (name, description, members)
   - ✅ Only group members can read and send messages
   - ✅ **NEW**: Group messages require senderId, type, and timestamp fields
   - ✅ Group typing indicators for real-time interaction
   - ✅ Admin-only group photo management

3. **Typing Status** (`/chats/{chatId}/status/typing`)
   - ✅ Participants can read and update typing indicators
   - ✅ Users can only set their own typing status
   - ✅ Real-time "user is typing..." indicators

4. **Voice/Video Call Signaling** (`/chats/{chatId}/call/*`)
   - ✅ Participants can create/read call offers and answers
   - ✅ Participants can exchange ICE candidates for WebRTC
   - ✅ Support for both audio-only and video calls
   - ✅ Call state management for tracking active calls
   - ✅ Secure peer-to-peer communication setup

### Storage Rules

The **enhanced** Storage rules protect:

1. **Profile Photos** (`/profiles/{userId}/{fileName}`)
   - ✅ Anyone authenticated can view profile photos
   - ✅ Users can only upload their own profile photo
   - ✅ Max size: 5MB
   - ✅ Allowed types: images only (jpeg, png, gif, webp)
   - ✅ Users can delete their own profile photos
   - ✅ **Enhanced**: Detailed documentation of use cases

2. **Group Photos** (`/groups/{groupId}/{fileName}`)
   - ✅ Anyone authenticated can view group photos
   - ✅ Only admins can upload/update/delete group photos
   - ✅ Max size: 5MB
   - ✅ Allowed types: images only
   - ✅ **Enhanced**: Admin verification via Firestore query

3. **File Uploads** (`/files/{chatId}/{fileName}`)
   - ✅ Only chat participants can access files
   - ✅ Max file size: 10MB
   - ✅ Allowed types: images, videos, audio, PDFs, documents, text
   - ✅ Files are immutable (no updates/deletes)
   - ✅ **Enhanced**: Comprehensive file type validation

4. **Voice Messages** (`/voice/{chatId}/{fileName}`)
   - ✅ Only chat participants can access voice messages
   - ✅ Max file size: 5MB
   - ✅ Must be audio type
   - ✅ Voice messages are immutable
   - ✅ Self-chat support included
   - ✅ **Enhanced**: Detailed audio format support

## Key Security Principles

1. **Authentication Required**: All operations require users to be signed in
2. **Authorization**: Users can only access their own chats (chatId contains their userId)
3. **Data Validation**: Server timestamps and senderIds are validated
4. **Field Validation**: Required fields are enforced (name, senderId, type, timestamp)
5. **Immutability**: Messages and files cannot be edited or deleted - preserves chat history
6. **Size Limits**: File uploads are limited to prevent abuse (10MB files, 5MB voice/photos)
7. **Type Validation**: File types are restricted to safe formats
8. **Auto-Start Support**: Rules allow participants to automatically start/join chats and read chat metadata
9. **Self-Chat Support**: Users can chat with themselves (useful for personal notes)
10. **History Preservation**: Chat messages are never deleted and always remain accessible
11. **Security Against Attacks**: Regex patterns prevent chatId injection and spoofing attacks
12. **Multi-Auth Support**: Rules support email, username, and phone number authentication

## chatId Format

The chat application uses a format where chatId is created by sorting both participant userIds alphabetically and joining with underscore:

```
chatId = [userId1, userId2].sort().join('_')
```

Example: If user `abc123` chats with user `xyz789`, the chatId will be `abc123_xyz789`

**Self-Chat Support**: Users can also chat with themselves (useful for personal notes). In this case, the chatId will be `userId_userId` (e.g., `abc123_abc123`).

This ensures:
- Same chatId is used regardless of who initiates the chat
- The `isParticipant()` helper verifies exact boundary matching with `[^_]+` (one or more non-underscore characters): the userId must be either at the start followed by `_` and another userId, or at the end preceded by `_` and another userId
- Self-chat is explicitly supported when both IDs are identical
- This prevents substring vulnerabilities, empty participant IDs, and malformed chatIds with multiple underscores (e.g., 'abc' won't match 'xabcy', 'user_' is invalid, 'user__other' is invalid)

## Testing Rules

After deploying, test the rules by:

1. **Sign in** with a test account
2. **Try to read** another user's profile ✅ Should work
3. **Try to start** a chat ✅ Should work
4. **Try to send** a message ✅ Should work with your senderId
5. **Try to update** someone else's profile ❌ Should fail
6. **Try to access** a chat you're not part of ❌ Should fail
7. **Upload** a file ✅ Should work if under size limit
8. **Upload** a very large file ❌ Should fail if over limit

## Troubleshooting

If you encounter permission errors:

1. **"Missing or insufficient permissions"**
   - Make sure you're signed in
   - Check that your userId is part of the chatId
   - Verify the rules are published in Firebase Console

2. **File upload fails**
   - Check file size (must be under 10MB for files, 5MB for voice)
   - Verify file type is allowed
   - Make sure you're a participant in the chat

3. **Cannot read users collection**
   - Ensure you're authenticated
   - Rules allow all authenticated users to read user profiles

## Best Practices

1. **Keep rules updated** as your app evolves
2. **Test rules thoroughly** before deploying to production
3. **Monitor Firebase Console** for security issues
4. **Review access logs** periodically
5. **Use Firebase Emulator Suite** for local testing during development

## Support

For questions about these rules or Firebase security, refer to:
- [Firebase Security Rules Documentation](https://firebase.google.com/docs/rules)
- [Firestore Security Rules Guide](https://firebase.google.com/docs/firestore/security/get-started)
- [Storage Security Rules Guide](https://firebase.google.com/docs/storage/security)
