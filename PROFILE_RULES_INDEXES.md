# Firestore Profile Rules and Indexes Documentation

## Overview
This document explains the profile (users collection) security rules and indexes for the ChatHub application.

## Profile Collection: `/users/{userId}`

The users collection stores user profile information including authentication data (email, username, phone) and profile details (name, photo, about, settings).

### Authentication Rules

All profile rules require user authentication via `isSignedIn()` helper function:

```javascript
function isSignedIn() {
  return request.auth != null;
}
```

### Security Rules Summary

#### READ Access
- **Who**: Any authenticated user
- **Rule**: `allow read: if isSignedIn();`
- **Purpose**: 
  - Allows users to search for other users by email/username/phone
  - Enables displaying user names and photos in chat interface
  - Required for group invitation lookups

#### CREATE Access
- **Who**: Only the profile owner (user creating their own profile)
- **Rule**: `allow create: if isOwner(userId) && request.resource.data.keys().hasAll(['name']) && request.resource.data.name is string && request.resource.data.name.size() > 0;`
- **Requirements**:
  - User must be authenticated (`isOwner` checks `request.auth.uid == userId`)
  - Profile must include 'name' field
  - Name must be a non-empty string
- **Optional Fields**: email, emailLower, username, phone, photoURL, about, online, lastSeen, settings

#### UPDATE Access
- **Who**: Only the profile owner
- **Rule**: `allow update: if isOwner(userId);`
- **Allowed Updates**: name, about, photoURL, online status, lastSeen, settings
- **Use Cases**:
  - Profile editing in settings
  - Online status tracking during active sessions
  - Notification preferences

#### DELETE Access
- **Who**: No one (DELETE operations are not allowed)
- **Reason**: Maintains chat history integrity
- **Alternative**: Use Firebase Admin SDK for account deletion if needed

### Helper Functions

```javascript
// Check if user is the owner of a document
function isOwner(userId) {
  return isSignedIn() && request.auth.uid == userId;
}
```

## Firestore Indexes

The `firestore.indexes.json` file defines single-field indexes for efficient profile queries.

### Required Indexes

All indexes are for the **users** collection with COLLECTION queryScope:

1. **username index**
   - Field: `username` (ASCENDING)
   - Used for: Username-based login, user search by username
   - Query: `where('username', '==', username)`

2. **emailLower index**
   - Field: `emailLower` (ASCENDING)
   - Used for: Case-insensitive email-based login, email search
   - Query: `where('emailLower', '==', emailLower)`

3. **email index**
   - Field: `email` (ASCENDING)
   - Used for: Direct email queries, fallback searches
   - Query: `where('email', '==', email)`

4. **phone index**
   - Field: `phone` (ASCENDING)
   - Used for: Phone number authentication, phone-based user search
   - Query: `where('phone', '==', phone)`

### Query Patterns

The application performs the following queries on the users collection:

```javascript
// Username lookup during signup
query(collection(db, 'users'), where('username', '==', username))

// Email-based login (case-insensitive)
query(collection(db, 'users'), where('emailLower', '==', identifierLower))

// Username-based login
query(collection(db, 'users'), where('username', '==', identifierLower))

// Phone-based login
query(collection(db, 'users'), where('phone', '==', identifier))

// Email search in chat partner finder
query(collection(db, 'users'), where('email', '==', partnerInput))
```

All queries are simple equality queries on single fields, which is why only single-field indexes are needed.

## Deployment

### Deploy Rules and Indexes Together

**Option 1: Firebase CLI (Recommended)**
```bash
firebase deploy --only firestore
```

This command deploys both:
- `firestore.rules` (security rules)
- `firestore.indexes.json` (index definitions)

**Option 2: Deploy Separately**
```bash
# Deploy only rules
firebase deploy --only firestore:rules

# Deploy only indexes
firebase deploy --only firestore:indexes
```

**Option 3: Firebase Console**
1. **Rules**: Firebase Console → Firestore Database → Rules tab → Copy content from `firestore.rules` → Publish
2. **Indexes**: Firebase Console → Firestore Database → Indexes tab → Create indexes manually or import `firestore.indexes.json`

### Verify Deployment

After deployment:
1. Check Firebase Console → Firestore Database → Rules tab to verify rules are published
2. Check Firebase Console → Firestore Database → Indexes tab to verify indexes are created
3. Test authentication flows (email, username, phone login)
4. Test user search functionality

