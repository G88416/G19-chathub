# ChatHub - WhatsApp Style Chat Application

A real-time chat application with WhatsApp-inspired UI, built with Firebase and WebRTC.

## 🚨 IMPORTANT: First-Time Setup Required

**If you're getting "Missing or insufficient permissions" errors**, you need to deploy the Firebase security rules first!

### Quick Fix (2 minutes):
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Deploy the rules
firebase deploy --only firestore:rules,storage:rules
```

**OR** see the complete guide: [QUICK_FIX_PERMISSIONS.md](QUICK_FIX_PERMISSIONS.md)

---

## Features

### 🎨 WhatsApp-Style UI
- **Two-Panel Layout**: Left sidebar for chat list, right panel for active conversations
- **Dark Theme**: WhatsApp's signature dark color scheme
  - Background: #0b141a
  - Panels: #202c33
  - Accent: #00a884 (WhatsApp green)
- **Message Bubbles**: Styled exactly like WhatsApp
  - Sent messages: Dark green (#005c4b)
  - Received messages: Dark gray (#202c33)
- **Modern Design**: Rounded avatars, smooth animations, responsive layout
- **Profile Photos**: Display user profile pictures in chat headers and sidebar

### 👤 WhatsApp-Like Profile Setup
- **Profile Setup on First Login**: New users must set up their profile before accessing the app
  - **Name**: Required field (displayed to other users)
  - **Profile Photo**: Optional profile picture upload
  - **About/Status**: Optional status message (e.g., "Hey there! I am using ChatHub")
- **Profile Management**: Update your profile anytime through Settings

### ⚙️ Settings
- **User Settings**: WhatsApp-style settings panel to:
  - Update your name
  - Change profile photo
  - Edit your about/status
  - Toggle notification preferences
- **Profile Preview**: See your profile photo in the sidebar header

### 👥 Group Chats
- **Create Groups**: Form group conversations with multiple users
  - Set group name and description
  - Upload group photo
  - Add members by email, username, or phone
- **Group Management**: Admins can manage group settings
- **Group Security**: Firestore rules ensure only members can access group messages

### 💬 Chat Features
- **Real-time Messaging**: Instant text message delivery
- **Multi-format Support**: Send text, emojis, images, videos, and files
- **Voice Messages**: Record and send voice notes
- **Typing Indicators**: See when your friend is typing
- **Message Timestamps**: Know exactly when messages were sent
- **Online Status**: See who's online

### 📞 Voice & Video Calls
- **Voice Calls**: High-quality peer-to-peer audio-only calling
- **Video Calls**: WebRTC Video Calls with camera and audio
- **Modal Interface**: Clean, focused call experience

### 🔐 Authentication
- **Email/Password Login**: Standard authentication
- **Username Support**: Optional username-based login
- **Phone Authentication**: Login with phone number (SMS verification)

### 🔍 User Discovery
- **Multiple Search Methods**: Find friends by:
  - Email address
  - Username
  - Phone number

## How to Use

1. **Sign Up**: Create an account with email and password
2. **Set Up Profile**: 
   - Enter your name (required)
   - Upload a profile photo (optional)
   - Add an about/status message (optional)
3. **Login**: Use your credentials to access the app
4. **Start Chatting**: 
   - Enter your friend's email, username, or phone in the search box
   - Press Enter or click outside to start the chat
   - Begin messaging!
5. **Create Groups**: Click the group icon to create a group chat
6. **Update Settings**: Click your profile photo or the settings icon to manage your profile
7. **Send Media**: Click the attachment icon to send files
8. **Voice Messages**: Click the microphone to record voice notes
9. **Voice Call**: Click the phone icon to start an audio call
10. **Video Call**: Click the video camera icon to start a video call
11. **Emojis**: Click the smile icon to open the emoji picker

## Technical Details

### Built With
- **Firebase**: Backend services (Authentication, Firestore, Storage)
- **WebRTC**: Peer-to-peer video calling
- **Bootstrap 5**: Responsive UI framework
- **Bootstrap Icons**: Beautiful icon set
- **Vanilla JavaScript**: No heavy frameworks, fast and efficient

### Browser Compatibility
- Chrome/Edge (recommended)
- Firefox
- Safari
- Opera

### Features Summary
All functionality has been implemented:
- ✅ Authentication (email, username, phone)
- ✅ WhatsApp-style profile setup (name, photo, about)
- ✅ User settings page
- ✅ Profile photo display in UI
- ✅ Group chat creation and management
- ✅ Real-time messaging
- ✅ File uploads and sharing
- ✅ Voice recording
- ✅ Voice calls (audio-only)
- ✅ Video calls
- ✅ Emoji support
- ✅ Typing indicators
- ✅ Online status
- ✅ Message persistence (history never disappears)
- ✅ Self-chat support
- ✅ Connection status monitoring
- ✅ Performance optimizations
- ✅ Enhanced Firestore security rules
- ✅ Enhanced Storage security rules

## Development

Simply open `index.html` in a web browser. No build step required!

For local development:
```bash
python3 -m http.server 8080
# Then open http://localhost:8080
```

## 🚀 Deployment

### Deploy Security Rules (Required!)

The app requires Firebase security rules to be deployed before it will work.

**Method 1: Using Firebase CLI**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Deploy rules
firebase deploy --only firestore:rules,storage:rules

# OR use the deployment script
./deploy-rules.sh
```

