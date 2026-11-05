import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_provider.dart';
import 'view/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => OrderProvider(),
        ),
      ],
      child: const FashionStoreApp(),
    ),
  );
}

class FashionStoreApp extends StatelessWidget {
  const FashionStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MODE Fashion Store',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}