# Event Manager Application - Complete Setup Guide

A professional Flutter event management application with MongoDB backend, featuring event discovery, booking system, favorites, and user profiles.

## 🏗️ Architecture Overview

```
Event Manager App
├── Frontend (Flutter)
│   ├── Screens (Home, Events, Booking, Profile, etc.)
│   ├── Providers (State Management - Riverpod)
│   ├── Models (Event, User, Booking)
│   └── Widgets (Reusable UI components)
│
└── Backend (Node.js + Express)
    ├── API Routes (Events, Auth, Bookings, Favorites)
    ├── Models (Mongoose)
    ├── Database (MongoDB)
    └── Middleware (Auth, CORS)
```

## 📋 Prerequisites

- **Flutter** (v3.10+)
- **Node.js** (v14+)
- **MongoDB** (local or Atlas)
- **Android SDK** / **iOS SDK** (for mobile)
- **Chrome** (for web)

## 🚀 Quick Start

### 1. Backend Setup

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Configure environment (.env file already created)
# Edit .env with your MongoDB URI:
# MONGODB_URI=mongodb://localhost:27017/event-manager-db

# Start the server
npm run dev
```

**Backend runs on:** `http://localhost:3000`

### 2. Frontend Setup

```bash
# At project root (MAD folder)

# Get dependencies
flutter pub get

# Run on Chrome (for development)
flutter run -d chrome

# Run on Android (requires Android emulator/device)
flutter run -d android

# Run on iOS (macOS only)
flutter run -d ios
```

## 📦 Features Implemented

### ✅ User Authentication

- User registration & login
- JWT token-based auth
- Password hashing (bcryptjs)
- Profile management

### ✅ Event Management

- Browse all events
- Advanced search & filtering (by category, name, description)
- Multiple sorting options (Popular, Top Rated, Coming Soon, Price)
- Event details with ratings & reviews
- Attendee count tracking

### ✅ Booking System

- Select number of tickets
- Choose seating type (Standard, Premium, VIP)
- Real-time price calculation
- Processing fee calculation
- Booking confirmation

### ✅ Favorites System

- Add/remove favorite events
- View saved events
- Local persistence with SharedPreferences
- MongoDB sync

### ✅ User Profile

- View profile information
- Edit profile details
- Dark/Light theme toggle
- View bookings & favorites statistics
- Manage settings & preferences
- Logout functionality

### ✅ Professional UI/UX

- Material Design 3
- Light & Dark themes
- Smooth animations & transitions
- Responsive layout
- Loading states & empty states
- Error handling

## 🗄️ Database Schema (MongoDB)

### Collections

**events** - Event listings with full details
**users** - User accounts and profiles
**bookings** - Ticket reservations
**favorites** - Saved events
**reviews** - Event reviews and ratings

## 🔌 API Endpoints

### Events

```
GET    /api/events                    # Get all events (with filters/sorting)
GET    /api/events/:id                # Get single event details
POST   /api/events                    # Create event (admin)
PUT    /api/events/:id                # Update event (admin)
DELETE /api/events/:id                # Delete event (admin)
```

### Authentication

```
POST   /api/auth/register             # Register new user
POST   /api/auth/login                # Login user
GET    /api/auth/:userId              # Get user profile
PUT    /api/auth/:userId              # Update user profile
```

### Bookings

```
POST   /api/bookings                  # Create booking
GET    /api/bookings/user/:userId     # Get user's bookings
PUT    /api/bookings/:id/cancel       # Cancel booking
```

### Favorites

```
GET    /api/favorites/user/:userId    # Get user's favorite events
POST   /api/favorites                 # Add to favorites
DELETE /api/favorites/:userId/:eventId # Remove from favorites
```

## 🎨 Flutter App Structure

```
lib/
├── main.dart
├── core/constants/theme
├── data/dummy_events.dart
├── models/event_model.dart
├── providers/theme_provider.dart
├── routes/app_routes.dart
├── screens/
│   ├── home/home_screen.dart
│   ├── event/event_details_screen.dart
│   ├── booking/booking_screen.dart
│   ├── auth/login_screen.dart
│   ├── profile/profile_screen.dart
│   ├── favorites/favorites_screen.dart
│   └── splash_screen.dart
└── widgets/event_card.dart
```

## 🚀 Running the Application

### Start Backend

```bash
cd backend
npm run dev
```

### Start Frontend

```bash
# On Web
flutter run -d chrome

# On Android
flutter run -d android

# On iOS
flutter run -d ios
```

## 📱 Platform Support

- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)

## 📊 Sample Data

10 pre-loaded events across 4 categories:

- Music (3 events)
- Tech (3 events)
- Sports (2 events)
- Workshop (2 events)

## 🔐 Security

- Password hashing with bcryptjs
- JWT authentication
- Environment variable protection
- Input validation
- CORS enabled

## 📝 Environment Configuration

**Backend (.env)**

```
PORT=3000
MONGODB_URI=mongodb://localhost:27017/event-manager-db
JWT_SECRET=your_secret_key
NODE_ENV=development
```

## 🐛 Troubleshooting

**MongoDB Connection**

```bash
# Start MongoDB
mongod

# Or use MongoDB Atlas with cloud URI
```

**Flutter Build Issues**

```bash
flutter clean
flutter pub get
flutter pub upgrade
```

## 📄 License

Open source - MIT License

---

**Complete Event Manager Application Ready to Use! 🎉**
