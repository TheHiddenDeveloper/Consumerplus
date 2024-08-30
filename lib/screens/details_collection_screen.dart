import 'package:consumerplus/screens/permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dashboard/dashboard_screen.dart';

class DetailsCollectionScreen extends StatefulWidget {
  const DetailsCollectionScreen({super.key});

  @override
  _DetailsCollectionScreenState createState() =>
      _DetailsCollectionScreenState();
}

void _checkPermissionsAndNavigate(BuildContext context) async {
  // Check if all necessary permissions are granted
  bool cameraGranted = await Permission.camera.isGranted;
  bool storageGranted = await Permission.storage.isGranted;
  bool locationGranted = await Permission.location.isGranted;

  if (cameraGranted && storageGranted && locationGranted) {
    // All permissions are granted, navigate to the Dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  } else {
    // Permissions are not granted, navigate to the PermissionsScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PermissionRequestScreen()),
    );
  }
}

class _DetailsCollectionScreenState extends State<DetailsCollectionScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  String _consumerType = 'Residential'; // Default value

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final emailKey = user.email!.replaceAll('.', ',');
      final profileDoc =
          await _firestore.collection(emailKey).doc('profile').get();

      if (profileDoc.exists) {
        final data = profileDoc.data()!;
        setState(() {
          _firstNameController.text = data['firstName'] ?? '';
          _lastNameController.text = data['lastName'] ?? '';
          _addressController.text = data['address'] ?? '';
          _cityController.text = data['city'] ?? '';
          _postalCodeController.text = data['postalCode'] ?? '';
          _consumerType = data['consumerType'] ?? 'Residential';
        });
      }
    }
  }

  void _saveUserProfile() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final emailKey = user.email!.replaceAll('.', ',');
      await _firestore.collection(emailKey).doc('profile').set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'postalCode': _postalCodeController.text,
        'consumerType': _consumerType,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      _checkPermissionsAndNavigate(context);
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Please enter your details below:',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _postalCodeController,
              decoration: InputDecoration(
                labelText: 'Postal Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Consumer Type'),
              trailing: DropdownButton<String>(
                value: _consumerType,
                onChanged: (String? newValue) {
                  setState(() {
                    _consumerType = newValue!;
                  });
                },
                items: <String>['Residential', 'Non-Residential']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Details'),
            ),
          ],
        ),
      ),
    );
  }
}
