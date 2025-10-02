import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// REMOVED: import '../orders/order_models.dart'; // This is the conflicting file
import 'package:food_delivery_app/models/search_model.dart';
import 'package:food_delivery_app/models/menu_item.dart';
import '../providers/order_provider.dart';
import '../providers/tab_provider.dart';

class OrderScreen extends StatefulWidget {
  final String placeName;
  // REMOVED: final Order? initialOrder;

  const OrderScreen({
    super.key,
    required this.placeName,
    // REMOVED: this.initialOrder,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  // Change type to use the correct model
  OrderModel? _currentOrder; 
  late double _pendingPrice;

  @override
  void initState() {
    super.initState();
    _pendingPrice = _generateRandomPrice();
    
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    // Attempt to find the currently processing order in the provider's history
    if (orderProvider.currentlyProcessingOrderId != null) {
      try {
        _currentOrder = orderProvider.orderHistory.firstWhere(
          (order) => order.orderId == orderProvider.currentlyProcessingOrderId,
        );
      } catch (_) {
        _currentOrder = null; // Order not found, start fresh
      }
    }
  }

  double _generateRandomPrice() {
    final random = Random();
    return (30000 + random.nextInt(70001)).toDouble();
  }

  String _getStatusMessage(int secondsRemaining) {
    if (secondsRemaining > 5) {
      return "Pesanan sedang dimasak";
    } else if (secondsRemaining >= 1) {
      return "Pesanan sedang dikemas";
    } else {
      return "Pesanan sudah siap diambil!";
    }
  }

  void _createAndProcessOrder() {
    final uniqueId = 'FD_P_${DateTime.now().millisecondsSinceEpoch}';

    final newOrderModel = OrderModel(
      orderId: uniqueId,
      restaurantName: widget.placeName,
      totalPrice: _pendingPrice,
      orderDate: DateTime.now(),
      items: [
        OrderItem(
          menuItem: MenuItem(id: 'm1', name: 'Ayam Goreng', price: _pendingPrice, imageUrl: 'https://via.placeholder.com/150'), 
          quantity: 1,
        ),
      ],
      status: 'Menunggu Konfirmasi', 
    );

    // 1. Add order
    Provider.of<OrderProvider>(context, listen: false).addOrder(newOrderModel);
    // 2. Start processing
    Provider.of<OrderProvider>(context, listen: false).startOrderProcessing(uniqueId);

    // 3. Update local state with the new order model
    setState(() {
      _currentOrder = newOrderModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    
    // Check if the current order (if it exists) is the one being processed
    final bool isThisOrderProcessing = 
        _currentOrder != null && 
        orderProvider.isProcessing && 
        orderProvider.currentlyProcessingOrderId == _currentOrder!.orderId;
        
    // Check if the timer is finished and the final status is set
    final bool isTimerFinished = 
        _currentOrder != null && 
        !orderProvider.isProcessing && 
        orderProvider.currentlyProcessingOrderId == null && 
        orderProvider.orderHistory.any((o) => 
            o.orderId == _currentOrder!.orderId && o.status == 'Siap Diambil'
        );
        
    // Order is pending if no order is tracked, OR if the tracked order is not being processed and not finished.
    final bool isOrderPending = _currentOrder == null || (_currentOrder != null && !isThisOrderProcessing && !isTimerFinished);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pesanan di ${widget.placeName}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            if (isOrderPending) ...[
              const Text(
                "Pesanan 'Ayam Goreng' siap dibuat.",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Harga: Rp ${_pendingPrice.toStringAsFixed(0)}",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createAndProcessOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Pesan', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],

            if (isThisOrderProcessing) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 30),
              Text(
                _getStatusMessage(orderProvider.secondsRemaining), 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Est. Waktu tersisa: ${orderProvider.secondsRemaining} detik",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Mohon menunggu sebentar...",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],

            if (isTimerFinished) ...[
              const Text(
                "Pesanan sudah siap, silakan pick up",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Pesanan sudah siap diambil!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  final tabProvider = Provider.of<TabProvider>(context, listen: false);

                  // Reset local state
                  setState(() {
                    _currentOrder = null;
                  });
                  
                  // Navigate back to the previous screen (e.g., PickUpScreen or main tab)
                  Navigator.pop(context);

                  // Navigate to the Orders page (tab index 2)
                  Future.microtask(() {
                    tabProvider.changeTab(2); 

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pesanan selesai, membuka Riwayat Pesanan.')),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(39, 0, 197, 1),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Kembali ke Riwayat Pesanan', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
    