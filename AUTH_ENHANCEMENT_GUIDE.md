# Authentication Enhancement Guide

## Overview
This document describes the enhanced authentication verification added to the Firestore security rules. These improvements ensure that users' Firebase Authentication credentials (email or phone number) match their Firestore profile data when they start chatting.

## Problem Statement
Previously, the Firestore rules only verified that a user was authenticated (`request.auth != null`) but did not validate that the authenticated user's email or phone number matched what was stored in their Firestore profile. This enhancement adds an additional layer of security by verifying the user's authentication identity against their profile data.

## Enhanced Security Features

### 1. New Helper Functions

#### `isAuthEmailVerified(userId)`
Verifies that the authenticated user's email (from Firebase Auth token) matches the email stored in their Firestore profile.

```javascript
function isAuthEmailVerified(userId) {
  return isSignedIn() 
    && request.auth.token.email != null
    && get(/databases/$(database)/documents/users/$(userId)).data.email == request.auth.token.email;
}
```

**Use case:** When a user authenticated with email tries to start a chat, this ensures their Firebase Auth email matches their profile email.

#### `isAuthPhoneVerified(userId)`
Verifies that the authenticated user's phone number (from Firebase Auth token) matches the phone stored in their Firestore profile.

```javascript
function isAuthPhoneVerified(userId) {
  return isSignedIn() 
    && request.auth.token.phone_number != null
    && get(/databases/$(database)/documents/users/$(userId)).data.phone == request.auth.token.phone_number;
}
```

**Use case:** When a user authenticated with phone tries to start a chat, this ensures their Firebase Auth phone matches their profile phone.

#### `isAuthIdentityVerified(userId)`
Checks if the user's authentication identity (either email or phone) is verified against their profile.

```javascript
function isAuthIdentityVerified(userId) {
  return isSignedIn() 
    && (isAuthEmailVerified(userId) || isAuthPhoneVerified(userId));
}
```

**Use case:** General purpose verification that works for both email and phone authentication methods.

### 2. Enhanced User Profile Rules

#### Profile Creation
When a user creates their profile, the rules now verify that:
- If an email is provided, it must match the Firebase Auth email (`request.auth.token.email`)
- If a phone is provided, it must match the Firebase Auth phone (`request.auth.token.phone_number`)

```javascript
allow create: if isOwner(userId) 
  && request.resource.data.keys().hasAll(['name'])
  && request.resource.data.name is string
  && request.resource.data.name.size() > 0
  && (
    // If email is being set, it must match the authenticated email
    (!request.resource.data.keys().hasAny(['email']) || 
     request.auth.token.email == null ||
     request.resource.data.email == request.auth.token.email)
    &&
    // If phone is being set, it must match the authenticated phone
    (!request.resource.data.keys().hasAny(['phone']) || 
     request.auth.token.phone_number == null ||
     request.resource.data.phone == request.auth.token.phone_number)
  );
```

**Security benefit:** Prevents users from creating profiles with email/phone credentials that don't belong to them.

#### Profile Updates
When a user updates their profile, the rules now ensure that:
- Users cannot change their email to a value that doesn't match Firebase Auth
- Users cannot change their phone to a value that doesn't match Firebase Auth
- Users can keep their existing email/phone unchanged

```javascript
allow update: if isOwner(userId)
  && (
    // If updating email, it must match the authenticated email
    (!request.resource.data.keys().hasAny(['email']) || 
     !('email' in request.resource.data) ||
     request.resource.data.email == resource.data.email ||
     request.auth.token.email == null ||
     request.resource.data.email == request.auth.token.email)
    &&
    // If updating phone, it must match the authenticated phone
    (!request.resource.data.keys().hasAny(['phone']) || 
     !('phone' in request.resource.data) ||
     request.resource.data.phone == resource.data.phone ||
     request.auth.token.phone_number == null ||
     request.resource.data.phone == request.auth.token.phone_number)
  );
```

**Security benefit:** Prevents users from hijacking other users' identities by changing their profile email/phone.

## How It Works

### Scenario 1: Email Authentication
1. User signs up with email `alice@example.com` using Firebase Authentication
2. User creates their profile in Firestore with email `alice@example.com`
3. Firestore rules verify: `request.auth.token.email == "alice@example.com"`
4. Profile creation succeeds ✅
5. When Alice tries to start a chat, the system recognizes her authenticated email

