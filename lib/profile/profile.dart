import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../user_data.dart';
import '../providers/order_provider.dart';
import '../providers/tab_provider.dart';
import 'map_screen.dart';
import '../profile/screens/balance_screen.dart';
import '../screens/order_history_screen.dart';
import '../profile/screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _nameController;
  bool _isEditing = false;
  static const Color accentColor = Color.fromARGB(255, 0, 119, 255);
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final userData = Provider.of<UserData>(context, listen: false);
    _nameController = TextEditingController(text: userData.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    Provider.of<UserData>(context, listen: false).logout();
    Provider.of<OrderProvider>(context, listen: false).clearOrders();
    Provider.of<TabProvider>(context, listen: false).resetTab();

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<bool?> _showLogoutConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null && mounted) {
      Provider.of<UserData>(context, listen: false)
          .updateProfileImagePath(image.path);
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleEdit() async {
    final userData = Provider.of<UserData>(context, listen: false);
    
    if (_isEditing) {
      await userData.updateUserName(_nameController.text);
      if (mounted) FocusScope.of(context).unfocus();
    } else {
      _nameController.text = userData.userName;
    }
    
    if (mounted) {
      setState(() {
        _isEditing = !_isEditing;
      });
    }
  }

  void _navigateToMapScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );
    if (result != null && result is String && mounted) {
      await Provider.of<UserData>(context, listen: false).updateUserAddress(result);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Hi, ${_nameController.text}!' : 'Hi, ${userData.userName}!',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 119, 255) .withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          const SizedBox(height: 20),
          _buildHeader(userData),
          const SizedBox(height: 20),
          const Divider(),
          _buildMenuListItem(
            icon: Icons.attach_money_outlined,
            title: "Balance",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BalanceScreen()),
              );
            },
          ),
          _buildMenuListItem(
            icon: Icons.location_on_outlined,
            title: "Address",
            subtitle: userData.userAddress,
            onTap: _navigateToMapScreen,
          ),
          _buildMenuListItem(
            icon: Icons.history_outlined,
            title: "Order History",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
              );
            },
          ),
          _buildMenuListItem(
            icon: Icons.security_outlined,
            title: "Account Security",
            onTap: () => _showSnackBar("You clicked Account Security"),
          ),
          const Divider(),
          _buildMenuListItem(
            icon: Icons.help_outline,
            title: "Help Center",
            onTap: () => _showSnackBar("You clicked Help Center"),
          ),
          _buildMenuListItem(
            icon: Icons.info_outline,
            title: "About",
            onTap: () => _showSnackBar("You clicked About"),
          ),
          const SizedBox(height: 30),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildHeader(UserData userData) {
    ImageProvider? backgroundImage;
    if (userData.profileImagePath.isNotEmpty) {
      if (userData.profileImagePath.startsWith('assets/')) {
        backgroundImage = AssetImage(userData.profileImagePath);
      } else {
        final file = File(userData.profileImagePath);
        if (file.existsSync()) {
          backgroundImage = FileImage(file);
        }
      }
    }

    return Row(
      children: [
        GestureDetector(
          onTap: _showImageSourceActionSheet,
          child: CircleAvatar(
            radius: 35,
            backgroundColor: const Color(0xFFF3F3F3),
            backgroundImage: backgroundImage,
            child: backgroundImage == null
                ? const Icon(Icons.person, size: 40, color: Colors.black54)
                : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isEditing
                  ? TextField(
                      controller: _nameController,
                      autofocus: true,
                      onChanged: (value) => setState(() {}),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none),
                    )
                  : Text(userData.userName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("admin@gmail.com",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ),
        TextButton(
          onPressed: _toggleEdit,
          child: Text(_isEditing ? "Save" : "Edit",
              style: const TextStyle(
                  color: accentColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildMenuListItem(
      {required IconData icon,
      required String title,
      String? subtitle,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return TextButton(
      onPressed: () async {
        final bool? shouldLogout = await _showLogoutConfirmationDialog();
        if (shouldLogout ?? false) {
          await _logout();
        }
      },
      child: const Text("Log Out",
          style: TextStyle(
              color: accentColor, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}