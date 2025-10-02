import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../orders/order_models.dart'; 
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/models/menu_item.dart';
import '../providers/order_provider.dart';
import '../providers/tab_provider.dart';

class OrderScreen extends StatefulWidget {
  final String placeName;
  final Order? initialOrder;

  const OrderScreen({
    super.key,
    required this.placeName,
    this.initialOrder,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  Order? _currentOrder; 
  late double _pendingPrice;

  @override
  void initState() {
    super.initState();
    _pendingPrice = _generateRandomPrice();
    
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    if (orderProvider.isProcessing && orderProvider.currentlyProcessingOrderId != null) {
      _currentOrder = Order(
        id: orderProvider.currentlyProcessingOrderId!,
        status: OrderStatus.pending, 
        items: [], 
        totalPrice: 0.0, 
        creationTimeMillis: 0,
      );
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

    Provider.of<OrderProvider>(context, listen: false).addOrder(newOrderModel);

    Provider.of<OrderProvider>(context, listen: false).startOrderProcessing(uniqueId);

    setState(() {
      _currentOrder = Order(
        id: uniqueId,
        status: OrderStatus.pending,
        items: ['Ayam Goreng'],
        totalPrice: _pendingPrice,
        creationTimeMillis: DateTime.now().millisecondsSinceEpoch,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    
    final bool isThisOrderProcessing = 
        _currentOrder != null && 
        orderProvider.isProcessing && 
        orderProvider.currentlyProcessingOrderId == _currentOrder!.id;
        
    final bool isTimerFinished = 
        _currentOrder != null && 
        !orderProvider.isProcessing && 
        orderProvider.currentlyProcessingOrderId == null;
        
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

                  setState(() {
                    _currentOrder = null;
                  });
                  
                  Navigator.pop(context);

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