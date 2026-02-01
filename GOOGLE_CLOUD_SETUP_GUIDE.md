# 🎯 Step-by-Step: Google Cloud Console Configuration

## Copy These Values First! 📋

**SHA-1 Fingerprint:**

```
97:2A:42:77:38:B0:0D:87:0A:C4:C2:F8:10:B7:4A:39:8E:1A:3B:41
```

**Package Name:**

```
com.example.event_manager_ui
```

---

## Step 1: Access Google Cloud Console 🌐

1. Open your browser
2. Go to: **https://console.cloud.google.com/**
3. Sign in with your Google account

---

## Step 2: Create/Select Project 📁

**Option A - Create New Project:**

1. Click the project dropdown at the top
2. Click **"New Project"**
3. Enter project name: **"Event Manager"** (or your choice)
4. Click **"Create"**
5. Wait for project creation
6. Select the new project from dropdown

**Option B - Use Existing Project:**

1. Click the project dropdown
2. Select your existing project

---

## Step 3: Enable Google Sign-In API ⚙️

1. In the left sidebar, click **"APIs & Services"** > **"Library"**
2. In the search bar, type: **"Google Sign-In"** or **"Google+ API"**
3. Click on **"Google+ API"** (or similar)
4. Click the blue **"ENABLE"** button
5. Wait for it to enable (5-10 seconds)

---

## Step 4: Configure OAuth Consent Screen 🔐

1. Go to **"APIs & Services"** > **"OAuth consent screen"** (left sidebar)

2. **User Type:**
   - Select ⚪ **"External"**
   - Click **"CREATE"**

3. **App Information:**
   - **App name:** `Event Manager`
   - **User support email:** Select your email from dropdown
   - **App logo:** (Optional - skip for now)
4. **App Domain:** (Optional - skip for now)

5. **Developer contact information:**
   - **Email addresses:** Enter your email
6. Click **"SAVE AND CONTINUE"**

7. **Scopes Screen:**
   - Click **"ADD OR REMOVE SCOPES"**
   - Find and check these scopes:
     - ✅ `.../auth/userinfo.email`
     - ✅ `.../auth/userinfo.profile`
   - Click **"UPDATE"**
   - Click **"SAVE AND CONTINUE"**

8. **Test Users:**
   - Click **"+ ADD USERS"**
   - Enter your Google account email
   - Click **"ADD"**
   - Click **"SAVE AND CONTINUE"**

9. **Summary:**
   - Review and click **"BACK TO DASHBOARD"**

---

## Step 5: Create OAuth 2.0 Client ID 🔑

1. Go to **"APIs & Services"** > **"Credentials"** (left sidebar)

2. Click **"+ CREATE CREDENTIALS"** at the top

3. Select **"OAuth client ID"** from dropdown

4. **If prompted about OAuth consent screen:**
   - Click **"CONFIGURE CONSENT SCREEN"**
   - Complete Step 4 above if not done
   - Return to **"Credentials"** > **"+ CREATE CREDENTIALS"** > **"OAuth client ID"**

5. **Application type:**
   - Select **"Android"** from dropdown

6. **Name:**
   - Enter: `Event Manager Android` (or your choice)

7. **Package name:**
   - Copy and paste: `com.example.event_manager_ui`

8. **SHA-1 certificate fingerprint:**
   - Copy and paste: `97:2A:42:77:38:B0:0D:87:0A:C4:C2:F8:10:B7:4A:39:8E:1A:3B:41`

9. Click **"CREATE"**

10. **Success Dialog:**
    - You'll see "OAuth client created"
    - Click **"OK"**

---

## Step 6: Verify Configuration ✅

1. Go to **"APIs & Services"** > **"Credentials"**
2. Under **"OAuth 2.0 Client IDs"** section, you should see:
   - **Name:** Event Manager Android (or what you named it)
   - **Type:** Android
   - **Creation date:** Today's date

3. Click on the credential name to verify:
   - Package name: `com.example.event_manager_ui`
   - SHA-1: `97:2A:42:77:38:B0:0D:87:0A:C4:C2:F8:10:B7:4A:39:8E:1A:3B:41`

---

## ⏰ IMPORTANT: Wait Time

**After completing these steps, wait 5-10 minutes before testing!**

Google needs time to propagate the configuration changes across their servers.

---

## 🧪 Test Your Setup

After waiting 5-10 minutes:

### Start Backend:

```powershell
cd C:\Users\Dell\Desktop\MAD\backend
npm start
```

### Run App:

```powershell
cd C:\Users\Dell\Desktop\MAD
flutter run
```

### Test Flow:

1. Open app on Android device/emulator
2. Navigate to Login screen
3. Tap **"Google"** button
4. **Expected:** Google account picker appears
5. Select your account
6. Grant permissions
7. **Expected:** Redirected to home screen

---

## ❌ Troubleshooting

### Error: "Developer Error" or "Sign in failed"

**Cause:** SHA-1 mismatch or configuration not propagated

**Solutions:**

1. **Double-check SHA-1:**
   - In Google Console, verify it's exactly: `97:2A:42:77:38:B0:0D:87:0A:C4:C2:F8:10:B7:4A:39:8E:1A:3B:41`
   - No extra spaces or characters

2. **Wait longer:**
   - Wait 10-15 minutes after configuration
   - Sometimes propagation takes time

3. **Verify package name:**
   - Must be exactly: `com.example.event_manager_ui`
   - Case-sensitive

4. **Check OAuth Consent:**
   - Ensure you added your email as a test user
   - Consent screen should be configured

### Error: "Account picker doesn't show"

**Solutions:**

- Update Google Play Services on device/emulator
- Clear app data: Settings > Apps > Event Manager > Clear Data
- Reinstall the app

### Error: "Network error" or "Connection failed"

**Solutions:**

- Ensure backend is running at: `https://mad-edi9.onrender.com`
- Check internet connection
- Verify API endpoint in `lib/core/api_service.dart`

---

## 📱 Multiple Device Testing

**For each device/emulator:**

- Same SHA-1 works for all debug builds
- Use the same Google Cloud credentials
- No additional configuration needed

**For release builds:**

- Generate release keystore
- Get release SHA-1: `keytool -list -v -keystore your-release.jks`
- Add release SHA-1 to same OAuth client in Google Console

---

## 🎓 Additional Configuration (Optional)

### Add iOS Support:

1. Create OAuth client ID
2. Select **"iOS"** type
3. Enter bundle ID

### Add Web Support:

1. Create OAuth client ID
2. Select **"Web application"** type
3. Add authorized origins

### Production Checklist:

- [ ] Change OAuth consent to "In Production"
- [ ] Add privacy policy URL
- [ ] Add terms of service URL
- [ ] Remove test user restrictions
- [ ] Add release SHA-1 certificate

---

## ✅ Configuration Complete!

Once you see the Google account picker and can successfully sign in, your configuration is complete!

**Questions?** Refer to:

- `GOOGLE_SIGNIN_SETUP.md` - Detailed setup guide
- `IMPLEMENTATION_SUMMARY.md` - Code changes summary
- `GOOGLE_SIGNIN_QUICKSTART.md` - Quick reference

---

**Happy coding! 🚀**
