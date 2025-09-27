import 'package:flutter/material.dart';

// --- Data Model ---
class PaymentMethod {
  final String name;
  final String? balance;
  final IconData icon;
  bool isSelected;

  PaymentMethod({
    required this.name,
    this.balance,
    required this.icon,
    this.isSelected = false,
  });
}

// --- Main Screen Widget ---
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  static const uiColor = Color.fromRGBO(39, 0, 197, 1);

  final List<PaymentMethod> _eWallets = [
    PaymentMethod(name: 'GoPay', balance: 'Balance: Rp 123.456', icon: Icons.account_balance_wallet, isSelected: true),
    PaymentMethod(name: 'OVO', balance: 'Connect', icon: Icons.wallet_giftcard),
    PaymentMethod(name: 'Dana', balance: 'Connect', icon: Icons.wallet_membership),
  ];

  final List<PaymentMethod> _otherMethods = [
    PaymentMethod(name: 'Credit / Debit Card', icon: Icons.credit_card),
    PaymentMethod(name: 'Cash on Delivery (COD)', icon: Icons.money),
  ];
  
  String _selectedMethodName = 'GoPay';

  void _onPaymentMethodTapped(String methodName) {
    setState(() {
      _selectedMethodName = methodName;
      
      for (var method in _eWallets) {
        method.isSelected = (method.name == methodName);
      }
      for (var method in _otherMethods) {
        method.isSelected = (method.name == methodName);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$methodName selected as payment method.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Payment Methods', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: uiColor,
        elevation: 1.0,
      ),
      body: ListView( // Changed Column to ListView to make it scrollable
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader("E-Wallets"),
          ..._eWallets.map((method) => _buildPaymentTile(method)),
          
          const SizedBox(height: 10),
          _buildSectionHeader("Cards & Other Methods"),
          ..._otherMethods.map((method) => _buildPaymentTile(method)),
          
          // --- NEW: Add this as a list tile ---
          _buildAddCardTile(), // Call the new widget here
          // --- END NEW ---

          const SizedBox(height: 20), // Add some bottom padding
        ],
      ),
    );
  }

  // --- Reusable Widgets ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildPaymentTile(PaymentMethod method) {
    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: () => _onPaymentMethodTapped(method.name),
        leading: Icon(method.icon, color: Colors.grey[700], size: 30),
        title: Text(method.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: method.balance != null
            ? Text(
                method.balance!,
                style: TextStyle(
                  color: method.balance! == 'Connect' ? uiColor : Colors.grey[600],
                  fontWeight: FontWeight.bold
                ),
              )
            : null,
        trailing: Radio<String>(
          value: method.name,
          groupValue: _selectedMethodName,
          onChanged: (value) {
            _onPaymentMethodTapped(value!);
          },
          activeColor: uiColor,
        ),
      ),
    );
  }

  // --- NEW WIDGET: A cleaner "Add Card" tile ---
  Widget _buildAddCardTile() {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: const Icon(Icons.add_circle_outline, color: uiColor, size: 30),
        title: const Text(
          'Add Credit / Debit Card',
          style: TextStyle(color: uiColor, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // TODO: Implement navigation to an "Add Card" screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Navigate to Add New Card Screen'))
          );
        },
      ),
    );
  }
}