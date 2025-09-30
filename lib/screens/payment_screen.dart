import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/models/restaurant.dart';
import 'package:food_delivery_app/services/order_service.dart';
import 'package:food_delivery_app/screens/order_success_screen.dart';
import 'dart:math';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final Restaurant restaurant;
  final Map<String, int> selectedItems;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.restaurant,
    required this.selectedItems,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod; 

  void _processPayment() {
    final List<OrderItem> orderedItems = [];
    widget.selectedItems.forEach((itemId, quantity) {
      final menuItem = widget.restaurant.menu.firstWhere((item) => item.id == itemId);
      orderedItems.add(OrderItem(menuItem: menuItem, quantity: quantity));
    });

    final newOrder = OrderModel(
      orderId: 'FD${Random().nextInt(99999)}',
      restaurantName: widget.restaurant.name,
      items: orderedItems,
      totalPrice: widget.totalAmount,
      orderDate: DateTime.now(),
      status: 'Diproses',
    );

    OrderService.addOrder(newOrder);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(order: newOrder),
      ),
      (route) => false, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total yang Harus Dibayar', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
            const SizedBox(height: 8),
            Text('Rp ${widget.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Pilih Metode Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _buildPaymentOptionTile(title: 'GoPay', icon: Icons.account_balance_wallet, value: 'gopay'),
            _buildPaymentOptionTile(title: 'OVO', icon: Icons.wallet, value: 'ovo'),
            _buildPaymentOptionTile(title: 'Kartu Kredit / Debit', icon: Icons.credit_card, value: 'card'),
            _buildPaymentOptionTile(title: 'Cash on Delivery (COD)', icon: Icons.money, value: 'cod'),
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
          child: const Text('Bayar Sekarang'),
        ),
      ),
    );
  }

  Widget _buildPaymentOptionTile({required String title, required IconData icon, required String value}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: Radio<String>(
          value: value,
          groupValue: _selectedPaymentMethod,
          onChanged: (String? newValue) => setState(() => _selectedPaymentMethod = newValue),
        ),
        onTap: () => setState(() => _selectedPaymentMethod = value),
      ),
    );
  }
}