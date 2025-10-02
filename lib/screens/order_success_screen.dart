import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:provider/provider.dart'; 
import '../providers/tab_provider.dart'; 
import '../main.dart'; 

class OrderSuccessScreen extends StatelessWidget {
  final OrderModel order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 24),
              const Text(
                'Pesanan Berhasil!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Pesanan Anda dengan ID #${order.orderId} sedang diproses.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 48),

              // Tombol Lihat Riwayat Pesanan
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // 1. Ubah tab navigasi bawah (BottomNavigationBar) ke tab Orders/Riwayat Pesanan (Index 2)
                    // BottomNavigationBar Index: [0: Home, 1: Pickup, 2: Orders, 3: Search, 4: Profile]
                    Provider.of<TabProvider>(context, listen: false).changeTab(2);
                    
                    
                    // 2. Navigasi kembali ke MainPage (yang merupakan akar/root) dan hapus semua rute di atasnya
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const MainPage()),
                      (route) => false, // Hapus semua rute lama
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Lihat Riwayat Pesanan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}