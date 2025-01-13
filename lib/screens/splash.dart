import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      loaderColor: Colors.white,
      logo: Image.asset(
          'assets/images/logo.png'),
      title: Text(
        "Orçamento App",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
      backgroundColor: Colors.deepPurple,
      showLoader: true,
      loadingText: Text("Carregando..."),
      navigator: HomePage(),
      durationInSeconds: 5,
    );;
  }
}
