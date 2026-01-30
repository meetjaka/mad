const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
const router = express.Router();

// Register
router.post("/register", async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;

    const pool = getPool();

    // Check if user exists
    const checkResult = await pool
      .request()
      .input("email", "NVarChar", email)
      .query("SELECT * FROM Users WHERE email = @email");

    if (checkResult.recordset.length > 0) {
      return res
        .status(400)
        .json({ success: false, message: "Email already registered" });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const result = await pool
      .request()
      .input("name", "NVarChar", name)
      .input("email", "NVarChar", email)
      .input("password", "NVarChar(MAX)", hashedPassword)
      .input("phone", "NVarChar", phone).query(`
        INSERT INTO Users (name, email, password, phone)
        VALUES (@name, @email, @password, @phone);
        SELECT SCOPE_IDENTITY() as id;
      `);

    const userId = result.recordset[0].id;
    const token = jwt.sign({ id: userId, email }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });

    res.status(201).json({
      success: true,
      message: "User registered successfully",
      data: { id: userId, name, email, token },
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

    const pool = getPool();

    // Find user
    const result = await pool
      .request()
      .input("email", "NVarChar", email)
      .query("SELECT * FROM Users WHERE email = @email");

    if (result.recordset.length === 0) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid email or password" });
    }

    const user = result.recordset[0];

    // Check password
    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid email or password" });
    }

    // Create token
    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );

    res.json({
      success: true,
      message: "Login successful",
      data: {
        id: user.id,
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
    const pool = getPool();

    const result = await pool
      .request()
      .input("userId", "Int", userId)
      .query(
        "SELECT id, name, email, phone, avatarUrl, createdAt FROM Users WHERE id = @userId"
      );

    if (result.recordset.length === 0) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    res.json({ success: true, data: result.recordset[0] });
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
    const pool = getPool();

    await pool
      .request()
      .input("userId", "Int", userId)
      .input("name", "NVarChar", name)
      .input("phone", "NVarChar", phone)
      .input("avatarUrl", "NVarChar(MAX)", avatarUrl).query(`
        UPDATE Users 
        SET name = @name, phone = @phone, avatarUrl = @avatarUrl, updatedAt = GETDATE()
        WHERE id = @userId
      `);

    res.json({ success: true, message: "Profile updated successfully" });
  } catch (err) {
    console.error("Error updating profile:", err);
    res.status(500).json({ success: false, message: "Error updating profile" });
  }
});

module.exports = router;
