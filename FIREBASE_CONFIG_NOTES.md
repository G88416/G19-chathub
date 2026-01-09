# Firebase Configuration Notes

## Hosting Configuration

### Public Directory
The hosting configuration uses `"public": "."` (root directory) because this is a **single-page application (SPA)** with `index.html` in the root directory. This is intentional and correct for this project structure.

### Security
While using the root as the public directory, we protect sensitive files through the `ignore` list:

**Protected Files:**
- Configuration files (`.firebaserc`, `firebase.json`)
- Security rules (`firestore.rules`, `storage.rules`)
- Scripts (`*.sh` files like `deploy-rules.sh`)
- Documentation (`*.md`, `*.txt` files)
- Hidden files (`.*` including `.git`, `.github`)
- Node modules and build artifacts

**Exposed Files:**
- `index.html` (main application)
- Any assets required by the application

### Alternative Approach
If you want to use a dedicated public directory in the future:

1. Create a `public/` directory
2. Move `index.html` to `public/`
3. Update `firebase.json`: `"public": "public"`
4. Keep rules files in the root for Firebase CLI to find them

However, for this simple SPA with a single HTML file, the current approach is cleaner and follows Firebase best practices for simple web apps.

## Why Not a Separate Public Directory?

For this project:
- ✅ Single HTML file (no build step)
- ✅ No asset bundling required
- ✅ Simpler project structure
- ✅ Rules files stay in root (expected by Firebase CLI)
- ✅ All sensitive files explicitly ignored
- ✅ Follows Firebase examples for simple web apps

The `ignore` list provides adequate security while maintaining simplicity.
