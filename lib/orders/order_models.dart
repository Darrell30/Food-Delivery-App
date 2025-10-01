import 'package:flutter/material.dart';

enum OrderStatus { all, pending, onDelivery, completed }

class Order {
  final String id;
  final OrderStatus status;
  final List<String> items;
  final double totalPrice;
  final int creationTimeMillis;

  Order({
    required this.id,
    required this.status,
    required this.items,
    required this.totalPrice,
    required this.creationTimeMillis,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      status: OrderStatus.values.firstWhere((e) => e.toString() == 'OrderStatus.${json['status']}'),
      items: (json['items'] as List).map((i) => i.toString()).toList(),
      totalPrice: json['totalPrice'] as double,
      creationTimeMillis: json['creationTimeMillis'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.name,
      'items': items,
      'totalPrice': totalPrice,
      'creationTimeMillis': creationTimeMillis,
    };
  }
}

// Data awal untuk pengujian
final List<Order> initialOrdersList = [
  Order(
    id: 'ORD001',
    status: OrderStatus.completed,
    items: ['Pizza', 'Cola'],
    totalPrice: 150000,
    creationTimeMillis: DateTime.now().millisecondsSinceEpoch - 600000,
  ),
  Order(
    id: 'ORD002',
    status: OrderStatus.onDelivery,
    items: ['Burger'],
    totalPrice: 75000,
    creationTimeMillis: DateTime.now().millisecondsSinceEpoch - 60000,
  ),
];