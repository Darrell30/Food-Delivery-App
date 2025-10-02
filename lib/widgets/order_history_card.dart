import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/search_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/providers/order_provider.dart';
import 'package:food_delivery_app/screens/order_detail_screen.dart';

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
      case 'on_delivery': 
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
      case 'on_delivery': 
        return Colors.orange.shade800;
      default:
        return Colors.black;
    }
  }

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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes, Cancel Order', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();

                Provider.of<OrderProvider>(context, listen: false).cancelOrder(order.orderId);

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

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        
        final bool isProcessing = 
            orderProvider.isProcessing && 
            orderProvider.currentlyProcessingOrderId == order.orderId;
            
        final int secondsRemaining = orderProvider.secondsRemaining;

        final totalItems = order.items.fold(0, (sum, item) => sum + item.quantity);
        final formattedDate = DateFormat('d MMMM yyyy, HH:mm').format(order.orderDate);
        
        final bool canBeCancelled = 
            order.status == 'pending' || 
            order.status == 'Menunggu Konfirmasi';

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

                    if (!isProcessing)
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
                      
                    if (isProcessing)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Sisa Waktu: ${secondsRemaining}s',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
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
                
                if (isProcessing) 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Pesanan sedang dipersiapkan...',
                      style: TextStyle(color: Colors.blue.shade700, fontStyle: FontStyle.italic),
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (canBeCancelled && !isProcessing)
                      TextButton(
                        onPressed: () => _showCancelConfirmationDialog(context),
                        child: Text(
                          'Cancel Order', 
                          style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                        ),
                      ),
                    
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailScreen(orderId: order.orderId),
                          ),
                        );
                      },
                      child: const Text('View Detail'), 
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}//