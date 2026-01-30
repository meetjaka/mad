class Event {
  final String id;
  final String title;
  final String organizer;
  final DateTime dateTime;
  final String location;
  final double price;
  final String imageUrl;
  final String category;
  final String description;
  final double rating;
  final int attendees;
  final String duration;
  final String difficulty;
  final List<String> tags;

  Event({
    required this.id,
    required this.title,
    required this.organizer,
    required this.dateTime,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description,
    this.rating = 4.5,
    this.attendees = 0,
    this.duration = '2 hours',
    this.difficulty = 'Beginner',
    this.tags = const [],
  });
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
