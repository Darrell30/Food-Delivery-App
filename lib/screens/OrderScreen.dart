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
    _currentOrder = widget.initialOrder;
    _pendingPrice = _generateRandomPrice(); 
  }

  double _generateRandomPrice() {
    final random = Random();
    return (30000 + random.nextInt(70001)).toDouble(); 
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
      status: 'Siap Diambil', 
    );
    
    Provider.of<OrderProvider>(context, listen: false).addOrder(newOrderModel);

    final newOrder = Order(
      id: uniqueId, 
      status: OrderStatus.onDelivery, 
      items: ['Ayam Goreng'], 
      totalPrice: _pendingPrice,
      creationTimeMillis: DateTime.now().millisecondsSinceEpoch, 
    );

    setState(() {
      _currentOrder = newOrder;
    });
    
  }


  String _getStatus() {
    if (_currentOrder == null || _currentOrder!.status == OrderStatus.pending) {
       return "Pesanan Menunggu Konfirmasi (klik tombol 'Pesan')."; 
    }
    return "Pesanan sudah siap, silakan pick up";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final bool isOrderPending = _currentOrder == null || _currentOrder!.status == OrderStatus.pending;
    final bool isOrderReady = _currentOrder != null && _currentOrder!.status == OrderStatus.onDelivery;

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
            
            if (isOrderReady) ...[
              Text(
                _getStatus(), 
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],

            
            if (isOrderReady) ...[
              const Text(
                "Pesanan sudah siap diambil!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  final tabProvider = Provider.of<TabProvider>(context, listen: false);
                  
                  Navigator.pop(context); 
                  
                  Future.microtask(() {
                    tabProvider.changeTab(2);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pesanan selesai, membuka Riwayat Pesanan.')),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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