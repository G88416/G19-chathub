# Firebase Configuration Guide

This repository includes a complete `firebase.json` configuration file for deploying the ChatHub application to Firebase.

## Files

- **firebase.json** - Main Firebase configuration file
- **firestore.indexes.json** - Firestore database indexes for efficient queries
- **firestore.rules** - Firestore security rules
- **storage.rules** - Cloud Storage security rules

## What's Configured

### 1. Firestore Database
- **Rules**: Points to `firestore.rules` for security
- **Indexes**: Points to `firestore.indexes.json` for query optimization
- Message timestamps are indexed for efficient sorting

### 2. Cloud Storage
- **Rules**: Points to `storage.rules` for file upload security
- Protects profile photos, group photos, file uploads, and voice messages

### 3. Firebase Hosting
- **Public Directory**: Current directory (`.`) - serves `index.html`
- **SPA Routing**: All routes redirect to `index.html` for single-page app behavior
- **Ignored Files**: Excludes configuration files, markdown docs, and git files from deployment
- **Cache Headers**:
  - JS/CSS files: 1 hour cache (`max-age=3600`)
  - Images: 24 hours cache (`max-age=86400`)
- **Clean URLs**: Removes `.html` extensions
- **No Trailing Slashes**: Keeps URLs clean

## Deployment

### Prerequisites
1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

### Initialize Project (First Time Only)
If you haven't initialized Firebase in this directory:
```bash
firebase init
```
Select:
- ✓ Firestore
- ✓ Storage
- ✓ Hosting

When prompted, accept the existing `firebase.json` and other rule files.

### Deploy Everything
Deploy all services (Firestore, Storage, Hosting):
```bash
firebase deploy
```

### Deploy Specific Services

Deploy only Firestore rules:
```bash
firebase deploy --only firestore:rules
```

Deploy only Storage rules:
```bash
firebase deploy --only storage:rules
```

Deploy only Hosting:
```bash
firebase deploy --only hosting
```

Deploy Firestore indexes:
```bash
firebase deploy --only firestore:indexes
```

### Deploy Rules Only
```bash
firebase deploy --only firestore:rules,storage:rules
```

## Project Information

- **Project ID**: g19-chathub
- **Firebase Console**: https://console.firebase.google.com/project/g19-chathub

## Testing Deployment

After deploying, your app will be available at:
- **Live URL**: https://g19-chathub.web.app
- **Alternative URL**: https://g19-chathub.firebaseapp.com

## Troubleshooting

### "Project not found" error
Make sure you're logged into the correct Firebase account:
```bash
firebase logout
firebase login
```

### "Permission denied" error
Ensure you have the necessary permissions in the Firebase project. Contact the project owner if needed.

### Deployment takes too long
Use targeted deployments for faster updates:
```bash
firebase deploy --only hosting  # Just update the website
```

### Rules deployment fails
Validate your rules syntax in the Firebase Console before deploying with CLI.

## Additional Resources

- [Firebase CLI Documentation](https://firebase.google.com/docs/cli)
- [Firebase Hosting Guide](https://firebase.google.com/docs/hosting)
- [Firestore Rules Guide](https://firebase.google.com/docs/firestore/security/get-started)
- [Storage Rules Guide](https://firebase.google.com/docs/storage/security)

## Support

For detailed information about the security rules, see:
- `FIREBASE_RULES_README.md` - Comprehensive rules documentation
- `RULES_DEPLOYMENT_GUIDE.txt` - Step-by-step deployment guide
