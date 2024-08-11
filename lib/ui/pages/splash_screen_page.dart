
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../shared/theme.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    super.initState();
    _initDelayed();
  }

  void _initDelayed() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    });
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
                  "E-Quran App", // Sample balance
                  style: whiteTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                )
              ],
            )
        )
    );
  }

}