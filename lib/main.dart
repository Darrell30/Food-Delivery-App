import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tab_provider.dart';
import 'providers/order_provider.dart';
import 'user_data.dart';
import 'home_screen.dart';
import 'screens/pickup_screen.dart';
import 'orders/orders_page.dart';
import 'Search/search_screen.dart';
import 'profile/profile.dart';
import 'profile/screens/login_screen.dart';
import 'profile/screens/auth_check_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserData()),
        ChangeNotifierProvider(create: (context) => TabProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: const FoodDeliveryApp(),
    ),
  );
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Food Delivery",
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(39, 0, 197, 1),
        fontFamily: 'Poppins',
      ),
      home: const AuthCheckScreen(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);

    final List<Widget> screens = const [
      HomeScreen(),
      PickUpScreen(),
      OrdersPage(),
      SearchScreen(),
      ProfilePage(),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (tabProvider.currentIndex != 0) {
          tabProvider.changeTab(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: tabProvider.currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabProvider.currentIndex,
          selectedItemColor: const Color.fromRGBO(39, 0, 197, 1),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            tabProvider.changeTab(index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.store_mall_directory), label: "Pickup"),
            BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Orders"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'You'),
          ],
        ),
      ),
    );
  }
}