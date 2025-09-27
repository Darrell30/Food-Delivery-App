import 'package:flutter/material.dart';

// Enum dan Class Order tetap sama
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
    status: OrderStatus.pending, // Menunggu pembayaran
    items: ['Fried Chicken', 'Rice'],
    totalPrice: 85000,
  ),
  Order(
    id: 'ORD004',
    status: OrderStatus.completed,
    items: ['Noodles', 'Ice Tea'],
    totalPrice: 60000,
  ),
  // Tambahkan satu lagi order pending untuk demonstrasi
  Order(
    id: 'ORD005',
    status: OrderStatus.pending,
    items: ['Milk Tea', 'Waffle'],
    totalPrice: 35000,
  ),
];

// --- FUNGSI DIALOG PEMBAYARAN ---
// Fungsi ini akan dipanggil saat tombol 'Bayar' diklik
void _showPaymentDialog(BuildContext context, Order order) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return _PaymentMethodSelectionDialog(order: order);
    },
  );
}

// --- WIDGET HALAMAN UTAMA (ORDERS PAGE) ---
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Pesanan'),
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
            // 1. Konten Tab 'Payment'
            _buildOrderList(
              context,
              dummyOrders.where((order) => order.status == OrderStatus.pending).toList(),
            ),

            // 2. Konten Tab 'All'
            _buildOrderList(context, dummyOrders),

            // 3. Konten Tab 'On Delivery'
            _buildOrderList(
              context,
              dummyOrders.where((order) => order.status == OrderStatus.onDelivery).toList(),
            ),

            // 4. Konten Tab 'Completed'
            _buildOrderList(
              context,
              dummyOrders.where((order) => order.status == OrderStatus.completed).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi _buildOrderList sekarang menerima BuildContext
  Widget _buildOrderList(BuildContext context, List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('Tidak ada pesanan.'));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isPending = order.status == OrderStatus.pending;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            // FITUR 1: Detail Pesanan (Semua Tab)
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailPage(order: order),
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
            // FITUR 2: Tombol Bayar (Hanya di Tab 'Payment')
            trailing: isPending
                ? ElevatedButton(
                    onPressed: () => _showPaymentDialog(context, order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Warna untuk tombol 'Bayar'
                    ),
                    child: const Text('Bayar', style: TextStyle(color: Colors.white)),
                  )
                : Text('Rp ${order.totalPrice.toStringAsFixed(0)}'),
          ),
        );
      },
    );
  }
}

// --- WIDGET DETAIL PESANAN ---
class OrderDetailPage extends StatelessWidget {
  final Order order;
  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan ${order.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Pesanan: ${order.id}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Status: ${order.status.name}'),
            Text('Total Harga: Rp ${order.totalPrice.toStringAsFixed(0)}'),
            const Divider(height: 30),
            Text('Daftar Item:', style: Theme.of(context).textTheme.titleMedium),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('- $item'),
            )).toList(),
            const Divider(height: 30),
            if (order.status == OrderStatus.pending)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _showPaymentDialog(context, order),
                  icon: const Icon(Icons.payment),
                  label: const Text('Lanjutkan Pembayaran'),
                ),
              )
          ],
        ),
      ),
    );
  }
}

// --- WIDGET PILIH METODE PEMBAYARAN (Bottom Sheet) ---
class _PaymentMethodSelectionDialog extends StatefulWidget {
  final Order order;
  const _PaymentMethodSelectionDialog({required this.order});

  @override
  State<_PaymentMethodSelectionDialog> createState() => _PaymentMethodSelectionDialogState();
}

class _PaymentMethodSelectionDialogState extends State<_PaymentMethodSelectionDialog> {
  String? _selectedMethod;
  final List<String> _paymentMethods = ['OVO', 'GoPay', 'Bank Transfer', 'Credit Card', 'Cash on Delivery (COD)'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Metode Pembayaran',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text('Total yang harus dibayar: Rp ${widget.order.totalPrice.toStringAsFixed(0)}'),
          const Divider(),
          ..._paymentMethods.map((method) => RadioListTile<String>(
            title: Text(method),
            value: method,
            groupValue: _selectedMethod,
            onChanged: (String? value) {
              setState(() {
                _selectedMethod = value;
              });
            },
          )).toList(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedMethod == null
                  ? null // Nonaktifkan tombol jika metode belum dipilih
                  : () {
                      // Logika Dummy Pembayaran
                      Navigator.pop(context); // Tutup dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Pembayaran sebesar Rp ${widget.order.totalPrice.toStringAsFixed(0)} dengan $_selectedMethod berhasil (Dummy).'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Di sini Anda bisa menambahkan logika untuk mengubah status order menjadi 'onDelivery'
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.blue,
              ),
              child: const Text('Lanjutkan Pembayaran', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}