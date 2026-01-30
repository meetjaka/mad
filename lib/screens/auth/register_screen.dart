import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import '../../core/api_service.dart';
import '../../routes/app_routes.dart';
import 'widgets/auth_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_name.text.isEmpty ||
        _email.text.isEmpty ||
        _password.text.isEmpty ||
        _confirm.text.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    if (_password.text != _confirm.text) {
      _showError('Passwords do not match');
      return;
    }

    if (_password.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.register(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Account created successfully!'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        _showError(result['message'] ?? 'Registration failed');
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
      title: 'Create your account',
      subtitle:
          'Join Event Horizon to bookmark favorites, leave reviews, and manage bookings.',
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            AuthHighlight(
                icon: Icons.handshake_rounded, label: 'Trusted organizers'),
            AuthHighlight(
                icon: Icons.lock_rounded, label: 'Secure credentials'),
            AuthHighlight(
                icon: Icons.notifications_active_rounded,
                label: 'Smart reminders'),
          ],
        ),
        const SizedBox(height: 18),
        InputField(hint: 'Full name', controller: _name),
        const SizedBox(height: 12),
        InputField(hint: 'Email address', controller: _email),
        const SizedBox(height: 12),
        InputField(hint: 'Password', controller: _password, obscure: true),
        const SizedBox(height: 12),
        InputField(
            hint: 'Confirm password', controller: _confirm, obscure: true),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            label: _isLoading ? 'Creating account...' : 'Create account',
            onPressed: _isLoading ? () {} : _handleRegister,
          ),
        ),
      ],
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already registered?',
            style: GoogleFonts.manrope(
              color: subtle,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Sign in',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
