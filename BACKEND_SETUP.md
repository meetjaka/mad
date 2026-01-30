# Event Manager App - Backend Setup Guide

## MongoDB Backend Installation & Setup

### Prerequisites

- Node.js (v14+)
- MongoDB (local or MongoDB Atlas cloud)
- npm or yarn

### Step 1: Install Dependencies

```bash
cd backend
npm install
```

### Step 2: Configure Environment Variables

Edit `.env` file with your MongoDB URI:

```
PORT=3000
MONGODB_URI=mongodb://localhost:27017/event-manager-db
JWT_SECRET=your_jwt_secret_key_here_change_in_production
NODE_ENV=development
```

For MongoDB Atlas (Cloud):

```
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/event-manager-db
```

### Step 3: Start the Server

```bash
# Development with auto-reload
npm run dev

# Or production mode
npm start
```

The server will start on `http://localhost:3000`

### API Endpoints

#### Events

- **GET** `/api/events` - Get all events with filtering/sorting
  - Query params: `category`, `search`, `sort` (Popular|Rating|Nearest|Price: Low to High)
- **GET** `/api/events/:id` - Get single event
- **POST** `/api/events` - Create event
- **PUT** `/api/events/:id` - Update event
- **DELETE** `/api/events/:id` - Delete event

#### Authentication

- **POST** `/api/auth/register` - Register new user
  - Body: `{ name, email, password, phone }`
- **POST** `/api/auth/login` - Login user
  - Body: `{ email, password }`
- **GET** `/api/auth/:userId` - Get user profile
- **PUT** `/api/auth/:userId` - Update user profile

#### Bookings

- **POST** `/api/bookings` - Create booking
- **GET** `/api/bookings/user/:userId` - Get user bookings
- **PUT** `/api/bookings/:id/cancel` - Cancel booking

#### Favorites

- **GET** `/api/favorites/user/:userId` - Get user favorites
- **POST** `/api/favorites` - Add to favorites
- **DELETE** `/api/favorites/:userId/:eventId` - Remove from favorites

### Database Models

**User**

- name, email, password, phone, avatarUrl, createdAt, updatedAt

**Event**

- title, description, organizer, category, dateTime, location, price
- imageUrl, rating, attendees, duration, difficulty, tags

**Booking**

- userId, eventId, tickets, totalPrice, seatType, bookingDate, cancelled

**Favorite**

- userId, eventId, createdAt

**Review**

- userId, eventId, rating, comment, createdAt

### MongoDB Collections Created Automatically

- users
- events
- bookings
- favorites
- reviews

### Testing the API

Use Postman or cURL to test:

```bash
# Get all events
curl http://localhost:3000/api/events

# Register user
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@example.com","password":"123456","phone":"+1234567890"}'

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@example.com","password":"123456"}'
```

### Connect Flutter App to Backend

Update the Flutter app's API service:

```dart
const String BASE_URL = "http://localhost:3000/api";
```

For Android/physical device, use your machine's IP:

```dart
const String BASE_URL = "http://192.168.x.x:3000/api";
```

### Troubleshooting

**MongoDB Connection Error**

- Ensure MongoDB is running locally: `mongod`
- Or use MongoDB Atlas connection string

**Port Already in Use**

- Change PORT in .env
- Or kill process: `lsof -ti:3000 | xargs kill -9`

**CORS Errors**

- CORS is enabled for all origins (update for production)
- Frontend must send proper Content-Type headers
