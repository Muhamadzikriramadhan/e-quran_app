import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/helper/biometric_helper.dart';
import '../../../../core/theme/theme.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool showBiometric = false;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _initAuth();
    isBiometricAvailable();
  }

  Future<void> _initAuth() async {
    try {
      final bool hasBiometrics = await BiometricHelper().hasEnrolledBiometrics();
      if (!hasBiometrics) {
        // If biometrics are not enrolled or not supported, skip authentication and proceed to home.
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
        return;
      }
    } catch (e) {
      debugPrint("Error checking biometric enrollment: $e");
      // Fallback: if checking enrollment throws an error, bypass authentication to prevent blocking the user
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
      return;
    }

    while (!isAuthenticated) {
      try {
        isAuthenticated = await BiometricHelper().authenticate();
      } catch (e) {
        debugPrint("Authentication error: $e");
        // If a PlatformException is thrown (e.g. user canceled, locked out, or security credentials not set)
        // break the loop and show a fallback message or proceed depending on policy.
        // For security credentials not set, we bypass. For lockout/cancellation, we can let them retry.
        if (e is PlatformException && e.code == 'NotAvailable') {
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
          return;
        }
        
        // Show error notification and break out of loop to avoid freezing the app
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authentication error: ${e.toString()}")),
        );
        break;
      }

      if (!isAuthenticated) {
        if (!context.mounted) return;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Authentication Failed"),
              content: const Text("Please authenticate using your fingerprint to continue."),
              actions: [
                TextButton(
                  child: const Text("Retry"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    if (isAuthenticated) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    }
  }

  Future<void> isBiometricAvailable() async {
    showBiometric = await BiometricHelper().hasEnrolledBiometrics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/loading.json',
              width: 100,
              height: 100,
              fit: BoxFit.fill,
              repeat: true,
              reverse: true,
              animate: true,
            ),
            const SizedBox(height: 14),
            Text(
              "E-Quran App",
              style: whiteTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
