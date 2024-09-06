import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appliance.dart';
import '../services/db_service.dart';
import '../services/theme_service.dart';
import '../services/navigation_service.dart';

class ServiceProvider extends StatelessWidget {
  final Widget child;

  const ServiceProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>(
      create: (_) => FirebaseAuth.instance.authStateChanges(),
      initialData: null,
      child: Consumer<User?>(
        builder: (context, user, child) {
          // User is authenticated
          if (user != null) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => ThemeService()),
                Provider<DBService>(
                  create: (_) => DBService(user.uid),
                ),
                StreamProvider<List<Appliance>>(
                  create: (context) {
                    final dbService = Provider.of<DBService>(context, listen: false);
                    return dbService.appliances;
                  },
                  initialData: const [],
                ),
                Provider<NavigationService>(
                  create: (_) => NavigationService(),
                ),
              ],
              child: child!,
            );
          }
          // User is not authenticated
          else {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => ThemeService()),
                Provider<NavigationService>(
                  create: (_) => NavigationService(),
                ),
              ],
              child: child!,
            );
          }
        },
        child: child,
      ),
    );
  }
}
