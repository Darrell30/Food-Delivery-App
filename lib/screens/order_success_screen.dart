import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order_model.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderModel order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
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

              // --- TOMBOL LACAK PESANAN (MENUJU PICKUP) ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke root, lalu pindah ke tab Pickup (indeks 1)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    // Catatan: Ini mengasumsikan Anda punya state management untuk pindah tab.
                    // Jika tidak, cara ini akan kembali ke Home.
                    // Untuk sekarang, kita tampilkan notifikasi saja.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Membuka halaman Lacak Pesanan (Pickup)...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Lacak Pesanan'),
                ),
              ),
              const SizedBox(height: 12),

              // --- TOMBOL KEMBALI KE BERANDA (MENUJU ORDERS) ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Kembali ke root, lalu pindah ke tab Orders (indeks 2)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                     // Catatan: Sama seperti di atas, ini butuh state management.
                     // Untuk sekarang, kita tampilkan notifikasi saja.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Membuka halaman Riwayat Pesanan (Orders)...')),
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