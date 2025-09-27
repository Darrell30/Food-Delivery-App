// orders/orders_page.dart

import 'package:flutter/material.dart';
import 'order_models.dart'; 
import '../screens/OrderScreen.dart'; 
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String _ordersKey = 'persistent_orders_list';

// --- Helper untuk membuat ID Pesanan Baru ---
String _generateNewOrderId(List<Order> orders) {
  int maxId = 0;
  for (var order in orders) {
    if (order.id.startsWith('ORD')) {
      final idNumber = int.tryParse(order.id.substring(3));
      if (idNumber != null && idNumber > maxId) {
        maxId = idNumber;
      }
    }
  }
  return 'ORD${(maxId + 1).toString().padLeft(3, '0')}';
}

void _showPaymentSheet(BuildContext context, Order order, Function(String, OrderStatus) onPaymentComplete) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    builder: (BuildContext context) {
      return PaymentMethodSelectionSheet(
        order: order,
        onPaymentComplete: onPaymentComplete,
      );
    },
  );
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> { // Class State Publik
  
  List<Order> _ordersList = [];
  bool _isLoadingOrders = true; 
  
  final double _shippingFee = 17500;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }
  
  // --- FUNGSI SHARED PREFERENCES: LOAD & SAVE ---
  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? ordersJsonString = prefs.getString(_ordersKey);
    
    if (ordersJsonString != null) {
      final List<dynamic> ordersJson = jsonDecode(ordersJsonString);
      setState(() {
        if(ordersJson.isEmpty) {
             _ordersList = initialOrdersList;
        } else {
             _ordersList = ordersJson.map((json) => Order.fromJson(json)).toList();
        }
        _isLoadingOrders = false;
      });
    } else {
       setState(() {
        _ordersList = initialOrdersList;
        _isLoadingOrders = false;
      });
    }
    _saveOrders();
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> ordersJson = 
        _ordersList.map((order) => order.toJson()).toList();
    await prefs.setString(_ordersKey, jsonEncode(ordersJson));
  }


  void _updateOrderStatus(String orderId, OrderStatus newStatus) {
    setState(() {
      final int index = _ordersList.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _ordersList[index] = Order(
          id: _ordersList[index].id,
          status: newStatus, 
          items: _ordersList[index].items,
          totalPrice: _ordersList[index].totalPrice,
          creationTimeMillis: _ordersList[index].creationTimeMillis, 
        );
        _saveOrders(); // Simpan perubahan status
      }
    });
  }
  
  // --- Fungsi untuk menambahkan pesanan baru (PUBLIK & ASYNC) ---
  void addNewOrder(Order newOrder) async { 
    final finalOrder = Order(
      id: _generateNewOrderId(_ordersList),
      status: newOrder.status,
      items: newOrder.items,
      totalPrice: newOrder.totalPrice,
      creationTimeMillis: DateTime.now().millisecondsSinceEpoch, 
    );
    setState(() {
      _ordersList.insert(0, finalOrder); 
    });
    _saveOrders(); 

    // Pindah ke tab Payment
    DefaultTabController.of(context).animateTo(0);
    
    // 1. PUSH ke OrderDetailPage dan TUNGGU hasilnya (paidOrderId)
    final paidOrderId = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailPage(
          order: finalOrder,
          shippingFee: _shippingFee,
          onPaymentComplete: _updateOrderStatus, 
        ),
      ),
    );

    // 2. Setelah pembayaran selesai (paidOrderId diterima):
    if (paidOrderId is String && mounted) {
      
      final paidOrder = _ordersList.firstWhere((o) => o.id == paidOrderId);
      
      // 3. Langsung push ke OrderScreen untuk memulai countdown
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderScreen(
                  placeName: 'Restoran Pilihan Anda', 
                  initialOrder: paidOrder, 
                  onOrderCompleted: (completedOrder) {
                      // Callback untuk status completed
                      _updateOrderStatus(completedOrder.id, OrderStatus.completed);
                  }
              )
          )
      );
    }
  }

  Widget _buildOrderList(BuildContext context, List<Order> orders) {
    if (_isLoadingOrders) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (orders.isEmpty) {
      return const Center(child: Text('No Orders.'));
    }
    
    orders.sort((a, b) => b.creationTimeMillis.compareTo(a.creationTimeMillis));

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final Order order = orders[index];
        final bool isPending = order.status == OrderStatus.pending;
        final bool isDelivery = order.status == OrderStatus.onDelivery;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            onTap: () {
              if (isDelivery) {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderScreen(
                      placeName: 'Restoran Pilihan Anda', 
                      initialOrder: order,
                      onOrderCompleted: (completedOrder) {
                        _updateOrderStatus(completedOrder.id, OrderStatus.completed);
                      },
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailPage(
                      order: order,
                      shippingFee: _shippingFee,
                      onPaymentComplete: _updateOrderStatus, 
                    ),
                  ),
                );
              }
            },
            title: Text('ID: ${order.id}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ${order.status.name}'),
                Text('Item: ${order.items.join(', ')}'),
              ],
            ),
            trailing: isPending
                ? ElevatedButton(
                    onPressed: () => _showPaymentSheet(context, order, _updateOrderStatus),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Pay', style: TextStyle(color: Colors.white)),
                  )
                : Text('Rp ${order.totalPrice.toStringAsFixed(0)}'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders History'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Payment'),
              Tab(text: 'All'),
              Tab(text: 'On Delivery'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(
              context,
              _ordersList.where((order) => order.status == OrderStatus.pending).toList(),
            ),
            _buildOrderList(context, _ordersList),
            _buildOrderList(
              context,
              _ordersList.where((order) => order.status == OrderStatus.onDelivery).toList(),
            ),
            _buildOrderList(
              context,
              _ordersList.where((order) => order.status == OrderStatus.completed).toList(),
            ),
          ],
        ),
      ),
    );
  }
}


