# Event Manager - Mobile Application Development Practical

## 1. Introduction

In this practical, we developed **Event Manager**, a comprehensive Event Management Application using Flutter and Riverpod state management. The purpose of the application is to help users discover, browse, and book events while providing event organizers the ability to create and manage their events.

The application focuses on creating a modern, responsive UI with a clean design system that adapts to both light and dark themes. Multiple screens such as **Splash Screen**, **Login Screen**, **Register Screen**, **Home Screen**, **Event Details Screen**, **Profile Screen**, and **Booking Screen** were implemented using Flutter's powerful layout widgets and state management patterns.

The app demonstrates real-world mobile app development practices including API integration, form validation, state management with Riverpod, navigation, and creating reusable UI components.

---

## 2. Objectives of the Practical

- **To understand Flutter layout widgets** such as `Column`, `Row`, `Stack`, `Expanded`, `ListView`, `GridView`, and `SingleChildScrollView`
- **To design reusable UI components** like custom buttons, input fields, event cards, and app bars
- **To maintain a consistent theme** using centralized color and style files with Material 3 design
- **To create responsive screens** adaptable to different mobile screen sizes
- **To implement clean navigation** between screens using named routes
- **To integrate state management** using Riverpod for efficient data flow
- **To work with form validation** and user input handling
- **To implement API integration** for backend communication
- **To create shimmer loading effects** for better user experience
- **To handle user authentication** and session management

---

## 3. Layout Design Strategy

### 3.1 Splash Screen

**Implemented using**: `Column` and `Center`

**Features**:

- Displays app logo with a circular avatar
- Shows "Event Manager" app name
- Automatically navigates to Login Screen after 2-second delay

**Design**:

- Uses `Center` widget to center content vertically and horizontally
- `Column` with `mainAxisSize: MainAxisSize.min` to group logo and text
- Simple, clean design that loads quickly
- Material theme colors for primary branding

**Widgets Used**:

- `Scaffold` - Base structure
- `Center` - Centers content
- `Column` - Vertical layout
- `CircleAvatar` - App logo container
- `Icon` - Event icon
- `Text` - App name
- `Timer` - Auto-navigation after delay

---

### 3.2 Login Screen

**Implemented using**: `Column` with `Form` validation

**Features**:

- Email and Password input fields with validation
- "Sign In" button with loading state
- "Create Account" navigation option
- Error handling with SnackBar messages
- Form validation for email format and required fields

**Design**:

- Uses `AuthShell` custom widget for consistent auth screen layout
- Dark/Light theme support
- Input fields with `InputField` custom widget
- `CustomButton` with gradient styling
- Real-time form validation

**Widgets Used**:

- `Scaffold` - Base structure
- `Form` - Form validation wrapper
- `Column` - Vertical layout for form fields
- `TextField` (via `InputField`) - User input
- `TextEditingController` - Input control
- `ElevatedButton` (via `CustomButton`) - Submit button
- `Row` - Layout for "Don't have account?" text
- `TextButton` - Navigation to Register screen
- `SnackBar` - Error messages

**Layout Structure**:

```
AuthShell
  └── Form
      └── Column
          ├── InputField (Email)
          ├── SizedBox (spacing)
          ├── InputField (Password)
          ├── SizedBox (spacing)
          ├── CustomButton (Sign In)
          └── Row (Create account link)
```

---

### 3.3 Register Screen

**Implemented using**: `Column` with `Form` validation

**Features**:

- Full Name, Email, and Password input fields
- Password strength validation
- "Create Account" button with loading state
- "Already have account?" navigation option
- Comprehensive form validation

**Design**:

- Similar to Login Screen for consistency
- Uses same `AuthShell` wrapper
- Additional field for full name
- Password confirmation can be added

**Widgets Used**:

- `Scaffold`
- `Form`
- `Column`
- `InputField` (multiple instances)
- `CustomButton`
- `Row` and `TextButton`

---

### 3.4 Home Screen (Main Screen)

**Implemented using**: `Scaffold` with `SingleChildScrollView`

**Features**:

- **Custom App Bar** with title and action buttons
- **Search functionality** to find events
- **Category chips** for filtering (All, Music, Tech, Sports, Workshop)
- **Sort options** (Popular, Rating, Nearest, Price)
- **Event grid/list** displaying event cards
- **Pull-to-refresh** functionality
- **Shimmer loading** effect during data fetch
- **Bottom Navigation Bar** (Home, Favorites, Profile, My Events)

**Design**:

