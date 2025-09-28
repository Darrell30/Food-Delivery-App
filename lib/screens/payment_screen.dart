import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod; // Untuk melacak metode yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Pembayaran
            Text(
              'Total yang Harus Dibayar',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${widget.totalAmount.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Pilihan Metode Pembayaran
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Opsi E-Wallet
            _buildPaymentOptionTile(
              title: 'GoPay',
              icon: Icons.account_balance_wallet,
              value: 'gopay',
            ),
            _buildPaymentOptionTile(
              title: 'OVO',
              icon: Icons.wallet,
              value: 'ovo',
            ),

            // Opsi Lain
            const SizedBox(height: 16),
            _buildPaymentOptionTile(
              title: 'Kartu Kredit / Debit',
              icon: Icons.credit_card,
              value: 'card',
            ),
            _buildPaymentOptionTile(
              title: 'Cash on Delivery (COD)',
              icon: Icons.money,
              value: 'cod',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          // Tombol hanya aktif jika metode pembayaran sudah dipilih
          onPressed: _selectedPaymentMethod == null
              ? null
              : () {
                  // TODO: Proses pembayaran & tampilkan halaman sukses
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'Pembayaran dengan ${_selectedPaymentMethod?.toUpperCase()} Berhasil!',
                      ),
                    ),
                  );
                  // Kembali ke halaman utama setelah beberapa detik
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            // Style untuk tombol yang tidak aktif (disabled)
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: const Text('Bayar Sekarang'),
        ),
      ),
    );
  }

  // Widget helper untuk membuat setiap baris pilihan pembayaran
  Widget _buildPaymentOptionTile({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: Radio<String>(
          value: value,
          groupValue: _selectedPaymentMethod,
          onChanged: (String? newValue) {
            setState(() {
              _selectedPaymentMethod = newValue;
            });
          },
        ),
        onTap: () {
          setState(() {
            _selectedPaymentMethod = value;
          });
        },
      ),
    );
  }
}