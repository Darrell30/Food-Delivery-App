// screens/OrderScreen.dart

import 'dart:async';
import 'dart:math'; 
import 'package:flutter/material.dart';
import '../orders/order_models.dart'; 

class OrderScreen extends StatefulWidget {
  final String placeName;
  final Function(Order)? onOrderCreated; 
  final Function(Order)? onOrderCompleted; 
  final Order? initialOrder; 

  const OrderScreen({
    super.key, 
    required this.placeName, 
    this.onOrderCreated,
    this.initialOrder,
    this.onOrderCompleted,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  
  // Waktu countdown awal (dalam detik)
  int _countdown = 60; 
  Timer? _timer;
  Order? _currentOrder; 

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.initialOrder;
    
    // Logika utama: Jika order sudah berstatus ON_DELIVERY, segera mulai countdown
    if (_currentOrder != null && _currentOrder!.status == OrderStatus.onDelivery) {
      // Hitung sisa waktu agar countdown persisten
      final elapsed = (DateTime.now().millisecondsSinceEpoch - _currentOrder!.creationTimeMillis) ~/ 1000;
      _countdown = (_countdown - elapsed).clamp(0, 60); 
      _startCountdown();
    }
  }

  double _generateRandomPrice() {
    final random = Random();
    return (30000 + random.nextInt(70001)).toDouble();
  }

  void _createAndGoToPayment() {
    final newOrder = Order(
      id: 'TEMP', 
      status: OrderStatus.pending,
      items: ['Ayam Goreng'], 
      totalPrice: _generateRandomPrice(),
      creationTimeMillis: DateTime.now().millisecondsSinceEpoch, 
    );

    if (widget.onOrderCreated != null) {
      widget.onOrderCreated!(newOrder);
    }
    
    Navigator.pop(context);
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown == 0) {
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  String _getStatus() {
    if (_currentOrder == null || _currentOrder!.status == OrderStatus.pending) {
       return "Pesanan Menunggu Pembayaran.";
    }
    
    if (_countdown > 0) {
      if (_countdown >= 30) {
        return "Pesanan sedang dimasak";
      } else if (_countdown >= 1) {
        return "Pesanan sedang dikemas";
      }
    }
    return "Pesanan sudah siap, silakan pick up";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final bool isOrderPending = _currentOrder == null || _currentOrder!.status == OrderStatus.pending;
    final bool isCountdownRunning = _currentOrder != null && _currentOrder!.status == OrderStatus.onDelivery && _countdown > 0;
    final bool isOrderReady = _currentOrder != null && _currentOrder!.status == OrderStatus.onDelivery && _countdown == 0;

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
                "Harga: Rp ${_generateRandomPrice().toStringAsFixed(0)} (Harga acak sebelum dibuat)",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createAndGoToPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Bayar Pesanan', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
            
            if (isCountdownRunning) ...[
              Text(
                "Perkiran waktu menunggu: $_countdown detik",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                _getStatus(),
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ],
            
            if (isOrderReady) ...[
              const Text(
                "Pesanan sudah siap diambil!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 20),
              Text(
                _getStatus(),
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (widget.onOrderCompleted != null && _currentOrder != null) {
                    widget.onOrderCompleted!(_currentOrder!);
                  }
                  Navigator.pop(context); 
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