- Header section with welcome text and search bar
- Horizontal scrollable category chips
- Sort dropdown aligned to right
- GridView or ListView for event cards
- Responsive layout adapting to screen size
- Favorites integration with heart icon on cards

**Widgets Used**:

- `Scaffold` - Base structure
- `CustomAppBar` - Reusable app bar
- `RefreshIndicator` - Pull to refresh
- `SingleChildScrollView` - Scrollable content
- `Column` - Main vertical layout
- `Container` - Header styling
- `Row` - Search and filter row
- `TextField` - Search input
- `CategoryChips` - Custom category selector
- `PopupMenuButton` - Sort options
- `GridView.builder` / `ListView.builder` - Event list
- `EventCard` - Custom event card widget
- `BottomNavigationBar` - Navigation

**Layout Structure**:

```
Scaffold
  ├── CustomAppBar
  ├── RefreshIndicator
  │   └── SingleChildScrollView
  │       └── Column
  │           ├── Container (Header)
  │           │   └── Column
  │           │       ├── Text (Welcome)
  │           │       ├── Text (Title)
  │           │       └── Row (Search + Filter)
  │           ├── CategoryChips
  │           ├── Row (Results count + Sort)
  │           └── GridView/ListView
  │               └── EventCard (multiple)
  └── BottomNavigationBar
```

---

### 3.5 Event Details Screen

**Implemented using**: `Scaffold` with `SingleChildScrollView` and `Stack`

**Features**:

- **Hero image** of the event at the top
- **Event title, date, location, price** prominently displayed
- **Category badge** and **rating**
- **About section** with description
- **Organizer information**
- **Attendees count**
- **Book Now** button (floating or fixed at bottom)
- **Favorite button** to save event
- **Share button** to share event

**Design**:

- Image at top with gradient overlay
- Back button and favorite icon overlay on image
- Information cards for quick details
- Scrollable content area
- Fixed bottom booking button
- Material cards for sections

**Widgets Used**:

- `Scaffold`
- `Stack` - For image overlay
- `SingleChildScrollView` - Scrollable content
- `Column` - Main layout
- `Row` - Icon and text combinations
- `Container` - Styling sections
- `Card` - Information sections
- `ClipRRect` - Rounded image corners
- `LinearGradient` - Image overlay
- `IconButton` - Back and favorite
- `ElevatedButton` - Book now

**Layout Structure**:

```
Scaffold
  └── Stack
      ├── SingleChildScrollView
      │   └── Column
      │       ├── Stack (Hero Image + Gradient)
      │       ├── Padding
      │       │   └── Column
      │       │       ├── Row (Title + Favorite)
      │       │       ├── Row (Date, Location)
      │       │       ├── Row (Category, Rating, Price)
      │       │       ├── Divider
      │       │       ├── Text (About section)
      │       │       ├── Card (Organizer)
      │       │       └── Row (Attendees)
      └── Positioned (Bottom)
          └── CustomButton (Book Now)
```

---

### 3.6 Add Event Screen

**Implemented using**: `Form` with `Column`

**Features**:

- Form fields for event creation:
  - Event Title
  - Description
  - Category dropdown
  - Date picker
  - Time picker
  - Location
  - Price
  - Image upload
- Form validation for all required fields
- Submit button to create event

**Widgets Used**:

- `Scaffold`
- `Form`
- `SingleChildScrollView`
- `Column`
- `InputField`
- `DropdownButtonFormField`
- `DatePicker` / `TimePicker`
- `CustomButton`

---

### 3.7 Profile Screen

**Implemented using**: `Column` with `ListView`

**Features**:

- **Profile header** with avatar and user info
- **Edit Profile** button
- **Statistics** (Events attended, Reviews given, Favorites)
- **Settings options** in list tiles:
  - My Events
  - My Bookings
  - Favorites
  - Theme Toggle (Dark/Light)
  - Logout

**Design**:

- Circular avatar at top
- User name and email
- Stats row with cards
- List of menu items with icons
- Clean separation with dividers

**Widgets Used**:

- `Scaffold`
- `Column`
- `CircleAvatar` - Profile picture
- `Row` - Stats layout
- `Card` - Stat cards
- `ListView` - Menu items
- `ListTile` - Menu options
- `Switch` - Theme toggle
- `Divider` - Visual separation

**Layout Structure**:

