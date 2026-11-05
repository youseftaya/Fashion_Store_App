import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String? email;
  final bool isLoggedIn;
  final bool isLoading;
  final bool isPickingImage;
  final Widget profileImage;
  final VoidCallback onPhotoTap;
  final VoidCallback onAuthTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.isLoggedIn,
    required this.isLoading,
    required this.isPickingImage,
    required this.profileImage,
    required this.onPhotoTap,
    required this.onAuthTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 26,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onPhotoTap,
            child: Stack(
              children: [
                Container(
                  width: 112,
                  height: 112,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(child: profileImage),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 2,
                      ),
                    ),
                    child: isPickingImage
                        ? const Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt_outlined,
                            size: 17,
                            color: AppColors.white,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            isLoggedIn ? name : 'Welcome to Mode Yousef',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            isLoggedIn
                ? (email ?? '')
                : 'Sign in to manage your account',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            height: 46,
            child: ElevatedButton(
              onPressed: isLoading ? null : onAuthTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      isLoggedIn ? 'Log out' : 'Sign in',
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
    );
  }
}