class OrderDetailPage extends StatelessWidget {
  final Order order;
  final double shippingFee;
  final Function(String, OrderStatus) onPaymentComplete; 
  const OrderDetailPage({
    super.key, 
    required this.order, 
    required this.shippingFee,
    required this.onPaymentComplete, 
  });

  @override
  Widget build(BuildContext context) {
    final double finalPrice = order.totalPrice + shippingFee; 

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Detail ${order.id}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID Orders: ${order.id}', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Status: ${order.status.name}', style: Theme.of(context).textTheme.titleMedium),
                  const Divider(height: 30),
                  Text('Item Order:', style: Theme.of(context).textTheme.titleMedium),
                  
                  ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(child: Text('- $item')),
                        const Text('Rp 0'),
                      ],
                    ),
                  )).toList(),
                  const Divider(height: 30),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Order Price:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Rp ${order.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Shipping Cost (Reguler):'),
                      Text('Rp ${shippingFee.toStringAsFixed(0)}'),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Payment:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Rp ${finalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          if (order.status == OrderStatus.pending) 
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showPaymentSheet(
                      context, 
                      order, 
                      
                      (orderId, newStatus) {
                        Navigator.pop(context); // Tutup Detail Page
                        onPaymentComplete(orderId, newStatus); 
                      }
                    );
                  },
                  icon: const Icon(Icons.payment_outlined, color: Colors.white),
                  label: Text('Pay Now - Rp ${finalPrice.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PaymentMethodSelectionSheet extends StatefulWidget {
  final Order order;
  final Function(String, OrderStatus) onPaymentComplete; 
  const PaymentMethodSelectionSheet({
    super.key, 
    required this.order, 
    required this.onPaymentComplete
  });

  @override
  State<PaymentMethodSelectionSheet> createState() => _PaymentMethodSelectionSheetState();
}

class _PaymentMethodSelectionSheetState extends State<PaymentMethodSelectionSheet> {
  
  final List<Map<String, dynamic>> _mainMethods = [
    {'name': 'GoPay', 'balance': 'Rp 0', 'isDefault': true, 'icon': Icons.payment},
    {'name': 'Bank **0397', 'balance': '', 'isDefault': false, 'icon': Icons.credit_card},
  ];

  String _selectedMethodName = 'GoPay'; 
  final double _shippingFee = 17500;

  @override
  Widget build(BuildContext context) {
    
    final double finalPaymentAmount = widget.order.totalPrice + _shippingFee; 

  
    final List<Map<String, dynamic>> _addMethods = [
        {'name': 'GoPay Coins', 'detail': 'Saldo: 7.151', 'icon': Icons.monetization_on},
        {'name': 'OVO', 'detail': 'Saldo: 0', 'icon': Icons.account_balance_wallet},
        {'name': 'LinkAja', 'detail': 'Saldo: 0', 'icon': Icons.account_balance_wallet},
        {'name': 'Cash (Bayar di tempat)', 'detail': 'Total: Rp ${finalPaymentAmount.toStringAsFixed(0)}', 'icon': Icons.money},
    ];
    
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Select Payment Method',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text('Primary Payment Methods', style: TextStyle(color: Colors.grey)),
          ),
          ..._mainMethods.map((method) => ListTile(
            leading: Icon(method['icon'] as IconData, color: Colors.blue),
            title: Text(method['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(method['balance'] as String),
            trailing: Radio<String>(
              value: method['name'] as String,
              groupValue: _selectedMethodName,
              onChanged: (String? value) {
                setState(() => _selectedMethodName = value!);
              },
            ),
            onTap: () => setState(() => _selectedMethodName = method['name'] as String),
          )),
          const Divider(height: 1),

          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text('Additional payment methods', style: TextStyle(color: Colors.grey)),
          ),
          ..._addMethods.map((method) => ListTile(
            leading: Icon(method['icon'] as IconData, color: Colors.black54),
            title: Text(method['name'] as String),
            subtitle: Text(method['detail'] as String),
            trailing: Radio<String>(
              value: method['name'] as String,
              groupValue: _selectedMethodName,
              onChanged: (String? value) {
                setState(() => _selectedMethodName = value!);
              },
            ),
            onTap: () => setState(() => _selectedMethodName = method['name'] as String),
          )),

          
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async { // <-- HARUS ASYNC
                  
                  Navigator.pop(context); // Tutup Payment Sheet
                  
                  // 1. Perbarui status pesanan menjadi 'onDelivery' (tersimpan di shared_prefs)
                  widget.onPaymentComplete(widget.order.id, OrderStatus.onDelivery);
                  
                  // 2. PUSH PaymentSuccessPage dan KEMBALIKAN ID order
                  final resultOrderId = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentSuccessPage(
                        order: widget.order,
                        paymentMethod: _selectedMethodName,
                        amount: finalPaymentAmount,
                      ),
                    ),
                  );
                  
                  // 3. POP OrderDetailPage dan kirim ID order yang baru dibayar kembali ke addNewOrder
                  if (resultOrderId is String) {
                    Navigator.pop(context, resultOrderId); 
                  } else {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Pay Rp ${finalPaymentAmount.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class PaymentSuccessPage extends StatelessWidget {
  final Order order;
  final String paymentMethod;
  final double amount;

  const PaymentSuccessPage({
    super.key,
    required this.order,
    required this.paymentMethod,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful!'),
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                'Orders ${order.id} Successfully Paid.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text('Total Payment: Rp ${amount.toStringAsFixed(0)}'),
              Text('Payment Method: $paymentMethod'),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Pop PaymentSuccessPage dan kirim ID order
                  Navigator.pop(context, order.id); 
                },
                child: const Text('Mulai Pick Up Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}