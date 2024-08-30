import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  Map<String, dynamic> _userProfileData = {};

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final emailKey = user.email!.replaceAll('.', ',');
      final doc = await _firestore.collection(emailKey).doc('profile').get();
      if (doc.exists) {
        setState(() {
          _userProfileData = doc.data()!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateUserProfile() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final emailKey = user.email!.replaceAll('.', ',');
      await _firestore.collection(emailKey).doc('profile').update({
        'firstName': _userProfileData['firstName'],
        'lastName': _userProfileData['lastName'],
        'address': _userProfileData['address'],
        'city': _userProfileData['city'],
        'postalCode': _userProfileData['postalCode'],
        'consumerType': _userProfileData['consumerType'],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileDetailTile(
                    title: 'First Name',
                    value: _userProfileData['firstName'] ?? 'N/A',
                    onTap: () {
                      // Implement functionality to edit first name
                    },
                  ),
                  _ProfileDetailTile(
                    title: 'Last Name',
                    value: _userProfileData['lastName'] ?? 'N/A',
                    onTap: () {
                      // Implement functionality to edit last name
                    },
                  ),
                  _ProfileDetailTile(
                    title: 'Address',
                    value: _userProfileData['address'] ?? 'N/A',
                    onTap: () {
                      // Implement functionality to edit address
                    },
                  ),
                  _ProfileDetailTile(
                    title: 'City',
                    value: _userProfileData['city'] ?? 'N/A',
                    onTap: () {
                      // Implement functionality to edit city
                    },
                  ),
                  _ProfileDetailTile(
                    title: 'Postal Code',
                    value: _userProfileData['postalCode'] ?? 'N/A',
                    onTap: () {
                      // Implement functionality to edit postal code
                    },
                  ),
                  _ProfileDetailTile(
                    title: 'Consumer Type',
                    value: _userProfileData['consumerType'] ?? 'N/A',
                    onTap: () {
                      // Implement functionality to edit consumer type
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateUserProfile,
                    child: const Text('Update Profile'),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ProfileDetailTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _ProfileDetailTile({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: onTap,
      ),
    );
  }
}
