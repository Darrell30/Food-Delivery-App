import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Food Delivery",
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // sementara semua halaman selain Home dummy dulu
  final List<Widget> _screens = const [
    HomeScreen(),
    Center(child: Text("Pickup Screen")),
    Center(child: Text("Offers Screen")),
    Center(child: Text("Search Screen")),
    Center(child: Text("Orders Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory), label: "Pickup"),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: "Offers"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Orders"),
        ],
      ),
    );
  }
}
