const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
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

module.exports = router;
