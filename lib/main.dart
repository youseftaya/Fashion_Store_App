import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'view/screens/home_screen.dart';

void main() {
  runApp(const FashionStoreApp());
}

class FashionStoreApp extends StatelessWidget {
  const FashionStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MODE Fashion Store',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}