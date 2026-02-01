# Quick Fix: Use Local Backend for Google Sign-In

The deployed backend doesn't have the Google Sign-In endpoint yet. Here's how to fix it:

## Option 1: Use Local Backend (Quick Test)

### Step 1: Update API Base URL

Change the backend URL to use localhost:

1. Open `lib/core/api_service.dart`
2. Change line 5 from:
   ```dart
   static const String baseUrl = 'https://mad-edi9.onrender.com/api';
   ```
   To:
   ```dart
   static const String baseUrl = 'http://10.0.2.2:3000/api'; // For Android emulator
   // OR
   static const String baseUrl = 'http://YOUR_COMPUTER_IP:3000/api'; // For real device
   ```

### Step 2: Start Local Backend

```powershell
cd C:\Users\Dell\Desktop\MAD\backend
npm start
```

### Step 3: Test Google Sign-In

Hot restart your app and try again!

---

## Option 2: Deploy Updated Backend to Render

If you want to use the deployed backend:

### Step 1: Push Backend Changes to Git

```powershell
cd C:\Users\Dell\Desktop\MAD
git add backend/
git commit -m "Add Google Sign-In endpoint"
git push origin main
```

### Step 2: Redeploy on Render

Render should auto-deploy the changes.

### Step 3: Wait for Deployment

Wait 5-10 minutes for the new deployment to complete.

---

## Quick Command to Use Local Backend

```powershell
# Start backend in one terminal
cd C:\Users\Dell\Desktop\MAD\backend
npm start

# In another terminal, restart Flutter app
cd C:\Users\Dell\Desktop\MAD
flutter run -d 10BF56210B007AM
```

**Note**: If using Android emulator, use `http://10.0.2.2:3000/api`
If using real device, use `http://YOUR_IP:3000/api` (find IP with `ipconfig`)
