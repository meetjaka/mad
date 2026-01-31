import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/events_provider.dart';
import '../../widgets/event_card.dart';
import '../../routes/app_routes.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoritesProvider);
    final eventsState = ref.watch(eventsProvider);
    final items = eventsState.events.where((e) => favs.contains(e.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: items.isEmpty
            ? Center(
                child: Text('No favorites yet',
                    style: Theme.of(context).textTheme.bodyLarge))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                itemCount: items.length,
                itemBuilder: (context, i) => GestureDetector(
                  onLongPress: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Remove favorite'),
                        content:
                            const Text('Remove this event from favorites?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Remove')),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      ref.read(favoritesProvider.notifier).toggle(items[i].id);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Removed from favorites')));
                    }
                  },
                  child: EventCard(
                    event: items[i],
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.eventDetails,
                        arguments: items[i]),
                  ),
                ),
              ),
      ),
    );
  }
}
