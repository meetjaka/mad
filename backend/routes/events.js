const express = require("express");
const Event = require("../models/Event");
const router = express.Router();

// Get all events with filtering and sorting
router.get("/", async (req, res) => {
  try {
    const { category, search, sort } = req.query;
    let query = {};

    if (category && category !== "All") {
      query.category = category;
    }

    if (search) {
      query.$or = [
        { title: { $regex: search, $options: "i" } },
        { description: { $regex: search, $options: "i" } },
        { organizer: { $regex: search, $options: "i" } },
      ];
    }

    let events = await Event.find(query);

    // Sort events
    if (sort === "Popular") {
      events.sort((a, b) => b.attendees - a.attendees);
    } else if (sort === "Rating") {
      events.sort((a, b) => b.rating - a.rating);
    } else if (sort === "Nearest") {
      events.sort((a, b) => a.dateTime - b.dateTime);
    } else if (sort === "Price: Low to High") {
      events.sort((a, b) => a.price - b.price);
    } else {
      events.sort((a, b) => a.dateTime - b.dateTime);
    }

    res.json({ success: true, data: events });
  } catch (err) {
    console.error("Error fetching events:", err);
    res.status(500).json({ success: false, message: "Error fetching events" });
  }
});

// Get single event
router.get("/:id", async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);

    if (!event) {
      return res.status(404).json({ success: false, message: "Event not found" });
    }

    res.json({ success: true, data: event });
  } catch (err) {
    console.error("Error fetching event:", err);
    res.status(500).json({ success: false, message: "Error fetching event" });
  }
});

// Create event (admin only)
router.post("/", async (req, res) => {
  try {
    const {
      title,
      description,
      organizer,
      category,
      dateTime,
      location,
      price,
      imageUrl,
      rating,
      attendees,
      duration,
      difficulty,
      tags,
    } = req.body;

    const event = new Event({
      title,
      description,
      organizer,
      category,
      dateTime: new Date(dateTime),
      location,
      price,
      imageUrl,
      rating: rating || 4.5,
      attendees: attendees || 0,
      duration,
      difficulty,
      tags: tags || [],
    });

    const savedEvent = await event.save();
    res.status(201).json({ success: true, data: savedEvent });
  } catch (err) {
    console.error("Error creating event:", err);
    res.status(500).json({ success: false, message: "Error creating event" });
  }
});

// Update event
router.put("/:id", async (req, res) => {
  try {
    const {
      title,
      description,
      organizer,
      category,
      dateTime,
      location,
      price,
      imageUrl,
      rating,
      attendees,
      duration,
      difficulty,
      tags,
    } = req.body;

    const updatedEvent = await Event.findByIdAndUpdate(
      req.params.id,
      {
        title,
        description,
        organizer,
        category,
        dateTime: new Date(dateTime),
        location,
        price,
        imageUrl,
        rating,
        attendees,
        duration,
        difficulty,
        tags,
        updatedAt: new Date(),
      },
      { new: true }
    );

    if (!updatedEvent) {
      return res.status(404).json({ success: false, message: "Event not found" });
    }

    res.json({ success: true, message: "Event updated successfully", data: updatedEvent });
  } catch (err) {
    console.error("Error updating event:", err);
    res.status(500).json({ success: false, message: "Error updating event" });
  }
});

// Delete event
router.delete("/:id", async (req, res) => {
  try {
    const deletedEvent = await Event.findByIdAndDelete(req.params.id);

    if (!deletedEvent) {
      return res.status(404).json({ success: false, message: "Event not found" });
    }

    res.json({ success: true, message: "Event deleted successfully" });
  } catch (err) {
    console.error("Error deleting event:", err);
    res.status(500).json({ success: false, message: "Error deleting event" });
  }
});

module.exports = router;
  } catch (err) {
    console.error("Error fetching events:", err);
    res.status(500).json({ success: false, message: "Error fetching events" });
  }
});

