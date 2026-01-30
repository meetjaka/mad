import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';

class Booking {
  final Event event;
  final int tickets;
  final DateTime bookedAt;
  bool cancelled;

  Booking({required this.event, required this.tickets})
    : bookedAt = DateTime.now(),
      cancelled = false;
}

class BookingsNotifier extends StateNotifier<List<Booking>> {
  BookingsNotifier() : super([]);

  void addBooking(Event event, int tickets) {
    state = [...state, Booking(event: event, tickets: tickets)];
  }

  void cancelBooking(Booking b) {
    b.cancelled = true;
    state = [...state];
  }

  void removeBooking(Booking b) {
    state = state.where((x) => x != b).toList();
  }
}

final bookingsProvider = StateNotifierProvider<BookingsNotifier, List<Booking>>(
  (ref) => BookingsNotifier(),
);
