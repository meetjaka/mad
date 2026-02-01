import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import '../../core/api_service.dart';
import '../../core/google_auth_service.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase & number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _password.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      _showError('Please accept the terms and conditions');
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
        _showSuccess('Account created successfully! Welcome aboard!');
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else {
        setState(() => _isLoading = false);
        _showError(result['message'] ?? 'Registration failed');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Connection error. Please try again.');
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (!_acceptTerms) {
      _showError('Please accept the terms and conditions');
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('Starting Google Sign-In from Register...');
      final result = await GoogleAuthService.signInWithGoogle();
      print('Google Sign-In result: $result');

      if (!mounted) return;

      if (result['success'] == true) {
        print('Google Sign-In successful, showing success message...');
        _showSuccess('Welcome! Account created successfully.');
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else {
        setState(() => _isLoading = false);
        final message = result['message'] ?? 'Google Sign-In failed';
        if (message != 'Sign in cancelled') {
          print('Google Sign-In failed: $message');
          _showError(message);
        } else {
          print('User cancelled Google Sign-In');
        }
      }
    } catch (e) {
      print('Google Sign-In exception: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Google Sign-In error. Please try again.');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
                child: Text(message,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
                child: Text(message,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
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
          'Join thousands of event enthusiasts and never miss out on amazing experiences.',
      children: [
        const SizedBox(height: 8),
        Form(
          key: _formKey,
          child: Column(
            children: [
              InputField(
                hint: 'Full name',
                controller: _name,
                prefixIcon: Icons.person_outline_rounded,
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              InputField(
                hint: 'Email address',
                controller: _email,
                prefixIcon: Icons.email_outlined,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              InputField(
                hint: 'Password',
                controller: _password,
                prefixIcon: Icons.lock_outline_rounded,
                obscure: true,
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),
              InputField(
                hint: 'Confirm password',
                controller: _confirm,
                prefixIcon: Icons.lock_outline_rounded,
                obscure: true,
                validator: _validateConfirmPassword,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.1,
              child: Checkbox(
                value: _acceptTerms,
                onChanged: (value) =>
                    setState(() => _acceptTerms = value ?? false),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: subtle,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            label: 'Create Account',
            onPressed: _handleRegister,
            isLoading: _isLoading,
            icon: Icons.person_add_rounded,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                child:
                    Divider(color: theme.colorScheme.outline.withOpacity(0.3))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or sign up with',
                style: GoogleFonts.inter(
                  color: subtle,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
                child:
                    Divider(color: theme.colorScheme.outline.withOpacity(0.3))),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: 'Google',
                onPressed: _isLoading ? null : _handleGoogleSignIn,
                filled: false,
                icon: Icons.g_mobiledata_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                label: 'Apple',
                onPressed: () {},
                filled: false,
                icon: Icons.apple_rounded,
              ),
            ),
          ],
        ),
      ],
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: GoogleFonts.inter(
              color: subtle,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              'Sign in',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
