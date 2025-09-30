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

  List<OrderModel> get orderHistory => _orderHistory;

  void addOrder(OrderModel newOrder) {
    _orderHistory.insert(0, newOrder);
    notifyListeners();
  }
}