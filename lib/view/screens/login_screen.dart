import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../widgets/login_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_bottom_prompt.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _errorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
      case 'invalid-credential':
      case 'wrong-password':
        return 'Incorrect email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'operation-not-allowed':
        return 'Email and password sign-in is not enabled.';
      default:
        return e.message ?? 'Could not sign in. Please try again.';
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await context.read<AuthProvider>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      _showMessage('Welcome back! You are signed in.');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showMessage(_errorMessage(e));
    } catch (_) {
      if (!mounted) return;
      _showMessage('Something went wrong. Please try again.');
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showMessage('Enter your valid email address first.');
      return;
    }

    try {
      await context.read<AuthProvider>().resetPassword(email: email);

      if (!mounted) return;
      _showMessage('Password reset email sent. Check your inbox.');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showMessage(_errorMessage(e));
    } catch (_) {
      if (!mounted) return;
      _showMessage('Could not send reset email. Please try again.');
    }
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

  void _openRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          'SIGN IN',
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 15,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoginHeader(),
                const SizedBox(height: 42),

                AuthTextField(
                  label: 'Email Address',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: (value) {
                    final email = value?.trim() ?? '';

                    if (email.isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(email)) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                AuthTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSubmitted: () {
                    if (!auth.isLoading) _submitForm();
                  },
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: auth.isLoading ? null : _resetPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                AuthPrimaryButton(
                  isLoading: auth.isLoading,
                  onPressed: _submitForm,
                ),

                const SizedBox(height: 28),

                AuthBottomPrompt(
                  onPressed: auth.isLoading ? () {} : _openRegisterScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}