import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_section_title.dart';
import '../widgets/profile_photo_options.dart';

import 'login_screen.dart';
import 'saved_screen.dart';
import 'my_orders_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String _photoKey = 'mode_profile_photo';

  final ImagePicker _picker = ImagePicker();

  String? _profileImage;
  bool _isLoadingImage = true;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedImage = prefs.getString(_photoKey);

      if (!mounted) return;

      setState(() {
        _profileImage = savedImage;
        _isLoadingImage = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingImage = false);
    }
  }

  Future<void> _pickProfileImage() async {
    if (_isPickingImage) return;

    try {
      setState(() => _isPickingImage = true);

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 600,
      );

      if (pickedFile == null) return;

      final imageBytes = await pickedFile.readAsBytes();
      final encodedImage = base64Encode(imageBytes);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_photoKey, encodedImage);

      if (!mounted) return;

      setState(() => _profileImage = encodedImage);

      _showMessage('Profile photo updated successfully.');
    } catch (_) {
      if (!mounted) return;
      _showMessage('Could not select image. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  Future<void> _removeProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_photoKey);

      if (!mounted) return;

      setState(() => _profileImage = null);
      _showMessage('Profile photo removed.');
    } catch (_) {
      if (!mounted) return;
      _showMessage('Could not remove profile photo.');
    }
  }

  void _showPhotoOptions() {
    showProfilePhotoOptions(
      context: context,
      hasPhoto: _profileImage != null,
      onChoose: _pickProfileImage,
      onRemove: _removeProfileImage,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _openMyOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MyOrdersScreen(),
      ),
    );
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SavedScreen(),
      ),
    );
  }

  Future<void> _handleAuth(bool isLoggedIn) async {
    if (!isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
      return;
    }

    try {
      await context.read<AuthProvider>().logout();

      if (!mounted) return;
      _showMessage('Logged out successfully.');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Could not log out: $e');
    }
  }

  Widget _buildProfileImage() {
    if (_isLoadingImage) {
      return Container(
        color: AppColors.lightGrey,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (_profileImage != null) {
      try {
        return Image.memory(
          base64Decode(_profileImage!),
          fit: BoxFit.cover,
          width: 112,
          height: 112,
          errorBuilder: (_, _, _) => _defaultProfileImage(),
        );
      } catch (_) {
        return _defaultProfileImage();
      }
    }

    return _defaultProfileImage();
  }

  Widget _defaultProfileImage() {
    return Container(
      color: AppColors.lightGrey,
      child: const Icon(
        Icons.person_outline,
        size: 52,
        color: AppColors.primary,
      ),
    );
  }

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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(
                name: name,
                email: user?.email,
                isLoggedIn: isLoggedIn,
                isLoading: auth.isLoading,
                isPickingImage: _isPickingImage,
                profileImage: _buildProfileImage(),
                onPhotoTap: _showPhotoOptions,
                onAuthTap: () => _handleAuth(isLoggedIn),
              ),

              const SizedBox(height: 32),

              const ProfileSectionTitle(title: 'MY ACCOUNT'),

              ProfileMenuTile(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: 'View your order history',
                onTap: _openMyOrders,
              ),

              ProfileMenuTile(
                icon: Icons.favorite_border,
                title: 'My Favorites',
                subtitle: 'Your saved products',
                onTap: _openFavorites,
              ),

              ProfileMenuTile(
                icon: Icons.location_on_outlined,
                title: 'My Addresses',
                subtitle: 'Manage delivery addresses',
                onTap: () => _showComingSoon('My Addresses'),
              ),

              const SizedBox(height: 24),

              const ProfileSectionTitle(title: 'PREFERENCES'),

              ProfileMenuTile(
                icon: Icons.notifications_none,
                title: 'Notifications',
                subtitle: 'Manage your notifications',
                onTap: () => _showComingSoon('Notifications'),
              ),

              ProfileMenuTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help with your shopping',
                onTap: () => _showComingSoon('Help & Support'),
              ),

              ProfileMenuTile(
                icon: Icons.info_outline,
                title: 'About MODE',
                subtitle: 'Learn more about our store',
                onTap: () => _showComingSoon('About MODE'),
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
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
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