import 'package:consumerplus/screens/auth/login_screen.dart';
import 'package:consumerplus/screens/onboarding_screen.dart';
import 'package:consumerplus/screens/permission_screen.dart';
import 'package:consumerplus/screens/splash_screen.dart';
import 'package:consumerplus/services/navigation_service.dart';
import 'package:consumerplus/services/service_provider.dart';
import 'package:consumerplus/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ConsumerPlusApp());
}

class ConsumerPlusApp extends StatelessWidget {
  const ConsumerPlusApp({super.key});

  Future<String> _determineInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isFirstTime) {
      return '/onboarding';
    } else {
      return '/login';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ServiceProvider(
      child: FutureBuilder<String>(
        future: _determineInitialRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: const SplashScreen(),
              theme: CustomTheme.lightTheme,
            );
          } else {
            return MaterialApp(
              theme: CustomTheme.lightTheme,
              darkTheme: CustomTheme.darkTheme,
              themeMode: ThemeMode.system,
              navigatorKey: Provider.of<NavigationService>(context).navigatorKey,
              initialRoute: snapshot.data,
              routes: {
                '/onboarding': (context) => const OnboardingScreen(),
                '/login': (context) => const LoginScreen(),
                '/permission':(context) => const PermissionRequestScreen(),
                // Add other routes here (dashboard, etc.)
              },
            );
          }
        },
      ),
    );
  }
}
