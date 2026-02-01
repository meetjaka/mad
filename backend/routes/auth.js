const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
const Booking = require("../models/Booking");
const Favorite = require("../models/Favorite");
const Review = require("../models/Review");
const router = express.Router();

// Register
router.post("/register", async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;

    // Check if user exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ success: false, message: "Email already registered" });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const user = new User({
      name,
      email,
      password: hashedPassword,
      phone,
    });

    const savedUser = await user.save();

    const token = jwt.sign(
      { id: savedUser._id, email: savedUser.email },
      process.env.JWT_SECRET || "your-secret-key",
      { expiresIn: "7d" },
    );

    res.status(201).json({
      success: true,
      message: "User registered successfully",
      data: {
        id: savedUser._id,
        name: savedUser.name,
        email: savedUser.email,
        token,
      },
    });
  } catch (err) {
    console.error("Error registering user:", err);
    res.status(500).json({ success: false, message: "Error registering user" });
  }
});

// Login
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user
    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid email or password" });
    }

    // Check password
    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid email or password" });
    }

    // Create token
    const token = jwt.sign(
      { id: user._id, email: user.email },
      process.env.JWT_SECRET || "your-secret-key",
      { expiresIn: "7d" },
    );

    res.json({
      success: true,
      message: "Login successful",
      data: {
        id: user._id,
        name: user.name,
        email: user.email,
        token,
      },
    });
  } catch (err) {
    console.error("Error logging in:", err);
    res.status(500).json({ success: false, message: "Error logging in" });
  }
});

// Google Sign-In
router.post("/google", async (req, res) => {
  try {
    const { email, name, googleId, idToken, photoUrl } = req.body;

    if (!email || !googleId || !idToken) {
      return res.status(400).json({
        success: false,
        message: "Missing required fields",
      });
    }

    // Check if user already exists
    let user = await User.findOne({ email });

    if (user) {
      // User exists, update Google ID and photo if not set
      if (!user.googleId) {
        user.googleId = googleId;
      }
      if (photoUrl && !user.avatarUrl) {
        user.avatarUrl = photoUrl;
      }
      user.updatedAt = new Date();
      await user.save();
    } else {
      // Create new user
      user = new User({
        name,
        email,
        googleId,
        avatarUrl: photoUrl,
        password: await bcrypt.hash(Math.random().toString(36), 10), // Random password for Google users
      });
      await user.save();
    }

    // Create token
    const token = jwt.sign(
      { id: user._id, email: user.email },
      process.env.JWT_SECRET || "your-secret-key",
      { expiresIn: "7d" },
    );

    res.json({
      success: true,
      message: "Google Sign-In successful",
      data: {
        id: user._id,
        name: user.name,
        email: user.email,
        avatarUrl: user.avatarUrl,
        token,
      },
    });
  } catch (err) {
    console.error("Error with Google Sign-In:", err);
    res.status(500).json({
      success: false,
      message: "Error with Google Sign-In",
    });
  }
});

// Get user profile
router.get("/:userId", async (req, res) => {
  try {
    const { userId } = req.params;

    const user = await User.findById(userId).select("-password");

    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    res.json({ success: true, data: user });
  } catch (err) {
    console.error("Error fetching user:", err);
    res.status(500).json({ success: false, message: "Error fetching user" });
  }
});

// Update user profile
router.put("/:userId", async (req, res) => {
  try {
    const { userId } = req.params;
    const { name, phone, avatarUrl } = req.body;

    const updatedUser = await User.findByIdAndUpdate(
      userId,
      { name, phone, avatarUrl, updatedAt: new Date() },
      { new: true },
    ).select("-password");

    if (!updatedUser) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    res.json({
      success: true,
      message: "Profile updated successfully",
      data: updatedUser,
    });
  } catch (err) {
    console.error("Error updating profile:", err);
    res.status(500).json({ success: false, message: "Error updating profile" });
  }
});

// Delete user account
router.delete("/:userId", async (req, res) => {
  try {
    const { userId } = req.params;

    // Check if user exists
    const user = await User.findById(userId);
    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    // Delete all related data
    await Promise.all([
      Booking.deleteMany({ userId }),
      Favorite.deleteMany({ userId }),
      Review.deleteMany({ userId }),
      User.findByIdAndDelete(userId),
    ]);

    res.json({
      success: true,
      message: "Account and all related data deleted successfully",
    });
  } catch (err) {
    console.error("Error deleting account:", err);
    res.status(500).json({ success: false, message: "Error deleting account" });
  }
});

module.exports = router;
