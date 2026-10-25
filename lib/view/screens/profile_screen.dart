import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    final isLoggedIn = user != null;
    final name = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : 'MODE Customer';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'MY PROFILE',
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 15,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Profile header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.secondary.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      isLoggedIn ? name : 'Welcome to MODE',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      isLoggedIn
                          ? user.email ?? ''
                          : 'Sign in to manage your account',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: 180,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                if (!isLoggedIn) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const LoginScreen(),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  await context
                                      .read<AuthProvider>()
                                      .logout();

                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Logged out successfully.',
                                        ),
                                        behavior:
                                            SnackBarBehavior.floating,
                                      ),
                                    );
                                } catch (e) {
                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Could not log out: $e',
                                        ),
                                        behavior:
                                            SnackBarBehavior.floating,
                                      ),
                                    );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor:
                              AppColors.secondary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                isLoggedIn ? 'LOG OUT' : 'SIGN IN',
                                style: const TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 1.3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              Text(
                'MY ACCOUNT',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 13,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 12),

              _ProfileMenuTile(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: 'View your order history',
                onTap: () => _showComingSoon(context, 'My Orders'),
              ),
              _ProfileMenuTile(
                icon: Icons.favorite_border,
                title: 'My Favorites',
                subtitle: 'Your saved products',
                onTap: () => _showComingSoon(context, 'My Favorites'),
              ),
              _ProfileMenuTile(
                icon: Icons.location_on_outlined,
                title: 'My Addresses',
                subtitle: 'Manage delivery addresses',
                onTap: () => _showComingSoon(context, 'My Addresses'),
              ),

              const SizedBox(height: 28),

              Text(
                'PREFERENCES',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 13,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 12),

              _ProfileMenuTile(
                icon: Icons.notifications_none,
                title: 'Notifications',
                subtitle: 'Manage your notifications',
                onTap: () =>
                    _showComingSoon(context, 'Notifications'),
              ),
              _ProfileMenuTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help with your shopping',
                onTap: () =>
                    _showComingSoon(context, 'Help & Support'),
              ),
              _ProfileMenuTile(
                icon: Icons.info_outline,
                title: 'About MODE',
                subtitle: 'Learn more about our store',
                onTap: () => _showComingSoon(context, 'About MODE'),
              ),

              const SizedBox(height: 24),

              const Center(
                child: Text(
                  'MODE  •  STYLE YOUR WAY',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static void _showComingSoon(
    BuildContext context,
    String feature,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature will be available soon.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightGrey,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 21,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 11,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}