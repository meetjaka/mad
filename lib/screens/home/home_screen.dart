import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/category_chips.dart';
import '../../widgets/event_card.dart';
import '../../data/dummy_events.dart';
import '../../models/event_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/shimmer.dart';
import '../../providers/favorites_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selected = 'All';
  List<String> categories = ['All', 'Music', 'Tech', 'Sports', 'Workshop'];
  String _query = '';
  bool _loading = true;
  String _sortBy = 'Popular';

  List<Event> get filtered {
    var list = dummyEvents;

    // Filter by category
    if (_selected != 'All')
      list = list.where((e) => e.category == _selected).toList();

    // Filter by search query
    if (_query.isNotEmpty)
      list = list
          .where((e) =>
              e.title.toLowerCase().contains(_query.toLowerCase()) ||
              e.description.toLowerCase().contains(_query.toLowerCase()) ||
              e.organizer.toLowerCase().contains(_query.toLowerCase()))
          .toList();

    // Sort events
    switch (_sortBy) {
      case 'Popular':
        list.sort((a, b) => b.attendees.compareTo(a.attendees));
        break;
      case 'Rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Nearest':
        list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        break;
      case 'Price: Low to High':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
    }

    return list;
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900),
        () => setState(() => _loading = false));
  }

  @override
  Widget build(BuildContext context) {
    final favs = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Discover Events'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search and filter row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search events...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                const SizedBox(width: 12),
                Material(
                  color: Colors.transparent,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.tune),
                    onSelected: (value) => setState(() => _sortBy = value),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Popular',
                        child: Text('Popular'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Rating',
                        child: Text('Top Rated'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Nearest',
                        child: Text('Coming Soon'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Price: Low to High',
                        child: Text('Price: Low to High'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Category chips
            CategoryChips(
              categories: categories,
              selected: _selected,
              onSelected: (c) => setState(() => _selected = c),
            ),
            const SizedBox(height: 12),

            // Events grid or loading
            Expanded(
              child: _loading
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, i) => Shimmer(
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                  : filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No events found',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your search or filters',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, i) => EventCard(
                            event: filtered[i],
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.eventDetails,
                              arguments: filtered[i],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) Navigator.pushNamed(context, AppRoutes.favorites);
          if (i == 2) Navigator.pushNamed(context, AppRoutes.myBookings);
          if (i == 3) Navigator.pushNamed(context, AppRoutes.profile);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
