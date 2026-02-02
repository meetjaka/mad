import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/api_service.dart';
import '../../models/event_model.dart';
import '../../routes/app_routes.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  bool _isLoading = true;
  List<dynamic> _myEvents = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMyEvents();
  }

  Future<void> _loadMyEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ApiService.getUserEvents();

      print('My Events Result: $result');

      if (result['success'] == true) {
        setState(() {
          _myEvents = result['data'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = result['message'] ?? 'Failed to load events';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Load events exception: $e');
      setState(() {
        _error = 'Error loading events: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Events',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              final result =
                  await Navigator.pushNamed(context, AppRoutes.addEvent);
              if (result == true) {
                _loadMyEvents(); // Reload events after adding new one
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _loadMyEvents,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _myEvents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No events created yet',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first event!',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.pushNamed(
                                  context, AppRoutes.addEvent);
                              if (result == true) {
                                _loadMyEvents();
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Create Event'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadMyEvents,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _myEvents.length,
                        itemBuilder: (context, index) {
                          final event = _myEvents[index];
                          return _EventCard(event: event);
                        },
                      ),
                    ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final dynamic event;

  const _EventCard({required this.event});

  Event _convertToEvent(dynamic eventData) {
    return Event(
      id: eventData['_id']?.toString() ?? eventData['id']?.toString() ?? '',
      title: eventData['title'] ?? '',
      organizer: eventData['organizer'] ?? 'Unknown',
      dateTime: eventData['dateTime'] != null
          ? DateTime.parse(eventData['dateTime'])
          : DateTime.now(),
      location: eventData['location'] ?? '',
      price: (eventData['price'] ?? 0).toDouble(),
      imageUrl: eventData['imageUrl'] ?? 'https://picsum.photos/400/300',
      category: eventData['category'] ?? 'Other',
      description: eventData['description'] ?? '',
      rating: (eventData['rating'] ?? 4.5).toDouble(),
      attendees: eventData['attendees'] ?? 0,
      duration: eventData['duration'] ?? '2 hours',
      difficulty: eventData['difficulty'] ?? 'Beginner',
      tags:
          eventData['tags'] != null ? List<String>.from(eventData['tags']) : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event['category'] ?? 'Event',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.visibility,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${event['attendees'] ?? 0}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event['title'] ?? 'Untitled Event',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event['location'] ?? 'TBA',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(event['dateTime']),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '\$${event['price']?.toString() ?? '0'}',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    // Navigate to edit event screen
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.editEvent,
                      arguments: _convertToEvent(event),
                    );
                    if (result == true) {
                      // Reload events after edit/delete
                      final state = context
                          .findAncestorStateOfType<_MyEventsScreenState>();
                      state?._loadMyEvents();
                    }
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic dateTime) {
    if (dateTime == null) return 'TBA';
    try {
      final date = DateTime.parse(dateTime.toString());
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'TBA';
    }
  }
}
