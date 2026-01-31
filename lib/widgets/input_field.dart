import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final bool obscure;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.hint,
    this.controller,
    this.obscure = false,
    this.prefixIcon,
    this.validator,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _isFocused = false;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isFocused ? [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscure && !_showPassword,
          validator: widget.validator,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: widget.prefixIcon != null ? Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                widget.prefixIcon,
                color: _isFocused 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.onSurface.withOpacity(0.4),
                size: 22,
              ),
            ) : null,
            suffixIcon: widget.obscure ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () => setState(() => _showPassword = !_showPassword),
                icon: Icon(
                  _showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  size: 22,
                ),
              ),
            ) : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.prefixIcon != null ? 0 : 20,
              vertical: 18,
            ),
            filled: true,
            fillColor: _isFocused 
              ? theme.colorScheme.primary.withOpacity(0.04)
              : theme.colorScheme.surfaceVariant.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.6),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
