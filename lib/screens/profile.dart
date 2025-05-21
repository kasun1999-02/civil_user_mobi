import 'package:flutter/material.dart';
import '../services/session_manager.dart'; // Import your session manager

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await UserPreferences.getUserData();

    if (userData != null) {
      _nameController.text = userData['name'] ?? '';
      _emailController.text = userData['email'] ?? '';
      _idNumberController.text = userData['nicNo'] ?? '';
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveUserData() async {
    final existingUser = await UserPreferences.getUserData();

    final updatedUser = {
      '_id': existingUser?['_id'] ?? '',
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'idNumber': _idNumberController.text.trim(),
      'password': existingUser?['password'] ?? '',
      'isAdmin': existingUser?['isAdmin'] ?? false,
      '__v': existingUser?['__v'] ?? 0,
      // Keep token if you have it stored elsewhere
      'token': existingUser?['token'] ?? '',
    };

    await UserPreferences.saveUserData(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully!")),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFebcec7),
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField("Full Name", _nameController, Icons.person),
            _buildTextField("Email", _emailController, Icons.email),
            _buildTextField("ID Number", _idNumberController, Icons.badge),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
