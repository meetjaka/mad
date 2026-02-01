# Google Sign-In Setup Guide

## Overview

This guide will help you configure Google Sign-In for your Event Manager app.

## 1. Google Cloud Console Setup

### Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the **Google+ API** for your project

### Configure OAuth Consent Screen

1. Navigate to **APIs & Services** > **OAuth consent screen**
2. Choose **External** user type
3. Fill in the required information:
   - App name: Event Manager
   - User support email: Your email
   - Developer contact email: Your email
4. Add scopes: `email` and `profile`
5. Save and continue

### Create OAuth 2.0 Credentials

#### For Android:

1. Go to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **OAuth client ID**
3. Select **Android** as application type
4. Enter your package name: `com.example.event_manager_ui`
5. Get your SHA-1 certificate fingerprint (see below)
6. Click **Create**

#### For Web (optional - for testing):

1. Create another OAuth client ID
2. Select **Web application**
3. Add authorized JavaScript origins (if needed)
4. Click **Create**

## 2. Get SHA-1 Certificate Fingerprint

### Debug Certificate (for development)

Run this command in your terminal:

**Windows (PowerShell):**

```powershell
cd C:\Users\Dell\Desktop\MAD\android
.\gradlew signingReport
```

**Windows (CMD):**

```cmd
cd C:\Users\Dell\Desktop\MAD\android
gradlew signingReport
```

Look for the SHA-1 fingerprint under the **debug** variant.

### Alternative Method:

```powershell
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

### Release Certificate (for production)

When you create a release keystore:

```powershell
keytool -list -v -keystore path\to\your\release-keystore.jks -alias your-alias
```

## 3. Android Configuration

### Update build.gradle (if needed)

The app should already have the necessary dependencies, but verify:

File: `android/app/build.gradle`

```gradle
dependencies {
    // ... other dependencies
}
```

### Update AndroidManifest.xml (if needed)

No additional configuration is typically required for `google_sign_in` package.

## 4. Install Dependencies

Run this command to install the new package:

```powershell
cd C:\Users\Dell\Desktop\MAD
flutter pub get
```

## 5. Testing

### Test the Sign-In Flow:

1. Run the app: `flutter run`
2. Navigate to the login or register screen
3. Tap the "Google" button
4. Select a Google account
5. Grant permissions
6. You should be redirected to the home screen

### Common Issues:

#### "Sign-in failed" or "Developer Error"

- **Cause**: SHA-1 fingerprint mismatch or missing OAuth configuration
- **Solution**:
  1. Verify SHA-1 in Google Cloud Console matches your debug certificate
  2. Make sure OAuth consent screen is configured
  3. Wait a few minutes for changes to propagate

#### "PlatformException"

- **Cause**: Missing Google Services configuration
- **Solution**: Ensure package name matches in:
  - `android/app/build.gradle`
  - Google Cloud Console OAuth client

#### "Account picker doesn't appear"

- **Cause**: Previous session cached
- **Solution**: Clear app data or reinstall the app

## 6. Web Client ID (Optional)

If you need additional verification, you can add the Web Client ID:

1. Get your Web Client ID from Google Cloud Console
2. Update `lib/core/google_auth_service.dart`:

```dart
static final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'profile',
  ],
  // Add this line with your actual Web Client ID
  // serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
);
```

## 7. Backend Configuration

The backend is already configured to handle Google Sign-In at the `/api/auth/google` endpoint.

Make sure your backend server is running:

```powershell
cd C:\Users\Dell\Desktop\MAD\backend
npm start
```

## 8. Production Checklist

Before releasing to production:

- [ ] Create a release keystore
- [ ] Add release SHA-1 to Google Cloud Console
- [ ] Update OAuth consent screen to "In Production"
- [ ] Add privacy policy URL
- [ ] Test with multiple Google accounts
- [ ] Verify backend is deployed and accessible
- [ ] Update API base URL if needed

## Important Files Modified

### Flutter (Frontend):

- ✅ `pubspec.yaml` - Added google_sign_in dependency
- ✅ `lib/core/google_auth_service.dart` - Google Sign-In service
- ✅ `lib/core/api_service.dart` - Added googleSignIn API method
- ✅ `lib/screens/auth/login_screen.dart` - Added Google Sign-In button
- ✅ `lib/screens/auth/register_screen.dart` - Added Google Sign-In button

### Backend:

- ✅ `backend/models/User.js` - Added googleId field
- ✅ `backend/routes/auth.js` - Added /google endpoint

## Support

If you encounter any issues:

1. Check the debug console for error messages
2. Verify all SHA-1 certificates are added to Google Cloud Console
3. Ensure backend is running and accessible
4. Clear app cache and reinstall if needed

## Quick Start Command

To get started immediately:

```powershell
# Install dependencies
flutter pub get

# Get SHA-1 fingerprint
cd android
.\gradlew signingReport
cd ..

# Run the app
flutter run
```

Copy the SHA-1 fingerprint and add it to your Google Cloud Console OAuth client!
