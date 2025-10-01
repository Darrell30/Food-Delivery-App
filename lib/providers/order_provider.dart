import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart'; // <-- 1. IMPORT YANG BENAR
import 'package:food_delivery_app/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

//                           ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 2. TAMBAHKAN INI
class OrderProvider with ChangeNotifier {
  static const String _ordersKey = 'my_order_history';
  List<OrderModel> _orderHistory = [];
  bool _isLoading = true;

  int _orderProcessingTime = 0;
  Timer? _processingTimer;
  String? _currentlyProcessingOrderId;

  List<OrderModel> get orderHistory => _orderHistory;
  bool get isLoading => _isLoading;
  bool get isProcessing => _orderProcessingTime > 0;
  int get secondsRemaining => _orderProcessingTime;
  String? get currentlyProcessingOrderId => _currentlyProcessingOrderId;

  OrderProvider() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? ordersJsonString = prefs.getString(_ordersKey);
    if (ordersJsonString != null && ordersJsonString.isNotEmpty) {
      try {
        final List<dynamic> ordersJson = jsonDecode(ordersJsonString);
        _orderHistory = ordersJson.map((json) => OrderModel.fromJson(json)).toList();
      } catch (e) {
        _orderHistory = [];
      }
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

  Future<void> addOrder(OrderModel newOrder) async {
    _orderHistory.insert(0, newOrder);
    notifyListeners();
    await _saveOrders();
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    // 3. PERBAIKI BAGIAN INI DARI 'order.id' MENJADI 'order.orderId'
    final orderIndex = _orderHistory.indexWhere((order) => order.orderId == orderId);
    if (orderIndex != -1) {
      final oldOrder = _orderHistory[orderIndex];
      _orderHistory[orderIndex] = OrderModel(
        orderId: oldOrder.orderId,
        restaurantName: oldOrder.restaurantName,
        items: oldOrder.items,
        totalPrice: oldOrder.totalPrice,
        orderDate: oldOrder.orderDate,
        status: newStatus,
      );
      notifyListeners();
      await _saveOrders();
    }
  }
  Future<void> cancelOrder(String orderId) async {
    // Stop timer if this order is currently being processed (for pickup orders)
    if (_currentlyProcessingOrderId == orderId) {
      _processingTimer?.cancel();
      _processingTimer = null;
      _orderProcessingTime = 0;
      _currentlyProcessingOrderId = null;
    }

    await _updateOrderStatus(orderId, 'Dibatalkan');
  }

  void startOrderProcessing(String orderId) {
    if (_processingTimer != null && _processingTimer!.isActive) return;
    
    _currentlyProcessingOrderId = orderId;
    _orderProcessingTime = 15;
    _updateOrderStatus(orderId, 'Diproses (Memasak)');

    _processingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_orderProcessingTime > 0) {
        _orderProcessingTime--;
        notifyListeners();
      } else {
        timer.cancel();
        _processingTimer = null;
        _finishProcessing(orderId);
      }
    });
  }

  void _finishProcessing(String orderId) {
    _updateOrderStatus(orderId, 'Siap Diambil');
    _currentlyProcessingOrderId = null;
    notifyListeners();
  }
  
  Future<void> clearOrders() async {
    _orderHistory.clear();
    notifyListeners();
    await _saveOrders();
  }

  @override
  void dispose() {
    _processingTimer?.cancel();
    super.dispose();
  }
}