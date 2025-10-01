import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/providers/order_provider.dart';
import 'package:food_delivery_app/models/order_model.dart';
import 'package:food_delivery_app/widgets/order_history_card.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final allOrders = orderProvider.orderHistory;
    final isLoading = orderProvider.isLoading;

    // Filter the list for each tab
    final pendingOrders = allOrders.where((order) => order.status == 'pending').toList();
    final onDeliveryOrders = allOrders.where((order) => order.status == 'on_delivery').toList();
    final completedOrders = allOrders.where((order) => order.status == 'Selesai').toList();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Pending Payment'),
              Tab(text: 'All'),
              Tab(text: 'On Delivery'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildOrderList(context, pendingOrders),
                  _buildOrderList(context, allOrders),
                  _buildOrderList(context, onDeliveryOrders),
                  _buildOrderList(context, completedOrders),
                ],
              ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, List<OrderModel> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada pesanan di kategori ini.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    // Sort orders from newest to oldest
    orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderHistoryCard(order: orders[index]);
      },
    );
  }
}