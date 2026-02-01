# Google Sign-In Test Script
# Run this to quickly test your Google Sign-In setup

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Google Sign-In Quick Test" -ForegroundColor Cyan
Write-Host "================================`n" -ForegroundColor Cyan

# Configuration Info
Write-Host "📋 Your Configuration:" -ForegroundColor Yellow
Write-Host "Package Name: com.example.event_manager_ui" -ForegroundColor White
Write-Host "SHA-1: 97:2A:42:77:38:B0:0D:87:0A:C4:C2:F8:10:B7:4A:39:8E:1A:3B:41`n" -ForegroundColor White

# Check if in correct directory
$currentPath = Get-Location
if ($currentPath.Path -notlike "*MAD*") {
    Write-Host "⚠️  Warning: Not in MAD directory" -ForegroundColor Red
    Write-Host "Current path: $currentPath" -ForegroundColor Gray
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y") {
        exit
    }
}

# Step 1: Check Flutter
Write-Host "`n1️⃣  Checking Flutter..." -ForegroundColor Cyan
try {
    $flutterVersion = flutter --version 2>&1 | Select-String "Flutter" | Select-Object -First 1
    Write-Host "   ✅ Flutter found: $flutterVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Flutter not found. Please install Flutter." -ForegroundColor Red
    exit
}

# Step 2: Get dependencies
Write-Host "`n2️⃣  Installing dependencies..." -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Dependencies installed" -ForegroundColor Green
} else {
    Write-Host "   ❌ Failed to install dependencies" -ForegroundColor Red
    exit
}

# Step 3: Check backend
Write-Host "`n3️⃣  Checking backend status..." -ForegroundColor Cyan
Write-Host "   Backend URL: https://mad-edi9.onrender.com/api" -ForegroundColor White

# Try to ping backend
try {
    $response = Invoke-WebRequest -Uri "https://mad-edi9.onrender.com/api/events" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    Write-Host "   ✅ Backend is reachable" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  Backend may not be running or reachable" -ForegroundColor Yellow
    Write-Host "   You can start local backend with: cd backend; npm start" -ForegroundColor Gray
}

# Step 4: Google Cloud Configuration Check
Write-Host "`n4️⃣  Google Cloud Configuration:" -ForegroundColor Cyan
Write-Host "   Have you configured Google Cloud Console? (y/n)" -ForegroundColor White
$configured = Read-Host
if ($configured -eq "n") {
    Write-Host "`n   📝 Please complete Google Cloud setup:" -ForegroundColor Yellow
    Write-Host "   1. Go to: https://console.cloud.google.com/" -ForegroundColor White
    Write-Host "   2. Follow guide: GOOGLE_CLOUD_SETUP_GUIDE.md" -ForegroundColor White
    Write-Host "   3. Use SHA-1: 97:2A:42:77:38:B0:0D:87:0A:C4:C2:F8:10:B7:4A:39:8E:1A:3B:41" -ForegroundColor White
    Write-Host "   4. Use Package: com.example.event_manager_ui`n" -ForegroundColor White
    
    $continueAnyway = Read-Host "   Continue with app run anyway? (y/n)"
    if ($continueAnyway -ne "y") {
        Write-Host "`n✋ Setup cancelled. Configure Google Cloud first!`n" -ForegroundColor Yellow
        exit
    }
}

# Step 5: List available devices
Write-Host "`n5️⃣  Available devices:" -ForegroundColor Cyan
flutter devices

# Step 6: Run app
Write-Host "`n6️⃣  Ready to run app!" -ForegroundColor Cyan
Write-Host "   Choose an option:" -ForegroundColor White
Write-Host "   1. Run on connected device" -ForegroundColor White
Write-Host "   2. Just show device list" -ForegroundColor White
Write-Host "   3. Exit" -ForegroundColor White

$choice = Read-Host "`n   Enter choice (1-3)"

switch ($choice) {
    "1" {
        Write-Host "`n🚀 Starting Flutter app..." -ForegroundColor Green
        Write-Host "   Press 'r' to hot reload" -ForegroundColor Gray
        Write-Host "   Press 'R' to hot restart" -ForegroundColor Gray
        Write-Host "   Press 'q' to quit`n" -ForegroundColor Gray
        flutter run
    }
    "2" {
        Write-Host "`n📱 Available devices listed above" -ForegroundColor Green
        Write-Host "   To run manually: flutter run`n" -ForegroundColor White
    }
    "3" {
        Write-Host "`n👋 Goodbye!`n" -ForegroundColor Cyan
        exit
    }
    default {
        Write-Host "`n❌ Invalid choice`n" -ForegroundColor Red
    }
}

Write-Host "`n================================" -ForegroundColor Cyan
Write-Host "Testing Tips:" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host "1. Navigate to Login or Register screen" -ForegroundColor White
Write-Host "2. Tap the 'Google' button" -ForegroundColor White
Write-Host "3. Select your Google account" -ForegroundColor White
Write-Host "4. Grant permissions" -ForegroundColor White
Write-Host "5. You should be logged in!`n" -ForegroundColor White

Write-Host "📚 Documentation:" -ForegroundColor Yellow
Write-Host "   - GOOGLE_CLOUD_SETUP_GUIDE.md (Step-by-step setup)" -ForegroundColor White
Write-Host "   - GOOGLE_SIGNIN_QUICKSTART.md (Quick reference)" -ForegroundColor White
Write-Host "   - IMPLEMENTATION_SUMMARY.md (All changes)`n" -ForegroundColor White
