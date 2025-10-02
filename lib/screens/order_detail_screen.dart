import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/search_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart'; 
import '../providers/tab_provider.dart'; 
import '../main.dart'; 
import 'payment_detail_screen.dart'; 

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  static const double deliveryFee = 10000; 
  static const double adminFee = 1000;

  const OrderDetailScreen({super.key, required this.orderId});
  
  void _completeOrder(BuildContext context, String currentOrderId) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final tabProvider = Provider.of<TabProvider>(context, listen: false);

    orderProvider.updateOrderStatus(currentOrderId, 'Selesai');

    tabProvider.setOrdersInitialTab(3); 
    tabProvider.changeTab(2); 

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainPage()),
      (route) => false, 
    );
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {

        final currentOrder = orderProvider.orderHistory.firstWhere(
          (o) => o.orderId == orderId,
          orElse: () => OrderModel(
            orderId: orderId,
            restaurantName: 'Pesanan Tidak Ditemukan',
            items: [],
            totalPrice: deliveryFee + adminFee, 
            orderDate: DateTime.now(),
            status: 'Dibatalkan',
          ), 
        );
        
        final subtotal = currentOrder.totalPrice - deliveryFee - adminFee;
        
        final isCompleted = currentOrder.status == 'Selesai';
        final isPendingPayment = currentOrder.status == 'pending' || currentOrder.status == 'Menunggu Konfirmasi';
        final isOnDelivery = currentOrder.status == 'on_delivery'; 
        final isReadyToPickUp = currentOrder.status == 'Siap Diambil';

        Widget? bottomButton;
        
        if (isPendingPayment) {
          bottomButton = ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => PaymentDetailScreen(order: currentOrder),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Bayar Sekarang (Rp ${currentOrder.totalPrice.toStringAsFixed(0)})'),
          );
        } else if (isOnDelivery) {
          bottomButton = ElevatedButton(
            onPressed: () => _completeOrder(context, currentOrder.orderId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Konfirmasi Pengantaran (Selesai)'),
          );
        } else if (isReadyToPickUp) {
          bottomButton = ElevatedButton(
            onPressed: () => _completeOrder(context, currentOrder.orderId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Ambil Pesanan'),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Pesanan'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildStatusSection(currentOrder.status),
              const SizedBox(height: 16),
              
              if (isCompleted) 
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.asset(
                      'assets/gifs/Completed.gif', 
                      height: 150, 
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => 
                          const Text('GIF Completed tidak ditemukan', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ),

              if (isOnDelivery) 
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.asset(
                      'assets/gifs/On_Delivery.gif', 
                      height: 150, 
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => 
                          const Text('GIF On Delivery tidak ditemukan', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ),
              
              _buildDetailCard(context, currentOrder, subtotal),
              const SizedBox(height: 16),
              _buildItemList(currentOrder),
            ],
          ),
          bottomNavigationBar: bottomButton != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: bottomButton,
                )
              : null,
        );
      },
    );
  }

  
  Widget _buildStatusSection(String status) {
    Color backgroundColor;
    Color iconColor;
    IconData icon;

    switch (status) {
      case 'Selesai':
        backgroundColor = Colors.green.shade100;
        iconColor = Colors.green.shade800;
        icon = Icons.check_circle;
        break;
      case 'Siap Diambil':
        backgroundColor = Colors.blue.shade100;
        iconColor = Colors.blue.shade800;
        icon = Icons.watch_later;
        break;
      case 'Delivery': 
        backgroundColor = Colors.orange.shade100;
        iconColor = Colors.orange.shade800;
        icon = Icons.delivery_dining;
        break;
      case 'Dibatalkan':
        backgroundColor = Colors.red.shade100;
        iconColor = Colors.red.shade800;
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = Colors.yellow.shade100;
        iconColor = Colors.yellow.shade800;
        icon = Icons.access_time;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Text('Status: $status', style: TextStyle(fontWeight: FontWeight.bold, color: iconColor)),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, OrderModel currentOrder, double subtotal) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentOrder.restaurantName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(DateFormat('d MMMM yyyy, HH:mm').format(currentOrder.orderDate), style: TextStyle(color: Colors.grey[600])),
            const Divider(height: 24),

            _buildCostRow('Subtotal Harga Makanan', subtotal),
            _buildCostRow('Biaya Pengiriman', deliveryFee),
            _buildCostRow('Biaya Admin', adminFee),
            const Divider(),
            _buildCostRow('Total Pembayaran', currentOrder.totalPrice, isTotal: true),
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

  Widget _buildItemList(OrderModel currentOrder) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Item Dipesan:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ...currentOrder.items.map((item) => Padding(
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