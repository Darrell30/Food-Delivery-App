import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/providers/tab_provider.dart';
import 'package:food_delivery_app/providers/order_provider.dart';
import 'package:food_delivery_app/user_data.dart';
import 'package:food_delivery_app/home_screen.dart';
import 'package:food_delivery_app/screens/pickup_screen.dart';
import 'package:food_delivery_app/orders/orders_page.dart';
import 'package:food_delivery_app/Search/search_screen.dart';
import 'package:food_delivery_app/profile/profile.dart';
import 'package:food_delivery_app/profile/screens/auth_check_screen.dart';

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
        fontFamily: 'Poppins',
        primaryColor: const Color.fromRGBO(39, 0, 197, 1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(39, 0, 197, 1)),
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

    return Scaffold(
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
          Provider.of<TabProvider>(context, listen: false).changeTab(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory), label: "Pickup"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'You'),
        ],
      ),
    );
  }
}