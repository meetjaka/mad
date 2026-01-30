const express = require("express");
const { getPool } = require("../config/database");
const router = express.Router();

// Get user favorites
router.get("/user/:userId", async (req, res) => {
  try {
    const { userId } = req.params;
    const pool = getPool();

    const result = await pool.request().input("userId", "Int", userId).query(`
        SELECT e.*, f.id as favoriteId
        FROM Favorites f
        INNER JOIN Events e ON f.eventId = e.id
        WHERE f.userId = @userId
        ORDER BY f.createdAt DESC
      `);

    const events = result.recordset.map((event) => ({
      ...event,
      tags: event.tags ? JSON.parse(event.tags) : [],
    }));

    res.json({ success: true, data: events });
  } catch (err) {
    console.error("Error fetching favorites:", err);
    res
      .status(500)
      .json({ success: false, message: "Error fetching favorites" });
  }
});

// Add favorite
router.post("/", async (req, res) => {
  try {
    const { userId, eventId } = req.body;
    const pool = getPool();

    const result = await pool
      .request()
      .input("userId", "Int", userId)
      .input("eventId", "Int", eventId).query(`
        IF NOT EXISTS (SELECT * FROM Favorites WHERE userId = @userId AND eventId = @eventId)
        INSERT INTO Favorites (userId, eventId) VALUES (@userId, @eventId);
        SELECT SCOPE_IDENTITY() as id;
      `);

    res.status(201).json({ success: true, data: { userId, eventId } });
  } catch (err) {
    console.error("Error adding favorite:", err);
    res.status(500).json({ success: false, message: "Error adding favorite" });
  }
});

// Remove favorite
router.delete("/:userId/:eventId", async (req, res) => {
  try {
    const { userId, eventId } = req.params;
    const pool = getPool();

    await pool
      .request()
      .input("userId", "Int", userId)
      .input("eventId", "Int", eventId)
      .query(
        "DELETE FROM Favorites WHERE userId = @userId AND eventId = @eventId"
      );

    res.json({ success: true, message: "Favorite removed" });
  } catch (err) {
    console.error("Error removing favorite:", err);
    res
      .status(500)
      .json({ success: false, message: "Error removing favorite" });
  }
});

module.exports = router;
