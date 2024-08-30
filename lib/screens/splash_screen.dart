import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_preferences.dart';
import 'dashboard/dashboard_screen.dart';
import 'onboarding_screen.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleAppStartup();
  }

  Future<void> _handleAppStartup() async {
    // Show the splash screen for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFreshInstall = prefs.getBool('isFreshInstall') ?? true;
    User? user = FirebaseAuth.instance.currentUser;
    bool isOnboardingComplete = await UserPreferences.getOnboardingComplete();

    if (isFreshInstall) {
      // Mark the app as no longer a fresh install
      prefs.setBool('isFreshInstall', false);
      // Navigate to Onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else if (user != null) {
      // User is authenticated
      if (isOnboardingComplete) {
        // Navigate to Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        // Existing user but onboarding incomplete, navigate to Onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } else {
      // No user authenticated, navigate to Login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

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
          // Bottom center circular progress indicator
          const Positioned(
            bottom: 50, // Position above the bottom edge
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
