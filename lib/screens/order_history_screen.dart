import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/widgets/order_history_card.dart';
import 'package:food_delivery_app/models/menu_item.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final List<OrderModel> _orderHistory = [
    OrderModel(
      orderId: 'FD12345',
      restaurantName: 'Burger Queen',
      totalPrice: 65000,
      orderDate: DateTime(2025, 9, 27, 19, 30),
      items: [
        OrderItem(
          menuItem: MenuItem(id: 'b1', name: 'Beef Burger', price: 45000, imageUrl: ''),
          quantity: 1,
        ),
        OrderItem(
          menuItem: MenuItem(id: 'b2', name: 'Fries', price: 20000, imageUrl: ''),
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
          menuItem: MenuItem(id: 'p1', name: 'Pizza Margherita', price: 85000, imageUrl: ''),
          quantity: 1,
        ),
        OrderItem(
          menuItem: MenuItem(id: 'p2', name: 'Cola', price: 15000, imageUrl: ''),
          quantity: 1,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: _orderHistory.isEmpty
          ? const Center(
              child: Text(
                'Anda belum pernah memesan.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _orderHistory.length,
              itemBuilder: (context, index) {
                final order = _orderHistory[index];
                return OrderHistoryCard(order: order);
              },
            ),
    );
  }
}