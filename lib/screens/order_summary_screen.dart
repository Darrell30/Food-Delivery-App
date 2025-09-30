import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/restaurant.dart';
import 'payment_screen.dart';

class OrderSummaryScreen extends StatelessWidget {
  final Restaurant restaurant;
  final Map<String, int> selectedItems;

  const OrderSummaryScreen({
    super.key,
    required this.restaurant,
    required this.selectedItems,
  });

  double _calculateSubtotal() {
    double subtotal = 0.0;
    selectedItems.forEach((itemId, count) {
      final item = restaurant.menu.firstWhere((menuItem) => menuItem.id == itemId);
      subtotal += item.price * count;
    });
    return subtotal;
  }

  @override
  Widget build(BuildContext context) {
    final double subtotal = _calculateSubtotal();
    const double deliveryFee = 15000;
    final double total = subtotal + deliveryFee;

    final List<MenuItem> orderedItems = selectedItems.keys.map((itemId) {
      return restaurant.menu.firstWhere((menuItem) => menuItem.id == itemId);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Pesanan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(restaurant.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Pesanan Anda:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderedItems.length,
            itemBuilder: (context, index) {
              final item = orderedItems[index];
              final count = selectedItems[item.id]!;
              return ListTile(
                leading: Text('$count x'),
                title: Text(item.name),
                trailing: Text('Rp ${(item.price * count).toStringAsFixed(0)}'),
              );
            },
          ),
          const Divider(),
          const SizedBox(height: 16),
          _buildCostRow('Subtotal', subtotal),
          _buildCostRow('Biaya Pengiriman', deliveryFee),
          const Divider(),
          _buildCostRow('Total', total, isTotal: true),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(
                  totalAmount: total,
                  restaurant: restaurant,      
                  selectedItems: selectedItems, 
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Lanjutkan ke Pembayaran'),
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: isTotal ? 18 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text('Rp ${amount.toStringAsFixed(0)}', style: TextStyle(fontSize: isTotal ? 18 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}