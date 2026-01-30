const express = require("express");
const { getPool } = require("../config/database");
const router = express.Router();

// Create booking
router.post("/", async (req, res) => {
  try {
    const { userId, eventId, tickets, totalPrice, seatType } = req.body;

    const pool = getPool();
    const result = await pool
      .request()
      .input("userId", "Int", userId)
      .input("eventId", "Int", eventId)
      .input("tickets", "Int", tickets)
      .input("totalPrice", "Decimal(10,2)", totalPrice)
      .input("seatType", "NVarChar", seatType || "Standard").query(`
        INSERT INTO Bookings (userId, eventId, tickets, totalPrice, seatType)
        VALUES (@userId, @eventId, @tickets, @totalPrice, @seatType);
        SELECT SCOPE_IDENTITY() as id;
      `);

    const bookingId = result.recordset[0].id;
    res
      .status(201)
      .json({ success: true, data: { id: bookingId, ...req.body } });
  } catch (err) {
    console.error("Error creating booking:", err);
    res.status(500).json({ success: false, message: "Error creating booking" });
  }
});

// Get user bookings
router.get("/user/:userId", async (req, res) => {
  try {
    const { userId } = req.params;
    const pool = getPool();

    const result = await pool.request().input("userId", "Int", userId).query(`
        SELECT b.*, e.title, e.imageUrl, e.dateTime, e.location
        FROM Bookings b
        INNER JOIN Events e ON b.eventId = e.id
        WHERE b.userId = @userId
        ORDER BY b.bookingDate DESC
      `);

    res.json({ success: true, data: result.recordset });
  } catch (err) {
    console.error("Error fetching bookings:", err);
    res
      .status(500)
      .json({ success: false, message: "Error fetching bookings" });
  }
});

// Cancel booking
router.put("/:id/cancel", async (req, res) => {
  try {
    const { id } = req.params;
    const pool = getPool();

    await pool
      .request()
      .input("id", "Int", id)
      .query("UPDATE Bookings SET cancelled = 1 WHERE id = @id");

    res.json({ success: true, message: "Booking cancelled" });
  } catch (err) {
    console.error("Error cancelling booking:", err);
    res
      .status(500)
      .json({ success: false, message: "Error cancelling booking" });
  }
});

module.exports = router;