**Method 2: Using Firebase Console**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: **g19-chathub**
3. Deploy Firestore rules:
   - Navigate to **Firestore Database** → **Rules**
   - Copy contents of `firestore.rules`
   - Paste and click **Publish**
4. Deploy Storage rules:
   - Navigate to **Storage** → **Rules**
   - Copy contents of `storage.rules`
   - Paste and click **Publish**

**For detailed instructions, see:** [QUICK_FIX_PERMISSIONS.md](QUICK_FIX_PERMISSIONS.md)

### Deploy App (Optional - Hosting)

To deploy the app itself to Firebase Hosting:
```bash
firebase deploy --only hosting
```

## 🔧 Troubleshooting

### "Missing or insufficient permissions" Error

This is the most common issue. It means Firebase security rules haven't been deployed.

**Solution:**
1. Deploy the rules using one of the methods above
2. Clear browser cache and cookies
3. Log out and log back in
4. Try again

**Still not working?**
- Verify rules are published in Firebase Console
- Check that you're signed in
- Make sure Firestore and Storage are enabled in your Firebase project
- See [QUICK_FIX_PERMISSIONS.md](QUICK_FIX_PERMISSIONS.md) for detailed troubleshooting

### File Upload Fails

- Check file size (10MB max for files, 5MB for voice/photos)
- Verify file type is allowed
- Make sure Storage rules are deployed

### Can't Find Users

- User must be registered in the app first
- Try both email and username
- Check that the user profile was created successfully

## Security Features

### Enhanced Firestore Rules
The app includes comprehensive security rules that:
- ✅ Require authentication for all operations
- ✅ Validate user profile fields (name and about are required on creation)
- ✅ Support group chat permissions (members-only access)
- ✅ Protect user profiles (users can only edit their own)
- ✅ Validate message sender IDs
- ✅ Ensure chat participants can only access their own chats
- ✅ Support call signaling security

### Enhanced Storage Rules
Storage rules provide:
- ✅ Profile photo upload security (5MB limit, image types only)
- ✅ Group photo upload security (admins only, 5MB limit)
- ✅ File upload validation (10MB limit, safe file types)
- ✅ Voice message validation (5MB limit, audio types only)
- ✅ Participant-based access control

## UI Transformation

The app features a WhatsApp-inspired interface:
- Two-panel WhatsApp layout
- Dark theme with green accents (#00a884)
- Sidebar for chat list
- Modern message bubbles
- Modal video calls
- Profile photos in headers and sidebar
- Settings and group creation modals
- Clean, professional interface

## License

MIT License - Feel free to use and modify!

## Credits

Developed for the G19-ChatHub project.
