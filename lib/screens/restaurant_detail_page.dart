import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/restaurant.dart';
import 'order_summary_screen.dart'; // <-- TAMBAHKAN IMPORT INI

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final Map<String, int> _selectedItems = {};

  void _updateItemCount(MenuItem item, int change) {
    setState(() {
      int currentCount = _selectedItems[item.id] ?? 0;
      int newCount = currentCount + change;
      if (newCount > 0) {
        _selectedItems[item.id] = newCount;
      } else {
        _selectedItems.remove(item.id);
      }
    });
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    _selectedItems.forEach((itemId, count) {
      final item = widget.restaurant.menu.firstWhere((menuItem) => menuItem.id == itemId);
      total += item.price * count;
    });
    return total;
  }

  // --- BAGIAN YANG DIPERBARUI ---
  void _goToOrderPage() {
    // Navigasi ke halaman ringkasan dan kirim data yang diperlukan
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSummaryScreen(
          restaurant: widget.restaurant,
          selectedItems: _selectedItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... Sisa kode build Anda tetap sama seperti sebelumnya ...
    // (Saya persingkat agar tidak terlalu panjang, isinya sama persis)

    final bool isOrderReady = _selectedItems.isNotEmpty;
    final double totalPrice = _calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
      ),
      body: ListView.builder(
        itemCount: widget.restaurant.menu.length,
        itemBuilder: (context, index) {
          final item = widget.restaurant.menu[index];
          final int count = _selectedItems[item.id] ?? 0;
          return ListTile(
            leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(item.name),
            subtitle: Text('Rp ${item.price.toStringAsFixed(0)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: count > 0 ? () => _updateItemCount(item, -1) : null),
                Text(count.toString()),
                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => _updateItemCount(item, 1)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: isOrderReady
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _goToOrderPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Pesan Sekarang - Rp ${totalPrice.toStringAsFixed(0)}'),
              ),
            )
          : null,
    );
  }
}