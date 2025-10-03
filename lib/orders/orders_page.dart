import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/providers/order_provider.dart';
import 'package:food_delivery_app/models/search_model.dart';
import 'package:food_delivery_app/widgets/order_history_card.dart';
import 'package:food_delivery_app/providers/tab_provider.dart';

class OrdersPage extends StatefulWidget {
  final int initialTabIndex; 
  const OrdersPage({super.key, this.initialTabIndex = 0});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    
    final tabProvider = Provider.of<TabProvider>(context, listen: false);
    
    final initialIndex = tabProvider.ordersInitialTabIndex;

    _tabController = TabController(
      length: 5,
      initialIndex: initialIndex, 
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildOrderList(BuildContext context, List<OrderModel> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'No orders in this category.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderHistoryCard(order: orders[index]);
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final allOrders = orderProvider.orderHistory;
    final isLoading = orderProvider.isLoading;

    final pendingOrders = allOrders.where((order) => order.status == 'pending' || order.status == 'Awaiting Confirmation').toList();
    
    final onDeliveryOrders = allOrders.where((order) => 
        order.status == 'Delivery' || 
        order.status == 'In progress' || 
        order.status == 'Ready for Pickup' ||
        (order.status == 'Awaiting Confirmation' && orderProvider.currentlyProcessingOrderId == order.orderId)
    ).toList();
    
    final completedOrders = allOrders.where((order) => order.status == 'Completed').toList();
    final cancelledOrders = allOrders.where((order) => order.status == 'Cancelled').toList();


    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 0, 119, 255).withOpacity(0.8),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,           
          unselectedLabelColor: Colors.white70, 
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Pending Payment'),
            Tab(text: 'All'),
            Tab(text: 'On Delivery'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled')
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(context, pendingOrders),
                _buildOrderList(context, allOrders),
                _buildOrderList(context, onDeliveryOrders),
                _buildOrderList(context, completedOrders),
                _buildOrderList(context, cancelledOrders), 
              ],
            ),
    );
  }
}