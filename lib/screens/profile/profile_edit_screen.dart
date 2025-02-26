import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_event_management/widgets/theme.dart';

class ProfileEditScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  ProfileEditScreen({required this.userId, required this.userData});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _deptController;
  late TextEditingController _phoneController;
  late TextEditingController _skillController;
  late TextEditingController _interestController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _deptController = TextEditingController(text: widget.userData['dept']);
    _phoneController = TextEditingController(text: widget.userData['phone']);
    _skillController = TextEditingController(text: widget.userData['skill']);
    _interestController =
        TextEditingController(text: widget.userData['interest']);
    _bioController = TextEditingController(text: widget.userData['bio']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _deptController.dispose();
    _phoneController.dispose();
    _skillController.dispose();
    _interestController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .set({
      'name': _nameController.text,
      'email': _emailController.text,
      'dept': _deptController.text,
      'phone': _phoneController.text,
      'skill': _skillController.text,
      'interest': _interestController.text,
      'bio': _bioController.text,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',
            style: AppTheme.lightTheme.appBarTheme.titleTextStyle),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_nameController, 'Name', Icons.person),
            SizedBox(height: 8),
            _buildTextField(_emailController, 'Email', Icons.email),
            SizedBox(height: 8),
            _buildTextField(_deptController, 'Department', Icons.school),
            SizedBox(height: 8),
            _buildTextField(_phoneController, 'Phone', Icons.phone),
            SizedBox(height: 8),
            _buildTextField(_skillController, 'Skill', Icons.star),
            SizedBox(height: 8),
            _buildTextField(_interestController, 'Interest', Icons.interests),
            SizedBox(height: 8),
            _buildTextField(_bioController, 'Bio', Icons.info),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateProfile,
              style: AppTheme.lightTheme.elevatedButtonTheme.style,
              child: Text('Update', style: TextStyle(color: AppTheme.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppTheme.buttonColor),
        labelText: label,
        labelStyle: TextStyle(color: AppTheme.grey),
        filled: true,
        fillColor: AppTheme.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.buttonColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.grey.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
