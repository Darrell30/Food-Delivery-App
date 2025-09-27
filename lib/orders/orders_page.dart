import 'package:flutter/material.dart';
import 'order_models.dart'; 

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
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  
  List<Order> _ordersList = initialOrdersList;
  
  final double _shippingFee = 17500;

  void _updateOrderStatus(String orderId, OrderStatus newStatus) {
    setState(() {
      final int index = _ordersList.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _ordersList[index] = Order(
          id: _ordersList[index].id,
          status: newStatus,
          items: _ordersList[index].items,
          totalPrice: _ordersList[index].totalPrice,
        );
      }
    });
  }

  Widget _buildOrderList(BuildContext context, List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('No Orders.'));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final Order order = orders[index];
        final bool isPending = order.status == OrderStatus.pending;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailPage(
                    order: order,
                    shippingFee: _shippingFee,
                    onPaymentComplete: _updateOrderStatus, // Pass the callback here too
                  ),
                ),
              );
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
  final Function(String, OrderStatus) onPaymentComplete; // Tambahkan callback
  const OrderDetailPage({
    super.key, 
    required this.order, 
    required this.shippingFee,
    required this.onPaymentComplete, // Inisialisasi callback
  });

  @override
  Widget build(BuildContext context) {
    final bool isPending = order.status == OrderStatus.pending;
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
          
          if (isPending)
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
                    // Panggil bottom sheet seperti di OrdersPage
                    _showPaymentSheet(
                      context, 
                      order, 
                      // Callback akan menjalankan navigasi dan update status
                      (orderId, newStatus) {
                        // 1. Tutup OrderDetailPage (agar kembali ke OrdersPage)
                        Navigator.pop(context); 
                        // 2. Lanjutkan dengan callback asli (update status dan navigate ke success)
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
                onPressed: () {
                  
                  Navigator.pop(context); 
                  
                  
                  widget.onPaymentComplete(widget.order.id, OrderStatus.onDelivery);
                  
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentSuccessPage(
                        order: widget.order,
                        paymentMethod: _selectedMethodName,
                        amount: finalPaymentAmount,
                      ),
                    ),
                  );
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
                  
                  Navigator.popUntil(context, (route) => route.isFirst); 
                },
                child: const Text('Back to Orders History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}