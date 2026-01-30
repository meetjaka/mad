const mongoose = require("mongoose");

const bookingSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  eventId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Event",
    required: true,
  },
  tickets: {
    type: Number,
    required: true,
  },
  totalPrice: {
    type: Number,
    required: true,
  },
  seatType: {
    type: String,
    default: "Standard",
  },
  bookingDate: {
    type: Date,
    default: Date.now,
  },
  cancelled: {
    type: Boolean,
    default: false,
  },
});

module.exports = mongoose.model("Booking", bookingSchema);