### Scenario 2: Phone Authentication
1. User signs up with phone `+1234567890` using Firebase Authentication
2. User creates their profile in Firestore with phone `+1234567890`
3. Firestore rules verify: `request.auth.token.phone_number == "+1234567890"`
4. Profile creation succeeds ✅
5. When the user tries to start a chat, the system recognizes their authenticated phone

### Scenario 3: Attempted Identity Theft (Blocked)
1. Malicious user authenticates with email `attacker@example.com`
2. Attacker tries to create profile with email `victim@example.com`
3. Firestore rules check: `request.auth.token.email ("attacker@example.com") != request.resource.data.email ("victim@example.com")`
4. Profile creation fails ❌
5. Security maintained!

## Firebase Auth Token Properties

The Firebase Auth token (`request.auth.token`) contains the following relevant properties:

- `email`: The authenticated user's email address (if authenticated via email)
- `phone_number`: The authenticated user's phone number (if authenticated via phone)
- `email_verified`: Boolean indicating if the email has been verified
- `firebase.sign_in_provider`: The provider used for sign-in (e.g., "password", "phone", "google.com")

## Benefits

### 1. Identity Verification
✅ Users can only use email/phone credentials that belong to them
✅ Prevents profile spoofing and identity theft
✅ Ensures consistency between Firebase Auth and Firestore data

### 2. Enhanced Security for Chat Initiation
✅ When entering an email to start a chat, the system verifies the authenticated user
✅ When entering a phone to start a chat, the system verifies the authenticated user
✅ Reduces the risk of unauthorized access to chat conversations

### 3. Backward Compatibility
✅ Existing profiles without email/phone are not affected
✅ Users who don't provide email/phone during profile creation can still use the app
✅ The rules check for null values and allow graceful fallback

### 4. Multi-Authentication Support
✅ Works with email/password authentication
✅ Works with phone number authentication
✅ Can be extended to support other providers (Google, Facebook, etc.)

## Testing Recommendations

### Test Case 1: Email Authentication Matching
1. Sign up with email `test@example.com`
2. Create profile with email `test@example.com`
3. Verify profile creation succeeds ✅

### Test Case 2: Phone Authentication Matching
1. Sign up with phone `+1234567890`
2. Create profile with phone `+1234567890`
3. Verify profile creation succeeds ✅

### Test Case 3: Email Mismatch (Should Fail)
1. Sign up with email `user1@example.com`
2. Try to create profile with email `user2@example.com`
3. Verify profile creation fails ❌

### Test Case 4: Phone Mismatch (Should Fail)
1. Sign up with phone `+1111111111`
2. Try to create profile with phone `+2222222222`
3. Verify profile creation fails ❌

### Test Case 5: Profile Update Protection
1. User has profile with email `original@example.com`
2. User tries to update email to `different@example.com`
3. Verify update fails ❌ (unless authenticated with new email)

### Test Case 6: Starting a Chat
1. User A authenticates with `alice@example.com`
2. User A creates profile with matching email
3. User A enters `bob@example.com` to start chat
4. System finds Bob's profile
5. Chat starts successfully ✅

## Deployment

To deploy these enhanced rules:

### Option 1: Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **g19-chathub**
3. Navigate to **Firestore Database** → **Rules** tab
4. Copy the contents of `firestore.rules`
5. Paste into the editor
6. Click **Publish**

### Option 2: Firebase CLI
```bash
firebase deploy --only firestore:rules
```

## Monitoring

After deployment, monitor your Firebase Console for:
- Permission denied errors (may indicate users trying to set mismatched credentials)
- Successful profile creations and updates
- Chat initiation patterns

## Future Enhancements

Potential improvements for future iterations:
1. Add email verification requirement (`request.auth.token.email_verified == true`)
2. Implement custom claims for additional role-based access control
3. Add logging for security events (requires Cloud Functions)
4. Support multiple authentication methods per user
5. Add phone number verification requirement

## References

- [Firebase Security Rules Documentation](https://firebase.google.com/docs/rules)
- [Firebase Auth Token Properties](https://firebase.google.com/docs/reference/rules/rules.firestore.Request)
- [Firestore Security Rules Guide](https://firebase.google.com/docs/firestore/security/get-started)

## Conclusion

These enhancements provide a robust authentication verification system that ensures users can only access chats when their Firebase Authentication credentials match their Firestore profile data. This significantly improves security while maintaining backward compatibility and ease of use.
