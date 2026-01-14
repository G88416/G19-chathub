#!/bin/bash

# Firebase Rules Deployment Script for G19-ChatHub
# This script deploys Firestore and Storage security rules to Firebase
#
# Usage:
#   ./deploy-rules.sh          # Interactive mode
#   ./deploy-rules.sh --yes    # Non-interactive mode (auto-confirm)

set -e  # Exit on error

# Check for --yes flag for non-interactive mode
NON_INTERACTIVE=false
if [ "$1" == "--yes" ] || [ "$1" == "-y" ] || [ "$1" == "--force" ]; then
    NON_INTERACTIVE=true
fi

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║  Firebase Security Rules Deployment - G19-ChatHub                  ║"
echo "║  🔧 Includes permission issue fixes                                ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed."
    echo ""
    echo "To install Firebase CLI, run:"
    echo "  npm install -g firebase-tools"
    echo ""
    exit 1
fi

echo "✓ Firebase CLI found"
echo ""

# Check if user is logged in
echo "Checking Firebase authentication..."
if ! firebase projects:list &> /dev/null; then
    echo "❌ Not logged in to Firebase."
    echo ""
    echo "Please run: firebase login"
    echo ""
    exit 1
fi

echo "✓ Firebase authentication verified"
echo ""

# Check if rules files exist
if [ ! -f "firestore.rules" ]; then
    echo "❌ firestore.rules file not found!"
    exit 1
fi

if [ ! -f "storage.rules" ]; then
    echo "❌ storage.rules file not found!"
    exit 1
fi

echo "✓ Rules files found"
echo ""

# Display the project - use more precise grep with word boundaries
PROJECT=$(firebase projects:list 2>/dev/null | grep -w "g19-chathub" || echo "")
if [ -z "$PROJECT" ]; then
    echo "⚠️  Warning: Project 'g19-chathub' not found in your Firebase projects."
    echo "Available projects:"
    firebase projects:list
    echo ""
    
    if [ "$NON_INTERACTIVE" = false ]; then
        read -p "Do you want to continue anyway? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Deployment cancelled."
            exit 1
        fi
    else
        echo "Running in non-interactive mode. Continuing with deployment..."
    fi
fi

echo "📋 Deploying to project: g19-chathub"
echo ""

# Deploy the rules
echo "🚀 Deploying Firestore and Storage rules..."
echo ""

if firebase deploy --only firestore:rules,storage:rules; then
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║  ✅ Deployment Successful!                                         ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "📝 What was deployed:"
    echo "  ✓ Firestore security rules (firestore.rules)"
    echo "  ✓ Storage security rules (storage.rules)"
    echo ""
    echo "🔧 Permission issues fixed:"
    echo "  ✓ Added status upload path to Storage rules"
    echo "  ✓ Fixed voice message permissions with improved participant check"
    echo "  ✓ Removed cross-service Firestore queries from Storage rules"
    echo "  ✓ Fixed email/phone validation for all auth methods"
    echo "  ✓ Simplified group photo permissions"
    echo ""
    echo "🔐 Security features now active:"
    echo "  ✓ Authentication required for all operations"
    echo "  ✓ User profile protection"
    echo "  ✓ Chat message validation"
    echo "  ✓ File upload restrictions (10MB for status, 10MB for files, 5MB for voice)"
    echo "  ✓ Group chat permissions"
    echo "  ✓ Status upload permissions (24-hour stories)"
    echo ""
    echo "✨ New Features:"
    echo "  ✓ Enhanced status canvas with drawing tools, filters, and text overlay"
    echo "  ✓ Undo/redo functionality for status editing"
    echo "  ✓ Adjustable brush size (1-20px) with 9 color options"
    echo "  ✓ Image filters: Grayscale, Sepia, Brightness, Contrast"
    echo "  ✓ Improved mobile touch support for canvas drawing"
    echo ""
    echo "✨ Your app should now work without permission errors!"
    echo ""
    echo "📖 For details about the fixes, see: PERMISSION_FIX_GUIDE.md"
    echo ""
    echo "🧪 Test your deployment:"
    echo "  1. Open your app: https://g19-chathub.web.app"
    echo "  2. Sign up or log in"
    echo "  3. Try sending a message"
    echo "  4. Upload a file"
    echo ""
else
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║  ❌ Deployment Failed                                              ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Common issues:"
    echo "  • Not logged in: Run 'firebase login'"
    echo "  • Wrong project: Check .firebaserc file"
    echo "  • Permission denied: Check your Firebase project access"
    echo ""
    exit 1
fi
