// lib/widgets/order_history_card.dart

import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:intl/intl.dart';

class OrderHistoryCard extends StatelessWidget {
  final OrderModel order;

  const OrderHistoryCard({super.key, required this.order});

  Color _getStatusBackgroundColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green.shade100;
      case 'Dibatalkan':
        return Colors.red.shade100;
      case 'pending':
      case 'Diproses':
      case 'Siap Diambil':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green.shade800;
      case 'Dibatalkan':
        return Colors.red.shade800;
      case 'pending':
      case 'Diproses':
      case 'Siap Diambil':
        return Colors.orange.shade800;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Expanded(
                  child: Text(
                    order.restaurantName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, 
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusBackgroundColor(order.status),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusTextColor(order.status),
                    ),
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
                  // Logic to navigate to order detail
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