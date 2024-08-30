import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/appliance.dart';
import '../auth/login_screen.dart';
import 'add_appliance_screen.dart';
import 'analysis_screen.dart';
import 'history_screen.dart';
import 'user_profile_screen.dart';
import '../../utils/fade_route.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      // Handle error, e.g., show a SnackBar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  Stream<List<Appliance>> getAppliancesStream() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final emailKey = user.email!.replaceAll('.', ',');
      return FirebaseFirestore.instance
          .collection(emailKey)
          .doc('appliances')
          .collection('items')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                final data = doc.data();
                return Appliance(
                  id: doc.id,
                  name: data['name'],
                  power: data['power'],
                  hoursPerDay: data['hoursPerDay'],
                  consumerType: data['consumerType'],
                  isExclusive: data['isExclusive'],
                );
              }).toList());
    } else {
      return Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                FadeRoute(page: const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  FadeRoute(page: const UserProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Appliance>>(
        stream: getAppliancesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final appliances = snapshot.data!;
            if (appliances.isEmpty) {
              return const Center(child: Text('No appliances found.'));
            }
            return ListView.builder(
              itemCount: appliances.length,
              itemBuilder: (context, index) {
                final appliance = appliances[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      appliance.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Power: ${appliance.power} W'),
                        Text('Usage: ${appliance.hoursPerDay} hours/day'),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'Remove') {
                          // Handle appliance removal
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Remove'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading appliances.'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            FadeRoute(page: const AddApplianceScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Appliance',
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Set this to the index of the DashboardScreen
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(context, FadeRoute(page: const DashboardScreen()));
              break;
            case 1:
              Navigator.push(context, FadeRoute(page: const AnalysisScreen()));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
        ],
      ),
    );
  }
}
