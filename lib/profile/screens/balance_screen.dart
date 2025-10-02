import 'package:flutter/material.dart';

class EWallet {
  final String name;
  final String balance;
  final String assetPath;
  final Color color;

  EWallet({
    required this.name,
    required this.balance,
    required this.assetPath,
    required this.color,
  });
}

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final String _appCreditBalance = "Rp 134.000";

  final List<EWallet> _eWallets = [
    EWallet(name: 'GoPay', balance: 'Rp 57.000', assetPath: 'assets/icons/gopay.jpg', color: const Color(0xFF0088A9),),
    EWallet(name: 'OVO', balance: 'Rp 78.500', assetPath: 'assets/icons/ovo.png', color: const Color(0xFF4B35A0)),
    EWallet(name: 'Dana', balance: 'Rp 21.000', assetPath: 'assets/icons/dana.png', color: const Color(0xFF108EE9)),
  ];

  void _onTopUpMethodTapped(String methodName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected top-up with $methodName. Enter amount...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Balance', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 24),
          _buildSectionHeader("Top Up With"),
          const SizedBox(height: 16),
          _buildTopUpOptions(),
          const SizedBox(height: 24),
          _buildSectionHeader("Your E-Wallet Balances"),
          const SizedBox(height: 8),
          _buildEWalletBalancesPreview(),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 119, 255), Color.fromARGB(255, 114, 180, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Credits',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              _appCreditBalance,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUpOptions() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildTopUpItem(name: "GoPay", assetPath: 'assets/icons/gopay.jpg'),
        _buildTopUpItem(name: "OVO", assetPath: 'assets/icons/ovo.png'),
        _buildTopUpItem(name: "Other", assetPath: null), // For "Other Methods"
      ],
    );
  }

  Widget _buildTopUpItem({required String name, String? assetPath}) {
    return InkWell(
      onTap: () => _onTopUpMethodTapped(name),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            assetPath != null
                ? Image.asset(assetPath, height: 32)
                : Icon(Icons.more_horiz, size: 32, color: Colors.blue.shade800),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Colors.grey[600],
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }
  
  Widget _buildEWalletBalancesPreview() {
    return ListView.separated(
      itemCount: _eWallets.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final wallet = _eWallets[index];
        return Card(
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Image.asset(wallet.assetPath, width: 35, height: 35),
            title: Text(wallet.name, style: const TextStyle(fontWeight: FontWeight.w500)),
            trailing: Text(
              wallet.balance,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}