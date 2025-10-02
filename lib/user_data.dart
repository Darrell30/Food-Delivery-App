import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/search_model.dart';

class UserData extends ChangeNotifier {
  String _userName = "Enter Your Name";
  String _userAddress = "Set my address";
  String _profileImagePath = "";
  List<OrderModel> _orders = [];
  double _balance = 134000.0;

  String get userName => _userName;
  String get userAddress => _userAddress;
  String get profileImagePath => _profileImagePath;
  List<OrderModel> get orders => _orders;
  double get balance => _balance;

  String get formattedBalance {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(_balance);
  }

  UserData();

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? 'Enter Your Name';
    _userAddress = prefs.getString('userAddress') ?? 'Set my address';
    _profileImagePath = prefs.getString('profileImagePath') ?? '';

    final String? ordersJson = prefs.getString('userOrders');
    if (ordersJson != null && ordersJson.isNotEmpty) {
      final List<dynamic> ordersList = json.decode(ordersJson);
      _orders = ordersList.map((json) => OrderModel.fromJson(json)).toList();
    }
    
    notifyListeners();
  }

  Future<void> loadFixedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    _userName = "Darrell";
    await prefs.setString('userName', _userName);

    String? currentAddress = prefs.getString('userAddress');
    if (currentAddress != null && currentAddress.isNotEmpty) {
      _userAddress = currentAddress;
    } else {
      _userAddress = "Set Adddress";
    }
    await prefs.setString('userAddress', _userAddress);

    String? currentProfilePath = prefs.getString('profileImagePath');
    if (currentProfilePath == null || currentProfilePath.isEmpty) {
      _profileImagePath = "assets/icons/pfp.jpg";
    } else {
      _profileImagePath = currentProfilePath;
    }
    await prefs.setString('profileImagePath', _profileImagePath);

    _orders = [];
    await prefs.setString('userOrders', json.encode([]));

    notifyListeners();
  }

  // ✅ --- THIS FUNCTION IS NOW CORRECT --- ✅
  Future<void> logout() async {
    // 1. Reset the app's state in memory.
    _userName = "Enter Your Name";
    _userAddress = "Set my address";
    _profileImagePath = "";
    _orders = [];

    // 2. Only clear the session flag and transactional data.
    // We NO LONGER remove userName, userAddress, or profileImagePath.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userOrders'); 
    
    // 3. Do not call notifyListeners() to prevent freezes.
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
    await prefs.setString('profileImagePath', newPath);
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