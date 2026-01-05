# ChatHub - WhatsApp Style Chat Application

A real-time chat application with WhatsApp-inspired UI, built with Firebase and WebRTC.

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

### 💬 Chat Features
- **Real-time Messaging**: Instant text message delivery
- **Multi-format Support**: Send text, emojis, images, videos, and files
- **Voice Messages**: Record and send voice notes
- **Typing Indicators**: See when your friend is typing
- **Message Timestamps**: Know exactly when messages were sent
- **Online Status**: See who's online

### 📞 Video Calls
- **WebRTC Video Calls**: High-quality peer-to-peer video calling
- **Modal Interface**: Clean, focused video call experience

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
2. **Login**: Use your credentials to access the app
3. **Start Chatting**: 
   - Enter your friend's email, username, or phone in the search box
   - Press Enter or click outside to start the chat
   - Begin messaging!
4. **Send Media**: Click the attachment icon to send files
5. **Voice Messages**: Click the microphone to record voice notes
6. **Video Call**: Click the video camera icon to start a video call
7. **Emojis**: Click the smile icon to open the emoji picker

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

### Features Preserved from Original
All original functionality has been maintained:
- ✅ Authentication (email, username, phone)
- ✅ Real-time messaging
- ✅ File uploads and sharing
- ✅ Voice recording
- ✅ Video calls
- ✅ Emoji support
- ✅ Typing indicators
- ✅ Online status

## Development

Simply open `index.html` in a web browser. No build step required!

For local development:
```bash
python3 -m http.server 8080
# Then open http://localhost:8080
```

## UI Transformation

The app has been completely redesigned from a Bootstrap card-based layout to a WhatsApp-inspired interface:

### Before
- Single card layout
- Light theme with purple gradients
- Side-by-side video and chat
- Traditional form inputs

### After
- Two-panel WhatsApp layout
- Dark theme with green accents
- Sidebar for chat list
- Modern message bubbles
- Modal video calls
- Clean, professional interface

## License

MIT License - Feel free to use and modify!

## Credits

Developed for the G19-ChatHub project.
