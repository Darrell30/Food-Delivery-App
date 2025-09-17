import 'package:flutter/material.dart';

enum OrderStatus { all, pending, onDelivery, completed }

class Order {
  final String id;
  final OrderStatus status;
  final List<String> items;
  final double totalPrice;

  Order({
    required this.id,
    required this.status,
    required this.items,
    required this.totalPrice,
  });
}

final List<Order> dummyOrders = [
  Order(
    id: 'ORD001',
    status: OrderStatus.completed,
    items: ['Pizza', 'Cola'],
    totalPrice: 150000,
  ),
  Order(
    id: 'ORD002',
    status: OrderStatus.onDelivery,
    items: ['Burger'],
    totalPrice: 75000,
  ),
  Order(
    id: 'ORD003',
    status: OrderStatus.pending,
    items: ['Fried Chicken', 'Rice'],
    totalPrice: 85000,
  ),
  Order(
    id: 'ORD004',
    status: OrderStatus.completed,
    items: ['Noodles', 'Ice Tea'],
    totalPrice: 60000,
  ),
];

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Pesanan'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Dalam Proses'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
           
            _buildOrderList(dummyOrders),
            
            _buildOrderList(
              dummyOrders.where((order) =>
                  order.status == OrderStatus.pending ||
                  order.status == OrderStatus.onDelivery).toList(),
            ),
          
            _buildOrderList(
              dummyOrders.where((order) => order.status == OrderStatus.completed).toList(),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('Tidak ada pesanan.'));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('ID: ${order.id}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ${order.status.name}'),
                Text('Item: ${order.items.join(', ')}'),
              ],
            ),
            trailing: Text('Rp ${order.totalPrice.toStringAsFixed(0)}'),
          ),
        );
      },
    );
  }
}