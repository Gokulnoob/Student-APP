import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class UserProfile {
  final String name;
  final String email;
  final String dept;
  final String phone;
  final String skill;
  final String interest;
  final String bio;

  UserProfile({
    required this.name,
    required this.email,
    required this.dept,
    required this.phone,
    required this.skill,
    required this.interest,
    required this.bio,
  });

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      name: doc['name'],
      email: doc['email'],
      dept: doc['dept'],
      phone: doc['phone'],
      skill: doc['skill'],
      interest: doc['interest'],
      bio: doc['bio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'dept': dept,
      'phone': phone,
      'skill': skill,
      'interest': interest,
      'bio': bio,
    };
  }
}

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile> getUserProfile(String regno) async {
    int retryCount = 0;
    const int maxRetries = 5;
    const Duration initialDelay = Duration(seconds: 1);

    while (retryCount < maxRetries) {
      try {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(regno).get();
        if (doc.exists) {
          ('Document data: ${doc.data()}');
          return UserProfile.fromDocument(doc);
        } else {
          ('No such document!');
          throw Exception('No such document!');
        }
      } catch (e) {
        if (e is FirebaseException && e.code == 'unavailable') {
          retryCount++;
          final delay = initialDelay * retryCount;
          ('Retrying in $delay...');
          await Future.delayed(delay);
        } else {
          ('Error fetching user profile: $e');
          throw Exception('Error fetching user profile: $e');
        }
      }
    }
    throw Exception('Max retries reached. Failed to fetch user profile.');
  }

  Future<void> updateUserProfile(String regno, UserProfile userProfile) async {
    try {
      await _firestore
          .collection('users')
          .doc(regno)
          .update(userProfile.toMap());
      ('User profile updated successfully');
    } catch (e) {
      ('Error updating user profile: $e');
      throw Exception('Error updating user profile: $e');
    }
  }
}
