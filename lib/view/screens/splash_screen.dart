import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/app_colors.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  bool _showDestination = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;

      setState(() {
        _showDestination = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSplash() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'M',
                  style: TextStyle(
                    fontSize: 76,
                    fontWeight: FontWeight.w300,
                    color: AppColors.primary,
                    letterSpacing: -5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'MODE',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 8,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'FASHION STORE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 4,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 45),
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text(
                'Something went wrong. Please restart the app.',
              ),
            ),
          );
        }

        if (!_showDestination ||
            snapshot.connectionState == ConnectionState.waiting) {
          return _buildSplash();
        }

        if (snapshot.data != null) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}