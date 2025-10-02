import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tab_provider.dart';
import '../user_data.dart';
import '../profile/map_screen.dart';
import 'profile/screens/balance_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> promoImagePaths = [
    'assets/icons/promo1.jpg',
    'assets/icons/promo2.jpg',
    'assets/icons/promo3.jpg',
    'assets/icons/promo4.jpg',
  ];

  late final PageController _pageController;
  late final Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.85,
    );

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        if (_currentPage < promoImagePaths.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const _CustomAppBar(), // Menggunakan AppBar yang sudah dioptimalkan
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _buildPromoSlider(),
          _buildPageIndicator(),
          const _BalanceCard(), // Menggunakan BalanceCard yang sudah dioptimalkan
          const SizedBox(height: 20),
          const SectionTitle(title: "Order Within Vicinity"),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: ProductCard(
                  name: "Burger King",
                  subtitle: "47 min • \$3.99 delivery",
                  imagePath: "assets/icons/burger.jpg",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ProductCard(
                  name: "7-Eleven",
                  subtitle: "29 min • \$2.99 delivery",
                  imagePath: "assets/icons/seven-eleven.png",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: "Special Offers for You"),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: ProductCard(
                  name: "Ramen House",
                  subtitle: "Free delivery",
                  imagePath: "assets/icons/Ramen.jpeg",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ProductCard(
                  name: "Sushi World",
                  subtitle: "20% OFF",
                  imagePath: "assets/icons/Sushi.jpeg",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSlider() {
    return SizedBox(
      height: 180.0,
      child: PageView.builder(
        controller: _pageController,
        itemCount: promoImagePaths.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                promoImagePaths[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(promoImagePaths.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserData>();

    ImageProvider? backgroundImage;
    if (userData.profileImagePath.isNotEmpty) {
      backgroundImage = userData.profileImagePath.startsWith('assets/')
          ? AssetImage(userData.profileImagePath)
          : FileImage(File(userData.profileImagePath));
    }

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: CircleAvatar(
          backgroundColor: const Color(0xFFF3F3F3),
          backgroundImage: backgroundImage,
          child: backgroundImage == null
              ? const Icon(Icons.person, color: Colors.black54)
              : null,
        ),
        onPressed: () => context.read<TabProvider>().changeTab(4),
      ),
      title: InkWell(
        onTap: () async {
          final newAddress = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MapScreen()),
          );
          if (newAddress != null && newAddress is String) {
            context.read<UserData>().updateUserAddress(newAddress);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DELIVERING TO",
              style: TextStyle(fontSize: 12, color: Color.fromRGBO(39, 0, 197, 1)),
            ),
            Text(
              userData.userAddress.isNotEmpty ? userData.userAddress : "Set your address",
              style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      // ### PERUBAHAN FUNGSI PANAH DI SINI ###
      actions: [
        PopupMenuButton<int>(
          tooltip: "Tampilkan opsi alamat",
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          itemBuilder: (context) => [
            // Item 1: Menampilkan alamat lengkap (tidak bisa diklik)
            PopupMenuItem(
              enabled: false,
              child: Text(
                userData.userAddress,
                style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 1,
              child: Row(
                children: const [
                  Icon(Icons.account_balance_wallet, color: Color.fromRGBO(39, 0, 197, 1)),
                  SizedBox(width: 10),
                  Text("My Balance"),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            // Aksi saat item dipilih
            if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BalanceScreen()),
              );
            }
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFE0F7FA),
              child: Icon(Icons.account_balance_wallet, color: Color.fromRGBO(39, 0, 197, 1)),
            ),
            const SizedBox(width: 12),
            Text(
              context.watch<UserData>().formattedBalance,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            _ActionItem(
              icon: Icons.add,
              label: "Top Up",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BalanceScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color.fromARGB(25, 0, 13, 255),
              child: Icon(icon, color: const Color.fromRGBO(39, 0, 197, 1), size: 22),
            ),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const Text("See All",
            style: TextStyle(color: Color.fromRGBO(39, 0, 197, 1))),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String imagePath;
  const ProductCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.imagePath,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height:   200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}