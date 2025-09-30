import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/providers/tab_provider.dart';
import 'package:food_delivery_app/providers/order_provider.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/models/menu_item.dart';
import 'package:food_delivery_app/models/restaurant.dart';

// This is now your one and only restaurant detail/menu page
class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final Map<String, int> _selectedItems = {};

  // Getters to calculate cart state in real-time
  int get _totalItemCount {
    if (_selectedItems.isEmpty) return 0;
    return _selectedItems.values.reduce((a, b) => a + b);
  }

  double get _totalPrice {
    double total = 0;
    _selectedItems.forEach((itemId, quantity) {
      final menuItem = widget.restaurant.menu.firstWhere((item) => item.id == itemId);
      total += menuItem.price * quantity;
    });
    return total;
  }

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
    _selectedItems.forEach((itemId, quantity) {
      final menuItem = widget.restaurant.menu.firstWhere((item) => item.id == itemId);
      orderItems.add(OrderItem(menuItem: menuItem, quantity: quantity));
    });

    final newOrder = OrderModel(
      orderId: 'FD${DateTime.now().millisecondsSinceEpoch}',
      restaurantName: widget.restaurant.name,
      items: orderItems,
      totalPrice: _totalPrice,
      orderDate: DateTime.now(),
      status: 'pending',
    );

    Provider.of<OrderProvider>(context, listen: false).addOrder(newOrder);
    Provider.of<TabProvider>(context, listen: false).changeTab(2); // Go to Orders tab
    Navigator.of(context).popUntil((route) => route.isFirst); // Go back home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildMenuHeader(),
          _buildMenuList(),
        ],
      ),
      bottomNavigationBar: _selectedItems.isNotEmpty ? _buildCheckoutBar() : null,
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      elevation: 2,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.restaurant.name,
          style: const TextStyle(shadows: [Shadow(blurRadius: 10)]),
        ),
        background: Image.network(
          widget.restaurant.imageUrl,
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(0.4),
          colorBlendMode: BlendMode.darken,
        ),
      ),
    );
  }

  Widget _buildMenuHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Menu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  widget.restaurant.rating.toString(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = widget.restaurant.menu[index];
          final count = _selectedItems[item.id] ?? 0;
          return _buildMenuItemTile(item, count);
        },
        childCount: widget.restaurant.menu.length,
      ),
    );
  }

  Widget _buildMenuItemTile(MenuItem item, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.price),
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onPressed: count > 0 ? () => _updateItemCount(item, -1) : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(count.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    _buildQuantityButton(
                      icon: Icons.add,
                      onPressed: () => _updateItemCount(item, 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(item.imageUrl, fit: BoxFit.cover, height: 100),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback? onPressed}) {
    final color = onPressed != null ? Theme.of(context).primaryColor : Colors.grey;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(16.0).copyWith(bottom: MediaQuery.of(context).padding.bottom + 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$_totalItemCount items in cart', style: TextStyle(color: Colors.grey[600])),
              Text(
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_totalPrice),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _processOrder,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}