```
Scaffold
  └── Column
      ├── Container (Header)
      │   └── Column
      │       ├── CircleAvatar
      │       ├── Text (Name)
      │       ├── Text (Email)
      │       └── ElevatedButton (Edit)
      ├── Row (Stats)
      │   ├── Card (Events)
      │   ├── Card (Reviews)
      │   └── Card (Favorites)
      └── ListView
          ├── ListTile (My Events)
          ├── ListTile (Bookings)
          ├── ListTile (Favorites)
          ├── ListTile (Theme)
          └── ListTile (Logout)
```

---

### 3.8 Favorites Screen

**Implemented using**: `GridView` or `ListView`

**Features**:

- Displays all favorited events
- Same event card design as home screen
- Empty state when no favorites
- Remove from favorites option

**Widgets Used**:

- `Scaffold`
- `CustomAppBar`
- `GridView.builder` / `ListView.builder`
- `EventCard`
- `Center` - Empty state

---

### 3.9 Booking Screen

**Implemented using**: `Column` with `Form`

**Features**:

- Event summary card
- Ticket quantity selector
- Total price calculation
- Payment method selection (optional)
- Confirm booking button
- Booking confirmation dialog

**Widgets Used**:

- `Scaffold`
- `Column`
- `Card` - Event summary
- `Row` - Quantity controls
- `IconButton` - Increment/Decrement
- `Text` - Price display
- `CustomButton` - Confirm
- `AlertDialog` - Confirmation

---

## 4. Reusable Custom Widgets

### 4.1 CustomButton

**Purpose**: Consistent button styling across the app

**Features**:

- Gradient background support
- Loading state with CircularProgressIndicator
- Customizable text and onPressed callback
- Disabled state handling

**Implementation**: Uses `Container` with `BoxDecoration` gradient and `InkWell` for tap handling

---

### 4.2 InputField

**Purpose**: Standardized text input fields

**Features**:

- Label and hint text
- Prefix icons
- Password obscuring with toggle
- Validation error display
- Consistent styling

**Implementation**: Wraps `TextFormField` with custom decoration

---

### 4.3 EventCard

**Purpose**: Display event information in a card format

**Features**:

- Event image
- Title, date, location
- Category badge
- Price tag
- Favorite icon
- Rating display
- Tap to navigate to details

**Implementation**: Uses `Card` with `Column` and `Row` layouts, `Stack` for overlay elements

---

### 4.4 CustomAppBar

**Purpose**: Consistent app bar across screens

**Features**:

- Title text
- Back button (conditional)
- Action buttons (search, notifications)
- Theme-aware styling

**Implementation**: Returns `PreferredSizeWidget` (AppBar)

---

### 4.5 CategoryChips

**Purpose**: Horizontal scrollable category filters

**Features**:

- Selected/unselected states
- Smooth scrolling
- Callback for selection changes

**Implementation**: `SingleChildScrollView` with `Row` of `ChoiceChip` widgets

---

### 4.6 ShimmerLoading

**Purpose**: Loading placeholder with shimmer effect

**Features**:

- Animated shimmer effect
- Customizable shapes (card, list item)
- Smooth animation

**Implementation**: Uses `AnimationController` with gradient sweep

---

### 4.7 BottomNav

**Purpose**: Bottom navigation bar for main screens

**Features**:

- 4 navigation items (Home, Favorites, Profile, My Events)
- Icon and label
- Selected state highlighting
- Navigation callback

**Implementation**: Custom widget wrapping `BottomNavigationBar`

---

## 5. State Management with Riverpod

### 5.1 Providers Used

**EventsProvider**:

- Manages event list state
- Handles API calls for fetching events
- Provides loading, success, and error states
- Implements refresh functionality

**FavoritesProvider**:

- Manages user's favorite events
- Add/remove favorites
- Persists data locally with SharedPreferences

**ThemeModeProvider**:

- Manages app theme (light/dark)
- Persists user preference
- Notifies listeners on theme change

**AuthProvider**:

- Manages authentication state
- Stores user session
- Handles login/logout

---

## 6. API Integration

**ApiService Class**:

- Centralized HTTP client
- Methods for:
  - `login()` - User authentication
  - `register()` - New user registration
  - `fetchEvents()` - Get all events
  - `createEvent()` - Add new event
  - `bookEvent()` - Create booking
  - `toggleFavorite()` - Add/remove favorite

**Error Handling**:

- Try-catch blocks for network errors
- User-friendly error messages
- Loading states during API calls

---

## 7. Navigation Structure

**Named Routes** using `AppRoutes`:

