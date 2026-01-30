const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
require("dotenv").config();

const { connectDB } = require("./config/database");
const eventsRoutes = require("./routes/events");
const bookingsRoutes = require("./routes/bookings");
const authRoutes = require("./routes/auth");
const favoritesRoutes = require("./routes/favorites");

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.use("/api/events", eventsRoutes);
app.use("/api/bookings", bookingsRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/favorites", favoritesRoutes);

// Health check
app.get("/api/health", (req, res) => {
  res.json({ status: "Server is running", timestamp: new Date() });
});

// Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ success: false, message: "Internal server error" });
});

// Start server
async function startServer() {
  try {
    await connectDB();
    app.listen(PORT, () => {
      console.log(`\n✓ Server is running on http://localhost:${PORT}`);
      console.log("✓ API Documentation:");
      console.log("  - Events: GET /api/events");
      console.log("  - Auth: POST /api/auth/register, POST /api/auth/login");
      console.log(
        "  - Bookings: POST /api/bookings, GET /api/bookings/user/:userId"
      );
      console.log(
        "  - Favorites: GET /api/favorites/user/:userId, POST /api/favorites\n"
      );
    });
  } catch (err) {
    console.error("Failed to start server:", err);
    process.exit(1);
  }
}

startServer();

module.exports = app;
