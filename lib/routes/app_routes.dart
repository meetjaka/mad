import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/event/event_details_screen.dart';
import '../screens/event/add_event_screen.dart';
import '../screens/event/edit_event_screen.dart';
import '../screens/event/my_events_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/booking/my_bookings_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/favorites/favorites_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String eventDetails = '/event';
  static const String addEvent = '/add-event';
  static const String editEvent = '/edit-event';
  static const String myEvents = '/my-events';
  static const String booking = '/booking';
  static const String myBookings = '/bookings';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String favorites = '/favorites';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen(), settings);
      case login:
        return _buildRoute(const LoginScreen(), settings);
      case register:
        return _buildRoute(const RegisterScreen(), settings);
      case home:
        return _buildRoute(const HomeScreen(), settings);
      case eventDetails:
        return _buildRoute(EventDetailsScreen(event: args), settings);
      case addEvent:
        return _buildRoute(const AddEventScreen(), settings);
      case editEvent:
        return _buildRoute(EditEventScreen(event: args), settings);
      case myEvents:
        return _buildRoute(const MyEventsScreen(), settings);
      case booking:
        return _buildRoute(BookingScreen(event: args), settings);
      case myBookings:
        return _buildRoute(const MyBookingsScreen(), settings);
      case profile:
        return _buildRoute(const ProfileScreen(), settings);
      case editProfile:
        if (args is Map<String, dynamic>) {
          return _buildRoute(EditProfileScreen(userData: args), settings);
        }
        return null;
      case favorites:
        return _buildRoute(const FavoritesScreen(), settings);
      default:
        return null;
    }
  }

  static PageRouteBuilder _buildRoute(Widget child, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, animation, secondaryAnimation) => child,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0.0, 0.08), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut));
        return FadeTransition(
            opacity: animation,
            child: SlideTransition(
                position: animation.drive(tween), child: child));
      },
    );
  }
}
