import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/bookings_provider.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: bookings.isEmpty
          ? const Center(child: Text('No bookings yet'))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, i) {
                final b = bookings[i];
                return ListTile(
                  leading: SizedBox(
                    width: 56,
                    child: Image.network(b.event.imageUrl, fit: BoxFit.cover),
                  ),
                  title: Text(b.event.title),
                  subtitle: Text(
                    '${b.tickets} tickets • ${b.bookedAt.toLocal()}',
                  ),
                  trailing: b.cancelled
                      ? const Text(
                          'Cancelled',
                          style: TextStyle(color: Colors.red),
                        )
                      : TextButton(
                          onPressed: () => ref
                              .read(bookingsProvider.notifier)
                              .cancelBooking(b),
                          child: const Text('Cancel'),
                        ),
                );
              },
            ),
    );
  }
}
