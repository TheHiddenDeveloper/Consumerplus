import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appliance.dart';
import '../services/db_service.dart';
import '../services/theme_service.dart';

class ServiceProvider extends StatelessWidget {
  final Widget child;

  const ServiceProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        StreamProvider<User?>(
          create: (_) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        // Provide DBService based on User
        Provider<DBService>(
          create: (context) {
            final user = Provider.of<User?>(context, listen: false);
            if (user != null) {
              return DBService(user.uid);
            } else {
              throw Exception('User not authenticated');
            }
          },
        ),
        StreamProvider<List<Appliance>>(
          create: (context) {
            final dbService = Provider.of<DBService>(context, listen: false);
            return dbService.appliances;
          },
          initialData: const [],
        ),
      ],
      child: child,
    );
  }
}
