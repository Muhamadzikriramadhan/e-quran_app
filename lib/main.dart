import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/theme/theme.dart';
import 'core/constants/constants.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/splash/presentation/pages/splash_screen_page.dart';
import 'features/surah/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables dari file .env
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Dotenv Load Warning: $e');
  }

  // 1. Inisialisasi Supabase terlebih dahulu
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Supabase Init Warning: $e. Pastikan URL dan Anon Key Supabase sudah dikonfigurasi dengan benar.');
  }

  // 2. Inisialisasi Firebase & Notification Service
  try {
    await Firebase.initializeApp();
    await NotificationService.instance.initNotification();
  } catch (e) {
    debugPrint('Firebase/FCM Init Warning: $e. Pastikan file google-services.json / GoogleService-Info.plist sudah dikonfigurasi.');
  }
  
  // Catch and ignore google_fonts network exceptions globally (e.g., when device is offline)
  PlatformDispatcher.instance.onError = (error, stack) {
    final errorStr = error.toString();
    if (errorStr.contains('google_fonts') || 
        errorStr.contains('fonts.gstatic.com') ||
        errorStr.contains('Poppins')) {
      debugPrint('Ignored google_fonts network error: $error');
      return true; // Mark as handled so it doesn't crash the application
    }
    return false; // Pass other errors to Flutter handler
  };

  runApp(
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc()..add(CheckAuthEvent()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryMaterialColor,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
        ),
        scaffoldBackgroundColor: lightBackgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      routes: {
        '/': (_) => const SplashScreenPage(),
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
