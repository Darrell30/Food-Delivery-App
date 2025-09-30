import 'package:food_delivery_app/models/menu_item.dart';

class OrderItem {
  final MenuItem menuItem;
  final int quantity;

  OrderItem({
    required this.menuItem,
    required this.quantity,
  });
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
    this.status = "Selesai",
  });
}