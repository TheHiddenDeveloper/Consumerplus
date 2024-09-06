import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Center the logo image
          Center(
            child: Image.asset(
              'assets/images/logo_no_bg.png', // Ensure the path is correct
              width: 150, // Adjust the size as needed
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}