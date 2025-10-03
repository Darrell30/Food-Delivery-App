import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/providers/tab_provider.dart';
import 'package:food_delivery_app/providers/order_provider.dart';
import 'package:food_delivery_app/models/search_model.dart';
import 'package:food_delivery_app/models/menu_item.dart';

class RestaurantMenuPage extends StatefulWidget {
  final String placeName;

  const RestaurantMenuPage({super.key, required this.placeName});

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  final List<MenuItem> _menu = [
    MenuItem(id: 'm1', name: 'Classic Burger', price: 75000, imageUrl: 'https://via.placeholder.com/150'),
    MenuItem(id: 'm2', name: 'Pizza', price: 150000, imageUrl: 'https://via.placeholder.com/150'),
    MenuItem(id: 'm3', name: 'Cola', price: 15000, imageUrl: 'https://via.placeholder.com/150'),
  ];
  final Map<String, int> _selectedItems = {};

  void _updateItemCount(MenuItem item, int change) {
    setState(() {
      int newCount = (_selectedItems[item.id] ?? 0) + change;
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
      final menuItem = _menu.firstWhere((item) => item.id == itemId);
      orderItems.add(OrderItem(menuItem: menuItem, quantity: quantity));
      totalPrice += menuItem.price * quantity;
    });

    final newOrder = OrderModel(
      orderId: 'FD${DateTime.now().millisecondsSinceEpoch}',
      restaurantName: widget.placeName,
      items: orderItems,
      totalPrice: totalPrice,
      orderDate: DateTime.now(),
      status: 'pending',
    );

    Provider.of<OrderProvider>(context, listen: false).addOrder(newOrder);
    Provider.of<TabProvider>(context, listen: false).changeTab(2);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final bool isOrderReady = _selectedItems.isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: Text('Menu In ${widget.placeName}')),
      body: ListView.builder(
        itemCount: _menu.length,
        itemBuilder: (context, index) {
          final item = _menu[index];
          final int count = _selectedItems[item.id] ?? 0;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              title: Text(item.name),
              subtitle: Text('Rp ${item.price.toStringAsFixed(0)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: count > 0 ? Colors.red : Colors.grey),
                    onPressed: count > 0 ? () => _updateItemCount(item, -1) : null,
                  ),
                  Text(count.toString()),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () => _updateItemCount(item, 1),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: isOrderReady
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(onPressed: _processOrder, child: const Text('Make Order')),
            )
          : null,
    );
  }
}