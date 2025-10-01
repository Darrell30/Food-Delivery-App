import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/providers/tab_provider.dart';
import 'package:food_delivery_app/providers/order_provider.dart';
import 'package:food_delivery_app/models/restaurant.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/models/menu_item.dart';

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

  void _processOrder() {
    final List<OrderItem> orderItems = [];
    double totalPrice = 0;
    _selectedItems.forEach((itemId, quantity) {
      final menuItem = widget.restaurant.menu.firstWhere((item) => item.id == itemId);
      orderItems.add(OrderItem(menuItem: menuItem, quantity: quantity));
      totalPrice += menuItem.price * quantity;
    });

    final newOrder = OrderModel(
      orderId: 'FD${DateTime.now().millisecondsSinceEpoch}',
      restaurantName: widget.restaurant.name,
      items: orderItems,
      totalPrice: totalPrice,
      orderDate: DateTime.now(),
      status: 'pending',
    );

    Provider.of<OrderProvider>(context, listen: false).addOrder(newOrder);
    Provider.of<TabProvider>(context, listen: false).changeTab(2); // Pindah ke tab Orders
    Navigator.of(context).popUntil((route) => route.isFirst); // Kembali ke Home/root
  }

  @override
  Widget build(BuildContext context) {
    final bool isOrderReady = _selectedItems.isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurant.name)),
      body: CustomScrollView( // Menggunakan CustomScrollView agar bisa ada header gambar
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0, // Tinggi gambar header restoran
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.restaurant.imageUrl, // <-- GAMBAR HEADER RESTORAN
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Center(child: Text('Gagal memuat gambar restoran: ${widget.restaurant.name}')),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = widget.restaurant.menu[index];
                final int count = _selectedItems[item.id] ?? 0;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        item.imageUrl, // <-- GAMBAR UNTUK SETIAP ITEM MENU
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.restaurant_menu, size: 40), // Fallback jika gambar error
                      ),
                    ),
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Rp ${item.price.toStringAsFixed(0)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: count > 0 ? Colors.red : Colors.grey),
                          onPressed: count > 0 ? () => _updateItemCount(item, -1) : null,
                        ),
                        Text(count.toString(), style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => _updateItemCount(item, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: widget.restaurant.menu.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: isOrderReady
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _processOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Pesan Sekarang'),
              ),
            )
          : null,
    );
  }
}