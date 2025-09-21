import 'package:flutter/material.dart';
import 'package:food_delivery_app/profile/screens/payment_methods_screen.dart';
import 'map_screen.dart'; // Make sure this import is correct

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = "Slushy"; // Default name
  late final TextEditingController _nameController;
  bool _isEditing = false;
  String _currentAddress = "Set my address";

  // Gojek's signature green color
  static const uiColor = Color.fromARGB(255, 118, 0, 151);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _userName);
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        // When saving, update the state variable
        _userName = _nameController.text;
      }
      _isEditing = !_isEditing;
    });
  }

  void _navigateToMapScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Hi, ${_userName}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: uiColor,
        elevation: 1.0,
      ),
      body: ListView(
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildSectionHeader("Account"),
          _buildMenuListItem(
            icon: Icons.location_on_outlined,
            title: "My Address",
            subtitle: _currentAddress,
            onTap: _navigateToMapScreen,
          ),
          _buildMenuListItem(
            icon: Icons.payment_outlined,
            title: "Payment Methods",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
              );
            },
          ),
          _buildMenuListItem(
            icon: Icons.local_activity_outlined,
            title: "Vouchers",
            onTap: () { /* Navigate to Vouchers */ },
          ),
          const SizedBox(height: 10),
          _buildSectionHeader("General"),
           _buildMenuListItem(
            icon: Icons.settings_outlined,
            title: "Settings",
            onTap: () { /* Navigate to Settings */ },
          ),
          _buildMenuListItem(
            icon: Icons.help_outline,
            title: "Help Center",
            onTap: () { /* Navigate to Help Center */ },
          ),
          const Divider(),
          _buildMenuListItem(
            icon: Icons.logout,
            title: "Log Out",
            isLogout: true, // Special styling for logout
            onTap: () { /* Handle Log Out */ },
          ),
        ],
      ),
    );
  }

  // Header widget with profile picture and name/edit field
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: uiColor,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _isEditing
                ? TextField(
                    controller: _nameController,
                    autofocus: true,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    _userName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
          ),
          IconButton(
            icon: Icon(_isEditing ? Icons.check_circle : Icons.edit_outlined, color: uiColor),
            onPressed: _toggleEdit,
          ),
        ],
      ),
    );
  }

  // Reusable widget for creating a styled list tile menu item
  Widget _buildMenuListItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final titleColor = isLogout ? Colors.red : Colors.black87;
    final iconColor = isLogout ? Colors.red : Colors.grey[700];

    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis,) : null,
        trailing: isLogout ? null : const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // Reusable widget for section headers like "Account"
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}