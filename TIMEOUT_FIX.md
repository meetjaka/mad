# 🔥 TIMEOUT FIX - Backend Connection Issue

## Problem

Your phone **cannot connect** to the backend at `192.168.0.130:3000` because:

1. Windows Firewall is blocking port 3000
2. Phone and computer might not be on the same WiFi

---

## ✅ SOLUTION 1: Allow Port 3000 Through Firewall (RECOMMENDED)

Run this command in PowerShell **as Administrator**:

```powershell
New-NetFirewallRule -DisplayName "Node Backend" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow
```

### Steps:

1. Right-click PowerShell → Run as Administrator
2. Copy and paste the command above
3. Press Enter
4. Restart your Flutter app

---

## ✅ SOLUTION 2: Use Android Emulator Instead

If you're having trouble with firewall:

1. **Open Android Emulator** (not a real device)
2. **Change API URL** in [`lib/core/api_service.dart`](lib/core/api_service.dart):
   ```dart
   static const String baseUrl = 'http://10.0.2.2:3000/api';
   ```
   (10.0.2.2 is the emulator's way to access localhost)
3. **Run app**: `flutter run`

---

## ✅ SOLUTION 3: Quick Test - Use Deployed Backend

Temporarily switch back to deployed backend (no Google Sign-In yet):

In [`lib/core/api_service.dart`](lib/core/api_service.dart):

```dart
static const String baseUrl = 'https://mad-edi9.onrender.com/api';
```

This will work for normal login/register but **NOT** for Google Sign-In (endpoint doesn't exist there yet).

---

## 🔍 Verify Backend is Accessible

After applying firewall rule, test from your phone's browser:

- Open: `http://192.168.0.130:3000/api/health`
- Should show: `{"status":"Server is running"}`

Or test from PowerShell:

```powershell
curl http://192.168.0.130:3000/api/health
```

---

## ⚡ Quick Commands

### Option A: Fix Firewall (Best for Real Device)

```powershell
# Run as Administrator
New-NetFirewallRule -DisplayName "Node Backend" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow
```

### Option B: Use Emulator

```powershell
# Change API URL to http://10.0.2.2:3000/api
# Then run
flutter run
```

### Option C: Use Deployed Backend (No Google Sign-In)

```powershell
# Change API URL to https://mad-edi9.onrender.com/api
flutter run -d 10BF56210B007AM
```

---

## 📱 Recommended: Option A (Firewall Rule)

This is the **best solution** because:

- ✅ Works with real device
- ✅ Supports Google Sign-In
- ✅ Fast local backend
- ✅ No internet needed

After adding firewall rule, **hot restart** your app (Press 'R' in terminal)!
