const mongoose = require("mongoose");
require("dotenv").config();

async function connectDB() {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log("✓ Connected to MongoDB");
    return conn;
  } catch (err) {
    console.error("✗ Database connection failed:", err.message);
    throw err;
  }
}

module.exports = { connectDB };
