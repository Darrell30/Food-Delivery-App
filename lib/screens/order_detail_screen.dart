//lib/screens/order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:intl/intl.dart';
import 'payment_detail_screen.dart'; // Import halaman pembayaran
import 'package:provider/provider.dart';
import '../providers/order_provider.dart'; 
import '../providers/tab_provider.dart'; 
import '../main.dart'; // Diperlukan untuk pushAndRemoveUntil

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;
  // Use a constant delivery fee of 10000 and admin fee of 1000 as defined in the original file
  static const double deliveryFee = 10000; 
  static const double adminFee = 1000;

  const OrderDetailScreen({super.key, required this.order});
  
  // Fungsi baru untuk menyelesaikan pesanan
  void _completeOrder(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final tabProvider = Provider.of<TabProvider>(context, listen: false);

    // 1. Update status pesanan ke 'Selesai' (Completed)
    orderProvider.updateOrderStatus(order.orderId, 'Selesai');

    // 2. Set tab OrdersPage internal ke Completed (Index 3)
    tabProvider.setOrdersInitialTab(3); 

    // 3. Pindah ke tab utama Orders (Index 2)
    tabProvider.changeTab(2); 

    // 4. Navigasi kembali ke MainPage (akar/root) dan hapus semua rute di atasnya
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainPage()),
      (route) => false, 
    );
  }

  @override
  Widget build(BuildContext context) {
    // Recalculate subtotal by removing the fees from the total price
    // Note: This relies on the total price having been correctly calculated when the order was created
    final subtotal = order.totalPrice - deliveryFee - adminFee;
    final isPendingPayment = order.status == 'pending' || order.status == 'Menunggu Konfirmasi';
    // Kondisi baru untuk tombol konfirmasi pengantaran
    final isOnDelivery = order.status == 'on_delivery'; 

    Widget? bottomButton;

    if (isPendingPayment) {
      bottomButton = ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => PaymentDetailScreen(order: order),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text('Bayar Sekarang (Rp ${order.totalPrice.toStringAsFixed(0)})'),
      );
    } else if (isOnDelivery) { // Tombol Konfirmasi Pengantaran untuk status On Delivery
      bottomButton = ElevatedButton(
        onPressed: () => _completeOrder(context), // Panggil fungsi baru
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Warna hijau untuk konfirmasi selesai
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Konfirmasi Pengantaran (Selesai)'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStatusSection(order.status),
          const SizedBox(height: 16),
          _buildDetailCard(context, subtotal),
          const SizedBox(height: 16),
          _buildItemList(),
        ],
      ),
      bottomNavigationBar: bottomButton != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: bottomButton,
            )
          : null,
    );
  }

  Widget _buildStatusSection(String status) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: status == 'Selesai' ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            status == 'Selesai' ? Icons.check_circle : Icons.access_time,
            color: status == 'Selesai' ? Colors.green.shade800 : Colors.orange.shade800,
          ),
          const SizedBox(width: 12),
          Text(
            'Status: ${order.status}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: status == 'Selesai' ? Colors.green.shade800 : Colors.orange.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, double subtotal) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.restaurantName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(DateFormat('d MMMM yyyy, HH:mm').format(order.orderDate), style: TextStyle(color: Colors.grey[600])),
            const Divider(height: 24),
            // Simulasi foto toko (menggunakan placeholder)
            

            _buildCostRow('Subtotal Harga Makanan', subtotal),
            _buildCostRow('Biaya Pengiriman', deliveryFee),
            _buildCostRow('Biaya Admin', adminFee),
            const Divider(),
            _buildCostRow('Total Pembayaran', order.totalPrice, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: isTotal ? 17 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text('Rp ${amount.toStringAsFixed(0)}', style: TextStyle(fontSize: isTotal ? 17 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildItemList() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Item Dipesan:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item.quantity}x ${item.menuItem.name}'),
                  Text('Rp ${(item.menuItem.price * item.quantity).toStringAsFixed(0)}'),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}