import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/models/menu_item.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orderHistory = [
    OrderModel(
      orderId: 'FD12345',
      restaurantName: 'Burger Queen',
      totalPrice: 65000,
      orderDate: DateTime(2025, 9, 27, 19, 30),
      items: [
        OrderItem(
          menuItem: MenuItem(id: 'b1', name: 'Beef Burger', price: 45000, imageUrl: 'https://via.placeholder.com/150'),
          quantity: 1,
        ),
        OrderItem(
          menuItem: MenuItem(id: 'b2', name: 'Fries', price: 20000, imageUrl: 'https://via.placeholder.com/150'),
          quantity: 1,
        ),
      ],
      status: 'Selesai',
    ),
    OrderModel(
      orderId: 'FD12346',
      restaurantName: 'Pizza Palace',
      totalPrice: 100000,
      orderDate: DateTime(2025, 9, 25, 12, 15),
      status: 'Dibatalkan',
      items: [
        OrderItem(
          menuItem: MenuItem(id: 'p1', name: 'Pizza Margherita', price: 85000, imageUrl: 'https://via.placeholder.com/150'),
          quantity: 1,
        ),
        OrderItem(
          menuItem: MenuItem(id: 'p2', name: 'Cola', price: 15000, imageUrl: 'https://via.placeholder.com/150'),
          quantity: 1,
        ),
      ],
    ),
  ];

  int _orderProcessingTime = 0;
  Timer? _processingTimer;
  String? _currentlyProcessingOrderId;

  bool get isProcessing => _orderProcessingTime > 0;
  int get secondsRemaining => _orderProcessingTime;
  String? get currentlyProcessingOrderId => _currentlyProcessingOrderId;

  List<OrderModel> get orderHistory => _orderHistory;

  void addOrder(OrderModel newOrder) {
    _orderHistory.insert(0, newOrder);
    notifyListeners();
  }
  
  void _updateOrderStatus(String orderId, String newStatus) {
    try {
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
      }
    } catch (e) {
      debugPrint('Error updating order status: $e');
    }
  }

  void startOrderProcessing(String orderId) {
    if (_processingTimer != null) {
      _processingTimer!.cancel();
    }
    
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

  void clearOrders() {
    _orderHistory.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _processingTimer?.cancel();
    super.dispose();
  }
}