import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:student_event_management/screens/chat/career_guidance_chatbot_screen.dart';
import 'package:student_event_management/screens/profile/profile_edit_screen.dart';
import 'package:student_event_management/widgets/theme.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  ProfileScreen({required this.userId});

  Future<DocumentSnapshot> _fetchUserProfile() {
    return FirebaseFirestore.instance.collection('users').doc(userId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Profile',
            style: AppTheme.lightTheme.appBarTheme.titleTextStyle),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: AppTheme.black),
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        actions: [
          Center(
            child: IconButton(
              icon: Lottie.asset(
                'assets/Animation - 1740408656672.json',
                width: 40,
                height: 40,
              ),
              onPressed: () {
                _fetchUserProfile().then((snapshot) {
                  if (snapshot.exists) {
                    var userData = snapshot.data() as Map<String, dynamic>;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CareerGuidanceChatbotScreen(
                          userData: userData,
                        ),
                      ),
                    );
                  } else {
                    // Handle the case where the user profile does not exist
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CareerGuidanceChatbotScreen(
                          userData: {}, // Pass an empty map if no data
                        ),
                      ),
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Profile not found. Please create your profile.',
                      style: AppTheme.lightTheme.textTheme.bodyLarge),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: AppTheme.lightTheme.elevatedButtonTheme.style,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(
                            userId: userId,
                            userData: {
                              'name': '',
                              'email': '',
                              'dept': '',
                              'phone': '',
                              'skill': '',
                              'interest': '',
                              'bio': '',
                            },
                          ),
                        ),
                      );
                    },
                    child: Text('Create Profile',
                        style: TextStyle(color: AppTheme.white)),
                  ),
                ],
              ),
            );
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: AppTheme.blue.withOpacity(0.2),
                          backgroundImage: userData['photoUrl'] != null
                              ? NetworkImage(userData['photoUrl'])
                              : null,
                          radius: 40,
                          child: userData['photoUrl'] == null
                              ? Text(
                                  userData['name']?.substring(0, 1) ?? '',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Name: ${userData['name']}',
                        style: AppTheme.lightTheme.textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Email: ${userData['email']}',
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Department: ${userData['dept']}',
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Phone: ${userData['phone']}',
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Skill: ${userData['skill']}',
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Interest: ${userData['interest']}',
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Bio: ${userData['bio']}',
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          style: AppTheme.lightTheme.elevatedButtonTheme.style,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileEditScreen(
                                  userId: userId,
                                  userData: userData,
                                ),
                              ),
                            );
                          },
                          child: Text('Edit Profile',
                              style: TextStyle(color: AppTheme.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
