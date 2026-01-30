import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import 'widgets/auth_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
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
        InputField(hint: 'Full name'),
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
            label: 'Create account',
            onPressed: () => Navigator.pop(context),
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
