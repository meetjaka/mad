import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_button.dart';
import '../../routes/app_routes.dart';
import '../../providers/theme_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/bookings_provider.dart';
import '../../core/api_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  int _myEventsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadMyEventsCount();
  }

  Future<void> _loadMyEventsCount() async {
    try {
      final result = await ApiService.getUserEvents();
      if (result['success'] == true) {
        setState(() {
          _myEventsCount = (result['data'] as List?)?.length ?? 0;
        });
      }
    } catch (e) {
      // Silently fail, keep count at 0
    }
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    try {
      final result = await ApiService.getUserProfile();

      if (result['success'] == true) {
        setState(() {
          _userData = result['data'];
          _isLoading = false;
        });
      } else {
        // Fallback to local user data
        final localUser = await ApiService.getUser();
        setState(() {
          _userData = localUser;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to local user data
      final localUser = await ApiService.getUser();
      setState(() {
        _userData = localUser;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ApiService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    final TextEditingController confirmController = TextEditingController();
    bool isDeleting = false;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              const SizedBox(width: 12),
              const Text('Delete Account'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This action cannot be undone!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'All your data will be permanently deleted:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildWarningItem('• Account information'),
              _buildWarningItem('• All bookings'),
              _buildWarningItem('• Saved favorites'),
              _buildWarningItem('• Reviews and ratings'),
              _buildWarningItem('• Events you created'),
              const SizedBox(height: 16),
              const Text(
                'Type CONFIRM to delete your account:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmController,
                decoration: InputDecoration(
                  hintText: 'Type CONFIRM',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed:
                  isDeleting ? null : () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isDeleting
                  ? null
                  : (confirmController.text.trim() == 'CONFIRM'
                      ? () => Navigator.pop(context, true)
                      : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey,
              ),
              child: isDeleting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      // Show loading dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Deleting account...'),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      final result = await ApiService.deleteAccount();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        if (result['success'] == true) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to login screen
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to delete account'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final favs = ref.watch(favoritesProvider);
    final bookings = ref.watch(bookingsProvider);
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final userName = _userData?['name'] ?? 'User';
    final userEmail = _userData?['email'] ?? 'No email';
    final userPhone = _userData?['phone'] ?? 'No phone';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Text(
                        userName[0].toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    if (userPhone != 'No phone') ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone,
                              size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            userPhone,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.editProfile,
                          arguments: _userData,
                        );
                        if (result == true) {
                          // Reload profile after editing
                          _loadUserProfile();
                        }
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Statistics
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[850]
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey[700]!
                        : Colors.grey[200]!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatCard('${bookings.length}', 'Bookings',
                        Icons.event_note, theme),
                    _StatCard(
                        '${favs.length}', 'Favorites', Icons.favorite, theme),
                    _StatCard('$_myEventsCount', 'My Events',
                        Icons.event_available, theme),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // My Events Section
              _SectionTitle('My Events', theme),
              const SizedBox(height: 12),
              _MenuTile(
                icon: Icons.event,
                iconColor: theme.primaryColor,
                title: 'Events I Created',
                subtitle: '$_myEventsCount events',
                onTap: () => Navigator.pushNamed(context, AppRoutes.myEvents),
                theme: theme,
              ),
              _MenuTile(
                icon: Icons.favorite_outline,
                iconColor: Colors.pink,
                title: 'Saved Events',
                subtitle: '${favs.length} events',
                onTap: () => Navigator.pushNamed(context, AppRoutes.favorites),
                theme: theme,
              ),
              _MenuTile(
                icon: Icons.calendar_today,
                iconColor: Colors.blue,
                title: 'My Bookings',
                subtitle: '${bookings.length} upcoming',
                onTap: () => Navigator.pushNamed(context, AppRoutes.myBookings),
                theme: theme,
              ),
              const SizedBox(height: 24),

              // Account Settings
              _SectionTitle('Account Settings', theme),
              const SizedBox(height: 12),
              _MenuTile(
                icon: Icons.brightness_6_outlined,
                iconColor: Colors.orange,
                title: 'Dark Theme',
                subtitle: themeMode == ThemeMode.dark ? 'Enabled' : 'Disabled',
                theme: theme,
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (v) => ref.read(themeModeProvider.notifier).state =
                      v ? ThemeMode.dark : ThemeMode.light,
                ),
              ),
              _MenuTile(
                icon: Icons.notifications_outlined,
                iconColor: Colors.purple,
                title: 'Notifications',
                subtitle: 'Push notifications',
                theme: theme,
                trailing: Switch(
                  value: true,
                  onChanged: (v) {},
                ),
              ),
              _MenuTile(
                icon: Icons.language,
                iconColor: Colors.green,
                title: 'Language',
                subtitle: 'English',
                onTap: () {},
                theme: theme,
              ),
              const SizedBox(height: 24),

              // More Options
              _SectionTitle('More', theme),
              const SizedBox(height: 12),
              _MenuTile(
                icon: Icons.help_outline,
                iconColor: Colors.teal,
                title: 'Help & Support',
                onTap: () {},
                theme: theme,
              ),
              _MenuTile(
                icon: Icons.privacy_tip_outlined,
                iconColor: Colors.indigo,
                title: 'Privacy Policy',
                onTap: () {},
                theme: theme,
              ),
              _MenuTile(
                icon: Icons.description_outlined,
                iconColor: Colors.deepOrange,
                title: 'Terms & Conditions',
                onTap: () {},
                theme: theme,
              ),
              const SizedBox(height: 24),

              // Danger Zone
              _SectionTitle('Danger Zone', theme),
              const SizedBox(height: 12),

              // Delete Account
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                  color: Colors.red.withOpacity(0.05),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Delete Account',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Permanently delete your account and all associated data',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _handleDeleteAccount,
                        icon: const Icon(Icons.delete_forever, size: 18),
                        label: const Text('Delete My Account'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Logout
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: TextButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout, color: Colors.orange),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionTitle(this.title, this.theme);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color:
            theme.brightness == Brightness.dark ? Colors.white : Colors.black87,
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final ThemeData theme;

  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.grey[700]!
              : Colors.grey[200]!,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: trailing ??
            (onTap != null
                ? Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey[400])
                : null),
        onTap: onTap,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final ThemeData theme;

  const _StatCard(this.value, this.label, this.icon, this.theme);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 28, color: theme.primaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
