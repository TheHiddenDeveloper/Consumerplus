import 'package:consumerplus/screens/dashboard/analysis_screen.dart';
import 'package:consumerplus/screens/dashboard/dashboard_screen.dart';
import 'package:consumerplus/screens/dashboard/history_screen.dart';
import 'package:consumerplus/screens/dashboard/user_profile_screen.dart';
import 'package:consumerplus/services/service_provider.dart';
import 'package:consumerplus/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ConsumerPlusApp());
}

class ConsumerPlusApp extends StatelessWidget {
  const ConsumerPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceProvider(
      child: MaterialApp(
        title: 'Electricity Consumption Estimator',
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
          '/analysis': (context) => const AnalysisScreen(),
          '/user_profile': (context) => const UserProfileScreen(),
          '/history': (context) => const HistoryScreen(),
        },
      ),
    );
  }
}
