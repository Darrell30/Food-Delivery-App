import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider with ChangeNotifier {
  static const String _ordersKey = 'my_order_history';
  List<OrderModel> _orderHistory = [];
  bool _isLoading = true;

  List<OrderModel> get orderHistory => _orderHistory;
  bool get isLoading => _isLoading;

  OrderProvider() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? ordersJsonString = prefs.getString(_ordersKey);
    if (ordersJsonString != null && ordersJsonString.isNotEmpty) {
      final List<dynamic> ordersJson = jsonDecode(ordersJsonString);
      _orderHistory = ordersJson.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      _orderHistory = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> ordersJson = _orderHistory.map((order) => order.toJson()).toList();
    await prefs.setString(_ordersKey, jsonEncode(ordersJson));
  }

  Future<void> addOrder(OrderModel order) async {
    _orderHistory.insert(0, order);
    notifyListeners();
    await _saveOrders();
  }
}