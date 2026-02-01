# 🎯 Quick Setup: Google Sign-In Configuration

## Your SHA-1 Fingerprint (Debug)

```
97:2A:42:77:38:B0:0D:87:0A:C4:C2:F8:10:B7:4A:39:8E:1A:3B:41
```

## Your Package Name

```
com.example.event_manager_ui
```

---

## 📋 Next Steps to Complete Setup:

### Step 1: Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one

### Step 2: Enable Google Sign-In API

1. Navigate to **APIs & Services** > **Library**
2. Search for "Google Sign-In API" or "Google+ API"
3. Click **Enable**

### Step 3: Configure OAuth Consent Screen

1. Go to **APIs & Services** > **OAuth consent screen**
2. Select **External** user type
3. Fill in:
   - **App name**: Event Manager
   - **User support email**: Your email
   - **Developer contact**: Your email
4. Click **Save and Continue**
5. Add scopes: `email`, `profile`
6. Click **Save and Continue**
7. Add test users (your Google account email)
8. Click **Save and Continue**

### Step 4: Create OAuth 2.0 Client ID

1. Go to **APIs & Services** > **Credentials**
2. Click **+ CREATE CREDENTIALS** > **OAuth client ID**
3. Select **Android** as application type
4. Enter:
   - **Package name**: `com.example.event_manager_ui`
   - **SHA-1 certificate fingerprint**: `97:2A:42:77:38:B0:0D:87:0A:C4:C2:F8:10:B7:4A:39:8E:1A:3B:41`
5. Click **CREATE**

### Step 5: Test the Integration

```powershell
# Make sure backend is running
cd C:\Users\Dell\Desktop\MAD\backend
npm start

# In a new terminal, run the Flutter app
cd C:\Users\Dell\Desktop\MAD
flutter run
```

---

## ✅ What's Already Done:

- ✅ Google Sign-In package added to pubspec.yaml
- ✅ GoogleAuthService created for authentication
- ✅ API service updated with Google Sign-In endpoint
- ✅ Login screen has functional Google button
- ✅ Register screen has functional Google button
- ✅ Backend route `/api/auth/google` configured
- ✅ User model updated with `googleId` field
- ✅ SHA-1 fingerprint retrieved

---

## 🧪 Testing the Sign-In:

1. **Start Backend Server**:

   ```powershell
   cd C:\Users\Dell\Desktop\MAD\backend
   npm start
   ```

2. **Run Flutter App**:

   ```powershell
   cd C:\Users\Dell\Desktop\MAD
   flutter run
   ```

3. **Test Flow**:
   - Open the app
   - Go to Login or Register screen
   - Tap the "Google" button
   - Select your Google account
   - Grant permissions
   - You should be logged in and redirected to home screen

---

## 🔧 Troubleshooting:

### "Sign in failed" or "Developer Error"

- Wait 5-10 minutes after creating OAuth credentials (propagation time)
- Verify SHA-1 fingerprint matches exactly
- Check package name is correct in Google Console

### Backend Connection Issues

- Ensure backend is running on `https://mad-edi9.onrender.com`
- Or update `lib/core/api_service.dart` baseUrl if using local backend

### Account Picker Doesn't Show

- Clear app data: Settings > Apps > Event Manager > Clear Data
- Or uninstall and reinstall the app

---

## 📱 App Package Info:

- **Package Name**: com.example.event_manager_ui
- **Debug SHA-1**: 97:2A:42:77:38:B0:0D:87:0A:C4:C2:F8:10:B7:4A:39:8E:1A:3B:41
- **Debug SHA-256**: DF:F7:BF:56:21:2A:A0:47:43:A1:38:39:DB:E6:58:12:F7:3C:E8:10:2B:7D:CF:17:DC:DA:6A:4E:DF:4B:29:17

---

## 🚀 Quick Command Reference:

```powershell
# Get dependencies
flutter pub get

# Get SHA-1 (if needed again)
cd android
.\gradlew signingReport
cd ..

# Run app
flutter run

# Start backend
cd backend
npm start
```

---

**Important**: After configuring Google Cloud Console, wait 5-10 minutes before testing to allow changes to propagate!