## Authentication Support

The profile rules support three authentication methods:

### 1. Email Authentication
- Users sign up with email and password
- Profile stores: `email`, `emailLower` (lowercase for case-insensitive queries)
- Login query: `where('emailLower', '==', email.toLowerCase())`

### 2. Username Authentication
- Users can optionally set a username during signup
- Profile stores: `username` (lowercase)
- Login query: `where('username', '==', username.toLowerCase())`
- Username uniqueness is validated before signup

### 3. Phone Authentication
- Users can authenticate via SMS/phone number
- Profile stores: `phone` (formatted phone number)
- Login query: `where('phone', '==', phoneNumber)`

## Security Best Practices

### Implemented Protections

1. **Authentication Required**: All operations require `isSignedIn()`
2. **Owner-Only Modifications**: Users can only create/update their own profiles
3. **Field Validation**: Name field is required and must be non-empty
4. **Type Checking**: Name must be a string
5. **Read Access Control**: Only authenticated users can read profiles (prevents anonymous access)
6. **No Deletion**: Prevents accidental profile deletion that could break chat history

### Attack Prevention

1. **Profile Spoofing**: `isOwner()` ensures userId matches authenticated user
2. **Unauthorized Updates**: Only profile owner can modify their data
3. **Anonymous Access**: All operations require authentication
4. **Data Integrity**: Required field validation prevents incomplete profiles

## Testing Profile Rules

### Test Cases

1. **Authenticated Read**
   - ✅ Signed-in user can read any profile
   - ❌ Anonymous user cannot read profiles

2. **Profile Creation**
   - ✅ User can create their own profile with name field
   - ❌ User cannot create profile without name field
   - ❌ User cannot create another user's profile

3. **Profile Updates**
   - ✅ User can update their own profile fields
   - ❌ User cannot update another user's profile

4. **Profile Deletion**
   - ❌ No user can delete profiles (including their own)

5. **Authentication Queries**
   - ✅ Query by email finds matching profile
   - ✅ Query by username finds matching profile
   - ✅ Query by phone finds matching profile
   - ✅ Case-insensitive email search works

### Manual Testing Steps

```javascript
// 1. Test profile read (should succeed)
const user = await getDoc(doc(db, 'users', someUserId));

// 2. Test profile creation (should succeed with name)
await setDoc(doc(db, 'users', currentUser.uid), {
  name: 'John Doe',
  email: 'john@example.com',
  emailLower: 'john@example.com'
});

// 3. Test username query (should find user)
const q = query(collection(db, 'users'), where('username', '==', 'johndoe'));
const results = await getDocs(q);

// 4. Test unauthorized update (should fail)
await updateDoc(doc(db, 'users', anotherUserId), { name: 'Hacked' }); // Error

// 5. Test deletion (should fail)
await deleteDoc(doc(db, 'users', currentUser.uid)); // Error
```

## Troubleshooting

### Common Issues

#### "Missing or insufficient permissions"
- **Cause**: User not authenticated or trying to access wrong userId
- **Solution**: Verify user is signed in and accessing their own profile

#### "PERMISSION_DENIED: Missing or insufficient permissions"
- **Cause**: Rules not deployed or user not authenticated
- **Solution**: Deploy rules and ensure authentication

#### "Query requires an index"
- **Cause**: Indexes not deployed
- **Solution**: Run `firebase deploy --only firestore:indexes`

#### "Username/email not found during login"
- **Cause**: Indexes not created or query mismatch
- **Solution**: 
  - Check indexes are deployed in Firebase Console
  - Verify field names match exactly (username, emailLower, phone)
  - Ensure case-sensitivity handling (use lowercase for username/email queries)

### Index Build Time

- Single-field indexes typically build in seconds to minutes
- Check index status in Firebase Console → Firestore Database → Indexes
- Wait for status to change from "Building" to "Enabled" before testing

## Summary

✅ **Profile Rules**: Comprehensive authentication-based security for users collection  
✅ **Indexes**: Efficient queries for username, email, and phone authentication  
✅ **Authentication**: Support for email, username, and phone login methods  
✅ **Security**: Owner-only access with field validation  
✅ **Documentation**: Complete guide for deployment and testing  

The profile rules and indexes are designed to work together to provide secure, efficient user profile management with multiple authentication methods.
