import 'package:food_delivery_app/models/search_model.dart';
import 'package:food_delivery_app/models/menu_item.dart';

class OrderService {

  static final List<OrderModel> _orderHistory = [
    OrderModel(
      orderId: 'FD12345',
      restaurantName: 'Burger King',
      totalPrice: 65000,
      orderDate: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
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
  ];

  static List<OrderModel> getOrderHistory() {
    return _orderHistory;
  }

  static void addOrder(OrderModel order) {
    _orderHistory.insert(0, order);
  }
}