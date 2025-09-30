import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../orders/order_models.dart';

class UserData extends ChangeNotifier {
  String _userName = "Enter Your Name";
  String _userAddress = "Set my address";
  String _profileImagePath = "";
  List<Order> _orders = [];

  String get userName => _userName;
  String get userAddress => _userAddress;
  String get profileImagePath => _profileImagePath;
  List<Order> get orders => _orders;

  UserData() {
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? 'Enter Your Name';
    _userAddress = prefs.getString('userAddress') ?? 'Set my address';
    _profileImagePath = prefs.getString('profileImagePath') ?? '';

    final String? ordersJson = prefs.getString('userOrders');
    if (ordersJson != null) {
      final List<dynamic> ordersList = json.decode(ordersJson);
      _orders = ordersList.map((json) => Order.fromJson(json)).toList();
    }

    notifyListeners();
  }

  Future<void> addNewOrder(Order newOrder) async {
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