import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';
import '../core/api_service.dart';

// Events state class
class EventsState {
  final List<Event> events;
  final bool isLoading;
  final String? error;

  EventsState({
    this.events = const [],
    this.isLoading = false,
    this.error,
  });

  EventsState copyWith({
    List<Event>? events,
    bool? isLoading,
    String? error,
  }) {
    return EventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Events notifier
class EventsNotifier extends StateNotifier<EventsState> {
  EventsNotifier() : super(EventsState());

  // Fetch events from API
  Future<void> fetchEvents({
    String? category,
    String? search,
    String? sort,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiService.getEvents(
        category: category,
        search: search,
        sort: sort,
      );

      if (response['success'] == true) {
        final List<dynamic> eventsData = response['data'] ?? [];
        final List<Event> events =
            eventsData.map((json) => _eventFromJson(json)).toList();

        state = state.copyWith(
          events: events,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['message'] ?? 'Failed to load events',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error loading events: ${e.toString()}',
      );
    }
  }

  // Convert JSON to Event model
  Event _eventFromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      organizer: json['organizer'] ?? 'Unknown',
      dateTime: json['dateTime'] != null
          ? DateTime.parse(json['dateTime'])
          : DateTime.now(),
      location: json['location'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ??
          'https://picsum.photos/400/300?random=${json['id'] ?? 1}',
      category: json['category'] ?? 'Other',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 4.5).toDouble(),
      attendees: json['attendees'] ?? 0,
      duration: json['duration'] ?? '2 hours',
      difficulty: json['difficulty'] ?? 'Beginner',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    );
  }

  // Refresh events
  Future<void> refresh() async {
    await fetchEvents();
  }
}

// Events provider
final eventsProvider =
    StateNotifierProvider<EventsNotifier, EventsState>((ref) {
  return EventsNotifier();
});
