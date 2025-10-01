import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';

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
    if (ordersJson != null) {
      final List<dynamic> ordersList = json.decode(ordersJson);
      _orders = ordersList.map((json) => OrderModel.fromJson(json)).toList();
    }
    
    notifyListeners();
  }

  Future<void> loadFixedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    _userName = "Darrell";
    await prefs.setString('userName', _userName);

    _userAddress = "Jl. Tlk. Intan, Pejagalan, Kecamatan Penjaringan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14450";
    await prefs.setString('userAddress', _userAddress);

    String? currentProfilePath = prefs.getString('profileImagePath');
    if (currentProfilePath == null || currentProfilePath.isEmpty || currentProfilePath.startsWith('assets/')) {
      _profileImagePath = "assets/icons/pfp.jpg";
    } else {
      _profileImagePath = currentProfilePath;
    }
    await prefs.setString('profileImagePath', _profileImagePath);

    _orders = [];
    await prefs.setString('userOrders', json.encode([]));

    notifyListeners();
  }

  Future<void> logout() async {
    _userName = "Enter Your Name";
    _userAddress = "Set my address";
    _profileImagePath = "";
    _orders = [];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userName');
    await prefs.remove('userAddress');
    await prefs.remove('profileImagePath');
    await prefs.remove('userOrders');
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
