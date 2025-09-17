import 'package:flutter/material.dart';
import 'map_screen.dart'; // We will create this file next

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: "Your Name");
  bool _isEditing = false;
  String _currentAddress = "No address set";

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _navigateToMapScreen() async {
    // Navigate to the map screen and wait for a result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    // If an address was returned, update the state
    if (result != null && result is String) {
      setState(() {
        _currentAddress = result;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Address'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileSection(),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 20),
          _buildAddressSection(),
        ],
      ),
    );
  }

  // Widget for the user profile details
  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.teal,
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _nameController,
          enabled: _isEditing,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: _isEditing ? const UnderlineInputBorder() : InputBorder.none,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _toggleEdit,
          icon: Icon(_isEditing ? Icons.check : Icons.edit),
          label: Text(_isEditing ? 'Save' : 'Edit Name'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isEditing ? Colors.green : Colors.grey[700],
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  // Widget for the address management section
  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.teal, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _currentAddress,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Center(
          child: ElevatedButton(
            onPressed: _navigateToMapScreen,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text('Set Address on Map'),
          ),
        ),
      ],
    );
  }
}