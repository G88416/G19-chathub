# Firebase Security Rules

This directory contains security rules for Firestore and Cloud Storage that protect your chat application.

## Files

- `firestore.rules` - Security rules for Firestore database
- `storage.rules` - Security rules for Cloud Storage

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

If you have Firebase CLI installed, you can deploy both rules at once:

```bash
# Install Firebase CLI (if not already installed)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project (if not already done)
firebase init

# Deploy the rules
firebase deploy --only firestore:rules,storage:rules
```

## Security Features

### Firestore Rules

The Firestore rules protect:

1. **User Profiles** (`/users/{userId}`)
   - ✅ Anyone authenticated can read user profiles (needed to search for chat partners)
   - ✅ Users can only create/update their own profile
   - ❌ No one can delete profiles

2. **Chat Messages** (`/chats/{chatId}/messages/{messageId}`)
   - ✅ Only chat participants can read messages
   - ✅ Participants can send messages with their own senderId
   - ✅ Messages are immutable (no updates/deletes)
   - ✅ Server timestamp validation

3. **Typing Status** (`/chats/{chatId}/status/typing`)
   - ✅ Participants can read and update typing indicators
   - ✅ Users can only set their own typing status

4. **Video Call Signaling** (`/chats/{chatId}/call/*`)
   - ✅ Participants can create/read call offers and answers
   - ✅ Participants can exchange ICE candidates for WebRTC

### Storage Rules

The Storage rules protect:

1. **File Uploads** (`/files/{chatId}/{fileName}`)
   - ✅ Only chat participants can access files
   - ✅ Max file size: 10MB
   - ✅ Allowed types: images, videos, audio, PDFs, documents, text
   - ✅ Files are immutable (no updates/deletes)

2. **Voice Messages** (`/voice/{chatId}/{fileName}`)
   - ✅ Only chat participants can access voice messages
   - ✅ Max file size: 5MB
   - ✅ Must be audio type
   - ✅ Voice messages are immutable

## Key Security Principles

1. **Authentication Required**: All operations require users to be signed in
2. **Authorization**: Users can only access their own chats (chatId contains their userId)
3. **Data Validation**: Server timestamps and senderIds are validated
4. **Immutability**: Messages and files cannot be edited or deleted
5. **Size Limits**: File uploads are limited to prevent abuse
6. **Type Validation**: File types are restricted to safe formats

## chatId Format

The chat application uses a format where chatId is created by sorting both participant userIds alphabetically and joining with underscore:

```
chatId = [userId1, userId2].sort().join('_')
```

Example: If user `abc123` chats with user `xyz789`, the chatId will be `abc123_xyz789`

This ensures:
- Same chatId is used regardless of who initiates the chat
- The `isParticipant()` helper verifies exact boundary matching with `.+` (one or more characters): the userId must be either at the start followed by `_` and another userId, or at the end preceded by `_` and another userId
- This prevents substring vulnerabilities and empty participant IDs (e.g., 'abc' won't match 'xabcy', and 'user_' is invalid)

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
