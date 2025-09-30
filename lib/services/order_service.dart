import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/models/menu_item.dart';

// Kelas ini akan kita gunakan untuk mengelola state pesanan di seluruh aplikasi
class OrderService {
  // 'static' berarti variabel ini hanya ada satu dan bisa diakses dari mana saja
  static final List<OrderModel> _orderHistory = [
    // Data dummy awal agar daftar tidak kosong saat pertama kali dibuka
    OrderModel(
      orderId: 'FD12345',
      restaurantName: 'Burger Queen',
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
    ),
  ];

  // Fungsi untuk mendapatkan semua data riwayat pesanan
  static List<OrderModel> getOrderHistory() {
    return _orderHistory;
  }

  // Fungsi untuk menambahkan pesanan baru ke dalam daftar riwayat
  static void addOrder(OrderModel order) {
    // Menambahkan pesanan baru di posisi paling atas (agar tampil sebagai yang terbaru)
    _orderHistory.insert(0, order);
  }
}