// lib/screens/order_success_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tab_provider.dart';
import '../main.dart'; // Pastikan path ke MainPage Anda benar

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;

  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Berhasil'),
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Bagian yang diubah: Ganti Icon dengan Image.asset (GIF) ---
              Image.asset(
                'assets/gifs/Success_payment.gif', // Path ke GIF Anda
                width: 150, // Sesuaikan ukuran sesuai kebutuhan
                height: 150, // Sesuaikan ukuran sesuai kebutuhan
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.error, color: Colors.red, size: 80), // Fallback jika GIF gagal dimuat
              ),
              // --- Akhir Bagian yang diubah ---
              
              const SizedBox(height: 30),
              const Text(
                'Pesanan Berhasil!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                'Pesanan Anda dengan ID $orderId sudah berhasil dikonfirmasi dan sedang diproses.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Dapatkan instance TabProvider
                  final tabProvider = Provider.of<TabProvider>(context, listen: false);

                  // Set tab Orders (index 2) sebagai tab utama
                  tabProvider.changeTab(2); 

                  // Opsional: Set OrdersPage untuk langsung membuka tab "On Delivery" atau "All"
                  // Sesuaikan ini dengan logika Anda setelah pembayaran berhasil.
                  // Misalnya, jika pesanan langsung diproses, mungkin Anda ingin melihat tab 'On Delivery' (index 2 di OrdersPage)
                  tabProvider.setOrdersInitialTab(2); // Atau 1 untuk 'All' jika ingin melihat semua pesanan

                  // Navigasi ke halaman utama dan hapus semua rute sebelumnya
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor, // Gunakan warna tema utama Anda
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Lihat Riwayat Pesanan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}