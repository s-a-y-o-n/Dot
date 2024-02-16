import 'package:dot/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) =>
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: LottieBuilder.network(
              "https://lottie.host/bab4e43e-9a56-4ecf-a0d2-75fed4a5ba7a/mYvNwtz9LC.json")),
    );
  }
}
