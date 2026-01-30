import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import '../../routes/app_routes.dart';
import '../../core/api_service.dart';
import 'widgets/auth_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.login(
        email: _email.text.trim(),
        password: _password.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        _showError(result['message'] ?? 'Login failed');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtle = theme.colorScheme.onSurface.withOpacity(0.65);

    return AuthShell(
      title: 'Welcome back',
      subtitle: 'Sign in to track your events, bookings, and reviews.',
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            AuthHighlight(
                icon: Icons.timelapse_rounded, label: '2-min sign in'),
            AuthHighlight(
                icon: Icons.emoji_events_rounded, label: 'Curated picks'),
            AuthHighlight(
                icon: Icons.favorite_rounded, label: 'Favorites synced'),
          ],
        ),
        const SizedBox(height: 18),
        InputField(hint: 'Email address', controller: _email),
        const SizedBox(height: 12),
        InputField(hint: 'Password', controller: _password, obscure: true),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Forgot password?',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                color: subtle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            label: _isLoading ? 'Logging in...' : 'Login',
            onPressed: _isLoading ? () {} : _handleLogin,
          ),
        ),
      ],
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New here?',
            style: GoogleFonts.manrope(
              color: subtle,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
            child: Text(
              'Create account',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
