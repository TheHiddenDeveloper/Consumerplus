import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appliance.dart';

class DBService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String uid;

  DBService(this.uid);


  // Reference to the user's document
  DocumentReference get userDocRef {
    if (uid.isEmpty) {
      throw Exception('User not authenticated');
    }
    return _db.collection('users').doc(uid);
  }

  // Get the current user's email key
  String _getEmailKey() {
    final User? user = _auth.currentUser;
    if (user != null) {
      return user.email!.replaceAll('.', ',');
    } else {
      throw Exception('User not authenticated.');
    }
  }

  // Add a new appliance
  Future<void> addAppliance(Appliance appliance) async {
    try {
      final emailKey = _getEmailKey();
      DocumentReference applianceRef;

      if (appliance.id.isEmpty) {
        // Use auto-generated document ID
        applianceRef = _db.collection(emailKey).doc('appliances').collection('items').doc();
      } else {
        // Use provided ID
        applianceRef = _db.collection(emailKey).doc('appliances').collection('items').doc(appliance.id);
      }

      await applianceRef.set({
        'name': appliance.name,
        'power': appliance.power,
        'hoursPerDay': appliance.hoursPerDay,
        'consumerType': appliance.consumerType,
        'isExclusive': appliance.isExclusive ?? false,
      });
      print('Appliance added successfully.');
    } catch (e) {
      print('Error adding appliance: $e');
    }
  }

  // Remove an appliance
  Future<void> removeAppliance(String applianceId) async {
    try {
      final emailKey = _getEmailKey();
      await _db
          .collection(emailKey)
          .doc('appliances')
          .collection('items')
          .doc(applianceId)
          .delete();
      print('Appliance removed successfully.');
    } catch (e) {
      print('Error removing appliance: $e');
    }
  }

  // Stream to retrieve appliances from Firestore
  Stream<List<Appliance>> get appliances {
    final emailKey = _getEmailKey();
    return _db
        .collection(emailKey)
        .doc('appliances')
        .collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return Appliance(
        id: doc.id,
        name: data['name'] ?? 'Unknown',
        power: data['power'] ?? 0,
        hoursPerDay: data['hoursPerDay'] ?? 0,
        consumerType: data['consumerType'] ?? 'Residential',
        isExclusive: data['isExclusive'] ?? false,
      );
    }).toList());
  }

  // Stream to retrieve user profile from Firestore
  Stream<DocumentSnapshot> get userProfile {
    final emailKey = _getEmailKey();
    return _db.collection(emailKey).doc('profile').snapshots();
  }

  // Get a reference to the user's profile document
  Future<DocumentSnapshot> getUserProfileDoc(String email) async {
    try {
      final emailKey = email.replaceAll('.', ',');
      return await _db.collection(emailKey).doc('profile').get();
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  // Update the user's profile
  Future<void> updateUserProfile(
      String firstName,
      String lastName,
      String address,
      String city,
      String postalCode,
      String consumerType,
      ) async {
    try {
      final emailKey = _getEmailKey();
      await _db.collection(emailKey).doc('profile').set(
          {
            'firstName': firstName,
            'lastName': lastName,
            'address': address,
            'city': city,
            'postalCode': postalCode,
            'consumerType': consumerType,
          },
          SetOptions(
              merge: true)); // Merge to avoid overwriting the entire document
      print('User profile updated successfully.');
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }
}