// Get single event
router.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const pool = getPool();
    const result = await pool
      .request()
      .input("id", "Int", id)
      .query("SELECT * FROM Events WHERE id = @id");

    if (result.recordset.length === 0) {
      return res
        .status(404)
        .json({ success: false, message: "Event not found" });
    }

    const event = result.recordset[0];
    event.tags = event.tags ? JSON.parse(event.tags) : [];

    res.json({ success: true, data: event });
  } catch (err) {
    console.error("Error fetching event:", err);
    res.status(500).json({ success: false, message: "Error fetching event" });
  }
});

// Create event (admin only)
router.post("/", async (req, res) => {
  try {
    const {
      title,
      description,
      organizer,
      category,
      dateTime,
      location,
      price,
      imageUrl,
      rating,
      attendees,
      duration,
      difficulty,
      tags,
    } = req.body;

    const pool = getPool();
    const result = await pool
      .request()
      .input("title", "NVarChar", title)
      .input("description", "NVarChar(MAX)", description)
      .input("organizer", "NVarChar", organizer)
      .input("category", "NVarChar", category)
      .input("dateTime", "DateTime", new Date(dateTime))
      .input("location", "NVarChar(MAX)", location)
      .input("price", "Decimal(10,2)", price)
      .input("imageUrl", "NVarChar(MAX)", imageUrl)
      .input("rating", "Decimal(3,1)", rating || 4.5)
      .input("attendees", "Int", attendees || 0)
      .input("duration", "NVarChar", duration)
      .input("difficulty", "NVarChar", difficulty)
      .input("tags", "NVarChar(MAX)", JSON.stringify(tags || [])).query(`
        INSERT INTO Events (title, description, organizer, category, dateTime, location, price, imageUrl, rating, attendees, duration, difficulty, tags)
        VALUES (@title, @description, @organizer, @category, @dateTime, @location, @price, @imageUrl, @rating, @attendees, @duration, @difficulty, @tags);
        SELECT SCOPE_IDENTITY() as id;
      `);

    const eventId = result.recordset[0].id;
    res.status(201).json({ success: true, data: { id: eventId, ...req.body } });
  } catch (err) {
    console.error("Error creating event:", err);
    res.status(500).json({ success: false, message: "Error creating event" });
  }
});

// Update event
router.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const {
      title,
      description,
      organizer,
      category,
      dateTime,
      location,
      price,
      imageUrl,
      rating,
      attendees,
      duration,
      difficulty,
      tags,
    } = req.body;

    const pool = getPool();
    await pool
      .request()
      .input("id", "Int", id)
      .input("title", "NVarChar", title)
      .input("description", "NVarChar(MAX)", description)
      .input("organizer", "NVarChar", organizer)
      .input("category", "NVarChar", category)
      .input("dateTime", "DateTime", new Date(dateTime))
      .input("location", "NVarChar(MAX)", location)
      .input("price", "Decimal(10,2)", price)
      .input("imageUrl", "NVarChar(MAX)", imageUrl)
      .input("rating", "Decimal(3,1)", rating)
      .input("attendees", "Int", attendees)
      .input("duration", "NVarChar", duration)
      .input("difficulty", "NVarChar", difficulty)
      .input("tags", "NVarChar(MAX)", JSON.stringify(tags || [])).query(`
        UPDATE Events 
        SET title = @title, description = @description, organizer = @organizer, 
            category = @category, dateTime = @dateTime, location = @location, 
            price = @price, imageUrl = @imageUrl, rating = @rating, attendees = @attendees,
            duration = @duration, difficulty = @difficulty, tags = @tags, updatedAt = GETDATE()
        WHERE id = @id
      `);

    res.json({ success: true, message: "Event updated successfully" });
  } catch (err) {
    console.error("Error updating event:", err);
    res.status(500).json({ success: false, message: "Error updating event" });
  }
});

// Delete event
router.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const pool = getPool();

    await pool
      .request()
      .input("id", "Int", id)
      .query("DELETE FROM Events WHERE id = @id");

    res.json({ success: true, message: "Event deleted successfully" });
  } catch (err) {
    console.error("Error deleting event:", err);
    res.status(500).json({ success: false, message: "Error deleting event" });
  }
});

module.exports = router;
