// lib/widgets/order_history_card.dart yang diperbarui

import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/providers/order_provider.dart';
import 'package:food_delivery_app/screens/order_detail_screen.dart'; // Import OrderDetailScreen

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
      case 'Menunggu Konfirmasi':
      case 'on_delivery': // TAMBAHKAN on_delivery
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
      case 'Menunggu Konfirmasi':
      case 'on_delivery': // TAMBAHKAN on_delivery
        return Colors.orange.shade800;
      default:
        return Colors.black;
    }
  }

  // FUNGSI UNTUK MENAMPILKAN DIALOG KONFIRMASI PEMBATALAN
  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Cancellation'),
          content: Text('Are you sure you want to cancel the order from ${order.restaurantName}? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('No, Keep Order'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Yes, Cancel Order', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog

                // Panggil fungsi pembatalan
                Provider.of<OrderProvider>(context, listen: false).cancelOrder(order.orderId);

                // Tampilkan SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order successfully cancelled.')),
                );
              },
            ),
          ],
        );
      },
    );
  }
  // AKHIR FUNGSI BARU

  @override
  Widget build(BuildContext context) {
    final totalItems = order.items.fold(0, (sum, item) => sum + item.quantity);
    final formattedDate = DateFormat('d MMMM yyyy, HH:mm').format(order.orderDate);
    
    // UBAH KONDISI PEMBATALAN: Hanya boleh dibatalkan jika statusnya
    // 'pending' atau 'Menunggu Konfirmasi' (sebelum benar-benar diproses atau dikirim).
    final bool canBeCancelled = 
        order.status == 'pending' || 
        order.status == 'Menunggu Konfirmasi';
        
    // HAPUS status 'Diproses', 'Siap Diambil', dan 'on_delivery' dari daftar yang dapat dibatalkan.


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

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (canBeCancelled) // Tombol Batal hanya muncul jika dapat dibatalkan
                  TextButton(
                    onPressed: () => _showCancelConfirmationDialog(context),
                    child: Text(
                      'Cancel Order', // Diubah ke Bahasa Inggris
                      style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                    ),
                  ),
                
                TextButton(
                  onPressed: () {
                    // Navigate to Order Detail Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                  child: const Text('View Detail'), // Diubah ke Bahasa Inggris
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}//