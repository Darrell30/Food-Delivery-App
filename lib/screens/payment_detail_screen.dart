import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/providers/order_provider.dart';
import 'package:food_delivery_app/screens/order_success_screen.dart';
import 'package:food_delivery_app/providers/tab_provider.dart';

class PaymentDetailScreen extends StatefulWidget {
  final OrderModel order;

  const PaymentDetailScreen({super.key, required this.order});

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  String? _selectedPaymentMethod; 
  final List<Map<String, dynamic>> paymentOptions = [
    {'title': 'GoPay Coins', 'icon': Icons.monetization_on, 'value': 'gopay_coins', 'balance': 7151, 'desc': '1 GoPay Coins setara dengan Rp1. Kamu bisa gabungin GoPay Coins dengan metode pembayaran lain.'},
    {'title': 'GoPay', 'icon': Icons.account_balance_wallet, 'value': 'gopay', 'balance': 0, 'is_default': true},
    {'title': '** 0397', 'icon': Icons.credit_card, 'value': 'card_0397', 'balance': null},
  ];

  void _processPayment() {
    if (_selectedPaymentMethod == null) return;
    
    // Simulasi proses pembayaran
    Future.delayed(const Duration(seconds: 1), () {
      
      // 1. Update status pesanan ke 'on_delivery' (On Delivery)
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.updateOrderStatus(widget.order.orderId, 'on_delivery');
      
      // 2. Pindahkan ke tab On Delivery (index 2) pada OrdersPage
      // OrdersPage tabs: [0: Pending Payment, 1: All, 2: On Delivery, 3: Completed, 4: Cancelled]
      Provider.of<TabProvider>(context, listen: false).changeTab(2); // UBAH KE INDEX 2

      // 3. Pindah ke OrderSuccessScreen 
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => OrderSuccessScreen(order: widget.order),
        ),
        (route) => false, 
      );
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih metode pembayaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section GoPay Coins
            _buildPaymentOptionTile(paymentOptions[0]),
            const SizedBox(height: 24),
            
            // Section Metode Pembayaran Utama
            const Text('Metode pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Swipe kiri buat pilih metode utamamu', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            
            ...paymentOptions.sublist(1).map(_buildPaymentOptionTile),
            const SizedBox(height: 24),
            
            // Section Tambah Metode (Dummy)
            const Text('Tambah metode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            _buildAddMethodTile(title: 'GoPay Tabungan by Jago', desc: 'Aktivasi & dapetin bunga 2.5% sekaligus transaksi', icon: Icons.savings),
            _buildAddMethodTile(title: 'GoPay Later', desc: 'Dapatkan maks. diskon 50rb & limit s.d. 30jt. Aktifkan sekarang!', icon: Icons.schedule),
            _buildAddMethodTile(title: 'Kartu kredit atau debit', desc: 'Visa, Mastercard, AMEX, dan JCB', icon: Icons.credit_card),
            _buildAddMethodTile(title: 'LinkAja', desc: '', icon: Icons.link),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _selectedPaymentMethod == null ? null : _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: Text('Place delivery order - Rp ${widget.order.totalPrice.toStringAsFixed(0)}'),
        ),
      ),
    );
  }

  Widget _buildPaymentOptionTile(Map<String, dynamic> option) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(option['icon'] as IconData, color: Colors.blue),
        title: Row(
          children: [
            Text(option['title'] as String),
            if (option['is_default'] == true) 
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('Default', style: TextStyle(fontSize: 10, color: Colors.grey[700])),
              ),
          ],
        ),
        subtitle: (option['balance'] != null)
            ? Text('Sisa saldo: Rp${option['balance'].toStringAsFixed(0)}')
            : (option['desc'] != null)
                ? Text(option['desc'] as String, style: TextStyle(fontSize: 12, color: Colors.grey[600]))
                : null,
        trailing: (option['is_default'] == true)
            ? TextButton(onPressed: () {}, child: const Text('Top up'))
            : Radio<String>(
                value: option['value'] as String,
                groupValue: _selectedPaymentMethod,
                onChanged: (String? newValue) => setState(() => _selectedPaymentMethod = newValue),
              ),
        onTap: () => setState(() => _selectedPaymentMethod = option['value'] as String),
      ),
    );
  }

  Widget _buildAddMethodTile({required String title, required String desc, required IconData icon}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: desc.isNotEmpty ? Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey[600])) : null,
      trailing: const Icon(Icons.add_circle, color: Colors.green),
      onTap: () {},
    );
  }
}