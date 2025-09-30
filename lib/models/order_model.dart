import 'package:food_delivery_app/models/menu_item.dart';

class OrderItem {
  final MenuItem menuItem;
  final int quantity;

  OrderItem({required this.menuItem, required this.quantity});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItem: MenuItem.fromJson(json['menuItem']),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem.toJson(),
      'quantity': quantity,
    };
  }
}

class OrderModel {
  final String orderId;
  final String restaurantName;
  final List<OrderItem> items;
  final double totalPrice;
  final DateTime orderDate;
  final String status;

  OrderModel({
    required this.orderId,
    required this.restaurantName,
    required this.items,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<OrderItem> parsedItems = itemsList.map((i) => OrderItem.fromJson(i)).toList();

    return OrderModel(
      orderId: json['orderId'] as String,
      restaurantName: json['restaurantName'] as String,
      items: parsedItems,
      totalPrice: json['totalPrice'] as double,
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'restaurantName': restaurantName,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }
}