import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map_screen.dart';
import 'screens/payment_methods_screen.dart';
import '../screens/order_history_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = "Enter Your Name";
  String _currentAddress = "Set my address";

  late final TextEditingController _nameController;
  bool _isEditing = false;

  static const Color accentColor = Color.fromRGBO(39, 0, 197, 1);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _userName);
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'Enter Your Name';
      _currentAddress = prefs.getString('userAddress') ?? 'Set my address';
      _nameController.text = _userName;
    });
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        _userName = _nameController.text;
        FocusScope.of(context).unfocus();
        // Simpan nama pengguna yang baru
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
        // Simpan alamat yang baru
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Hi, $_userName!',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          const SizedBox(height: 20),
          _buildHeader(), // <-- BAGIAN INI YANG SEBELUMNYA HILANG
          const SizedBox(height: 20),
          const Divider(),
          _buildMenuListItem(
            icon: Icons.history_outlined,
            title: "Riwayat Pesanan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
              );
            },
          ),
          _buildMenuListItem(
            icon: Icons.location_on_outlined,
            title: "Addresses",
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

  // WIDGET HELPER YANG SEBELUMNYA JUGA HILANG
  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundColor: Color(0xFFF3F3F3),
          child: Icon(Icons.person, size: 40, color: Colors.black54),
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
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                    )
                  : Text(_userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("example@email.com", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ),
        TextButton(
          onPressed: _toggleEdit,
          child: Text(_isEditing ? "Save" : "Edit", style: const TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildMenuListItem({required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
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
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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
      onPressed: () => _showSnackBar("You clicked Log Out"),
      child: const Text("Log Out", style: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}