- `/splash` → Splash Screen
- `/login` → Login Screen
- `/register` → Register Screen
- `/home` → Home Screen
- `/event` → Event Details Screen
- `/add-event` → Add Event Screen
- `/my-events` → My Events Screen
- `/booking` → Booking Screen
- `/my-bookings` → My Bookings Screen
- `/profile` → Profile Screen
- `/edit-profile` → Edit Profile Screen
- `/favorites` → Favorites Screen

**Navigation Methods**:

- `Navigator.pushNamed()` - Navigate to route
- `Navigator.pushReplacementNamed()` - Replace current route
- `Navigator.pop()` - Go back
- Arguments passing for event details

---

## 8. Theme and Styling

### 8.1 Color Scheme

**Light Theme**:

- Primary: Purple (#5B56D9)
- Accent: Red (#F77A7A)
- Success: Green (#37D67A)
- Background: White
- Card: White with subtle shadow

**Dark Theme**:

- Primary: Purple (#5B56D9)
- Background: Dark gray
- Card: Slightly lighter gray
- Text: White/Light gray

### 8.2 Typography

- Uses **Google Fonts - Inter** for modern, readable text
- Consistent text styles:
  - Headline Large: Event titles
  - Headline Small: Section headers
  - Body Large: Descriptions
  - Body Medium: Labels
  - Label Small: Helper text

### 8.3 Spacing

- Consistent padding and margins using `SizedBox`
- 8px, 12px, 16px, 20px, 24px spacing units
- Edge insets for containers

---

## 9. Form Validation

**Email Validation**:

- Regex pattern for email format
- Required field check

**Password Validation**:

- Minimum length check
- Required field check
- Optional: Strength indicator

**Other Fields**:

- Required field validation
- Custom validators for each input type
- Real-time error display

---

## 10. Responsive Design

**Techniques Used**:

- `MediaQuery` for screen dimensions
- `LayoutBuilder` for adaptive layouts
- `Flexible` and `Expanded` for flexible sizing
- Percentage-based widths
- `AspectRatio` for images
- Breakpoints for tablet/phone layouts

**Adaptive Elements**:

- GridView column count based on screen width
- Font sizes scale with screen size
- Spacing adjusts for different devices
- Bottom sheet on mobile, dialog on tablet

---

## 11. Key Learnings

1. **Widget Composition**: Breaking complex UIs into reusable widgets
2. **State Management**: Using Riverpod for efficient state handling
3. **Navigation**: Implementing clean route-based navigation
4. **API Integration**: Connecting Flutter app to backend services
5. **Form Handling**: Validation and user input management
6. **Theming**: Creating consistent, theme-aware UIs
7. **Responsive Design**: Building adaptive layouts for various screens
8. **User Experience**: Loading states, error handling, and feedback
9. **Code Organization**: Structuring Flutter project for maintainability
10. **Material Design**: Following Material 3 design guidelines

---

## 12. Conclusion

The Event Manager application successfully demonstrates comprehensive mobile app development using Flutter. The implementation showcases proficiency in:

- **UI/UX Design**: Creating intuitive, visually appealing interfaces
- **Layout Widgets**: Mastering Column, Row, Stack, GridView, ListView
- **State Management**: Implementing Riverpod for reactive programming
- **Navigation**: Building multi-screen app with proper routing
- **API Integration**: Connecting to backend for dynamic data
- **Code Quality**: Writing clean, maintainable, reusable code

This practical provided hands-on experience in building a production-ready mobile application with real-world features including authentication, data management, user interactions, and responsive design.

---

## 13. Screenshots Reference

### Main Screens:

1. **Splash Screen** - Initial loading screen
2. **Login Screen** - User authentication
3. **Register Screen** - New user registration
4. **Home Screen** - Event discovery with search and filters
5. **Event Details Screen** - Detailed event information
6. **Add Event Screen** - Create new events
7. **Profile Screen** - User profile and settings
8. **Favorites Screen** - Saved events
9. **Booking Screen** - Event booking interface
10. **My Events Screen** - User's created events
11. **My Bookings Screen** - User's booked events

---

## 14. Future Enhancements

- **Push Notifications**: Remind users about upcoming events
- **Maps Integration**: Show event location on map
- **Payment Gateway**: In-app payment processing
- **Social Sharing**: Share events on social media
- **Reviews & Ratings**: User feedback on events
- **Chat**: Communication between organizers and attendees
- **QR Code**: Digital tickets with QR codes
- **Analytics**: Event insights for organizers

---

**Project Name**: Event Manager  
**Technology**: Flutter, Dart, Riverpod  
**Practical Type**: Mobile Application Development - UI/UX Implementation  
**Date**: February 2026
