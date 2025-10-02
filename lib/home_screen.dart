import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tab_provider.dart';
import '../user_data.dart';
import '../profile/map_screen.dart';
import 'profile/screens/balance_screen.dart';
import 'screens/restaurant_detail_page.dart';
import 'services/search_service.dart';
import 'models/restaurant.dart';
import 'screens/nearby_restaurants_page.dart';
import 'screens/discount_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SearchService _searchService = SearchService();
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
    _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        if (_currentPage < promoImagePaths.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(_currentPage,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn);
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
      appBar: const _CustomAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _buildPromoSlider(),
          _buildPageIndicator(),
          const _BalanceCard(),
          const SizedBox(height: 20),
          SectionTitle(
            title: "Order Within Vicinity",
            onSeeAllTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NearbyRestaurantsPage()),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final Restaurant? restaurantData =
                        _searchService.getRestaurantByName('Burger King');
                    if (restaurantData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailPage(
                            restaurant: restaurantData,
                          ),
                        ),
                      );
                    }
                  },
                  child: const ProductCard(
                    name: "Burger King",
                    subtitle: "47 min • \$3.99 delivery",
                    imagePath: "assets/icons/burger.jpg",
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final Restaurant? restaurantData =
                        _searchService.getRestaurantByName('Seven Eleven');
                    if (restaurantData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailPage(
                            restaurant: restaurantData,
                          ),
                        ),
                      );
                    }
                  },
                  child: const ProductCard(
                    name: "7-Eleven",
                    subtitle: "29 min • \$2.99 delivery",
                    imagePath: "assets/icons/seven-eleven.png",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionTitle(
            title: "Special Offers for You",
            onSeeAllTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiscountPage()),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final Restaurant? restaurantData =
                        _searchService.getRestaurantByName('Ramen House');
                    if (restaurantData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailPage(
                            restaurant: restaurantData,
                          ),
                        ),
                      );
                    }
                  },
                  child: const ProductCard(
                    name: "Ramen House",
                    subtitle: "Free delivery",
                    imagePath: "assets/icons/Ramen.jpeg",
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final Restaurant? restaurantData =
                        _searchService.getRestaurantByName('Sushi World');
                    if (restaurantData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailPage(
                            restaurant: restaurantData,
                          ),
                        ),
                      );
                    }
                  },
                  child: const ProductCard(
                    name: "Sushi World",
                    subtitle: "20% OFF",
                    imagePath: "assets/icons/Sushi.jpeg",
                  ),
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
                      child: Image.asset(promoImagePaths[index],
                          fit: BoxFit.cover)));
            }));
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
                  borderRadius: BorderRadius.circular(12)));
        }));
  }
}

// ### APPBAR DENGAN LATAR BELAKANG BARU ###
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

    return Container(
      color: const Color.fromARGB(255, 143, 175, 255) .withOpacity(0.8), 
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.white
                  .withOpacity(0.2),
              backgroundImage: backgroundImage,
              child: backgroundImage == null
                  ? const Icon(Icons.person,
                      color: Colors.white)
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
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white),
                ),
                Text(
                  userData.userAddress.isNotEmpty
                      ? userData.userAddress
                      : "Set your address",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          actions: [
            Consumer<UserData>(
              builder: (context, userDataConsumer, child) {
                return PopupMenuButton<int>(
                  tooltip: "Tampilkan opsi alamat",
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: false,
                      child: Text(
                        userDataConsumer.userAddress,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black87),
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: const [
                          Icon(Icons.account_balance_wallet,
                              color: Colors.blue),
                          SizedBox(width: 10),
                          Text("My Balance"),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BalanceScreen()),
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              const CircleAvatar(
                  backgroundColor: Color(0xFFE0F7FA),
                  child: Icon(Icons.account_balance_wallet,
                      color: Color(0xFF00838F))),
              const SizedBox(width: 12),
              Text(context.watch<UserData>().formattedBalance,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              _ActionItem(
                  icon: Icons.add,
                  label: "Top Up",
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BalanceScreen())))
            ])));
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE0F7FA),
                  child: Icon(icon, color: const Color(0xFF00838F), size: 22)),
              const SizedBox(height: 5),
              Text(label, style: const TextStyle(fontSize: 12))
            ])));
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        InkWell(
          onTap: onSeeAllTap,
          child: const Text(
            "See All",
            style: TextStyle(color: Color.fromRGBO(39, 0, 197, 1)),
          ),
        ),
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
      height: 180,
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
