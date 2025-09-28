import 'package.flutter/material.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:intl/intl.dart'; // Tambahkan 'intl' ke pubspec.yaml untuk format tanggal

class OrderHistoryCard extends StatelessWidget {
  final OrderModel order;

  const OrderHistoryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Menghitung jumlah total item
    final totalItems = order.items.fold(0, (sum, item) => sum + item.quantity);
    final formattedDate = DateFormat('d MMMM yyyy, HH:mm').format(order.orderDate);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.restaurantName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  order.status,
                  style: TextStyle(
                    color: order.status == 'Selesai' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(formattedDate),
            const SizedBox(height: 4),
            Text('$totalItems item • Rp ${order.totalPrice.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigasi ke halaman detail pesanan
                },
                child: const Text('Lihat Detail'),
              ),
            )
          ],
        ),
      ),
    );
  }
}