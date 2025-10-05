import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/models/search_model.dart';
import 'package:food_delivery_app/models/menu_item.dart';
import '../providers/order_provider.dart';
import '../providers/tab_provider.dart';
import '../main.dart'; 

class OrderScreen extends StatefulWidget {
  final String placeName;

  const OrderScreen({
    super.key,
    required this.placeName,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  OrderModel? _currentOrder; 
  late double _pendingPrice;

  @override
  void initState() {
    super.initState();
    _pendingPrice = _generateRandomPrice();
    
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    if (orderProvider.currentlyProcessingOrderId != null && orderProvider.isProcessing) {
      try {
        final OrderModel foundOrder = orderProvider.orderHistory.firstWhere(
          (order) => order.orderId == orderProvider.currentlyProcessingOrderId,
        );
        
        if (foundOrder.status == 'Processing (Cooking)') {
             _currentOrder = foundOrder; 
        } else {
             _currentOrder = null;
        }
      } catch (_) {
        _currentOrder = null; 
      }
    } else {
        _currentOrder = null;
    }
  }

  double _generateRandomPrice() {
    final random = Random();
    return (30000 + random.nextInt(70001)).toDouble();
  }

  String _getStatusMessage(int secondsRemaining) {
    if (secondsRemaining > 5) {
      return "Your Order is being Cooked";
    } else if (secondsRemaining >= 1) {
      return "Your Order is being Packed";
    } else {
      return "Your Order is Ready for Pickup!";
    }
  }

  void _createAndProcessOrder() {
    final uniqueId = 'FD_P_${DateTime.now().millisecondsSinceEpoch}';

    final newOrderModel = OrderModel(
      orderId: uniqueId,
      restaurantName: widget.placeName,
      totalPrice: _pendingPrice,
      orderDate: DateTime.now(),
      items: [
        OrderItem(
          menuItem: MenuItem(id: 'm1', name: 'Fried Chicken', price: _pendingPrice, imageUrl: 'https://via.placeholder.com/150'), 
          quantity: 1,
        ),
      ],
      status: 'Waiting Confirmation', 
    );

    Provider.of<OrderProvider>(context, listen: false).addOrder(newOrderModel);
    Provider.of<OrderProvider>(context, listen: false).startOrderProcessing(uniqueId);

    setState(() {
      _currentOrder = newOrderModel;
    });
  }
  
  void _goToOrderHistory(BuildContext context, TabProvider tabProvider) {
    setState(() {
      _currentOrder = null;
    });
    
    Navigator.pop(context); 

    Future.microtask(() {
      tabProvider.changeTab(2); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Viewing Order History.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final tabProvider = Provider.of<TabProvider>(context, listen: false);
    
    final bool hasOrderReadyInHistory = 
        orderProvider.orderHistory.any((o) => 
            _currentOrder != null && 
            o.orderId == _currentOrder!.orderId && 
            o.status == 'Ready for Pickup'
        );
        
    final bool isProcessing = 
        _currentOrder != null && 
        orderProvider.currentlyProcessingOrderId == _currentOrder!.orderId;

    final bool isReadyForPickup = hasOrderReadyInHistory && !isProcessing;
        
    final bool isOrderPending = _currentOrder == null || (!isProcessing && !isReadyForPickup);


    return Scaffold(
      appBar: AppBar(
        title: Text("Order in ${widget.placeName}"),
        actions: [
          if (isProcessing || isReadyForPickup)
            TextButton(
              onPressed: () => _goToOrderHistory(context, tabProvider),
              child: const Text('Go to Orders', style: TextStyle(color: Colors.blue)),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            if (isOrderPending) ...[
              const Text(
                "Order 'Fried Chicken' is ready to be made",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Price: Rp ${_pendingPrice.toStringAsFixed(0)}",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createAndProcessOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Order', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],

            if (isProcessing) ...[
              Image.asset(
                'assets/gifs/Cooking.gif', 
                width: 350, 
                height: 350, 
              ),
              const SizedBox(height: 30),
              Text(
                _getStatusMessage(orderProvider.secondsRemaining), 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Est. Time Left: ${orderProvider.secondsRemaining} seconds",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Please Wait...",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],

            if (isReadyForPickup) ...[
              Image.asset(
                'assets/gifs/Cooking.gif', 
                width: 350, 
                height: 350, 
              ),
              const SizedBox(height: 30),
              const Text(
                "Your Order is Ready for Pickup!", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Your Order is Ready! Please proceed to pickup.",
                style: TextStyle(fontSize: 16, color: Colors.green),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _goToOrderHistory(context, tabProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(39, 0, 197, 1),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Confirm Pickup / View Orders', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}