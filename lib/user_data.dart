import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';

class UserData extends ChangeNotifier {
  String _userName = "Enter Your Name";
  String _userAddress = "Set my address";
  String _profileImagePath = ""; // Stores either asset path or file path
  List<OrderModel> _orders = [];

  String get userName => _userName;
  String get userAddress => _userAddress;
  String get profileImagePath => _profileImagePath;
  List<OrderModel> get orders => _orders;

  UserData();

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? 'Enter Your Name';
    _userAddress = prefs.getString('userAddress') ?? 'Set my address';
    _profileImagePath = prefs.getString('profileImagePath') ?? ''; // Load saved path
    
    final String? ordersJson = prefs.getString('userOrders');
    if (ordersJson != null) {
      final List<dynamic> ordersList = json.decode(ordersJson);
      _orders = ordersList.map((json) => OrderModel.fromJson(json)).toList();
    }
    
    notifyListeners();
  }

  // UPDATED: Only set default pfp if no custom one exists
  Future<void> loadFixedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    _userName = "Darrell Cahyadi";
    await prefs.setString('userName', _userName);

    _userAddress = "Jl. Tlk. Intan, Pejagalan, Kecamatan Penjaringan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14450";
    await prefs.setString('userAddress', _userAddress);

    // Get current profile image path from prefs
    String? currentProfilePath = prefs.getString('profileImagePath');

    // Only set the default asset path if no custom path is saved
    if (currentProfilePath == null || currentProfilePath.isEmpty || currentProfilePath.startsWith('assets/')) {
      _profileImagePath = "assets/icons/pfp.jpg";
      await prefs.setString('profileImagePath', _profileImagePath);
    } else {
      // If a custom image was saved, keep it
      _profileImagePath = currentProfilePath;
    }

    _orders = []; // Clear orders on fixed login
    await prefs.setString('userOrders', json.encode([]));

    notifyListeners();
  }

  Future<void> logout() async {
    // When logging out, we clear everything to default,
    // but we might want to keep the *last chosen PFP path* if the user
    // logs in again later, instead of always reverting to the default asset.
    // For now, we clear it for a clean logout state.
    _userName = "Enter Your Name";
    _userAddress = "Set my address";
    _profileImagePath = ""; // Clear on logout
    _orders = [];

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('userAddress');
    await prefs.remove('profileImagePath'); // Clear saved path on logout
    await prefs.remove('userOrders');

    notifyListeners();
  }

  Future<void> addNewOrder(OrderModel newOrder) async {
    _orders.insert(0, newOrder);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> ordersList =
        _orders.map((order) => order.toJson()).toList();
    await prefs.setString('userOrders', json.encode(ordersList));
  }
  
  Future<void> updateProfileImagePath(String newPath) async {
    _profileImagePath = newPath;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', newPath); // Save the new path
  }

  Future<void> updateUserAddress(String newAddress) async {
    _userAddress = newAddress;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userAddress', newAddress);
  }

  Future<void> updateUserName(String newName) async {
    _userName = newName;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newName);
  }
}