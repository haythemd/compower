import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  // Firestore collection reference for users
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  // Singleton instance
  static final UserService _instance = UserService._privateConstructor();

  // Factory constructor to return the singleton instance
  factory UserService() {
    return _instance;
  }

  // Private constructor for the singleton
  UserService._privateConstructor();

  // Get the current authenticated user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  // Create or Update user in Firestore
  Future<void> createOrUpdateUser({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    try {
      await _usersCollection.doc(uid).set({
        'uid': uid,
        'email': email,
        'displayName': displayName ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Merge true will update existing fields if present
    } catch (e) {
      throw Exception('Error creating/updating user: $e');
    }
  }

  // Get user by UID
  Future<DocumentSnapshot> getUserById(String uid) async {
    try {
      return await _usersCollection.doc(uid).get();
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  // Get all users (you can filter this as needed)
  Future<List<QueryDocumentSnapshot>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _usersCollection.get();
      return snapshot.docs;
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Delete a user from Firestore by UID
  Future<void> deleteUser(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  // Update user display name
  Future<void> updateDisplayName(String uid, String displayName) async {
    try {
      await _usersCollection.doc(uid).update({
        'displayName': displayName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error updating user display name: $e');
    }
  }
}
