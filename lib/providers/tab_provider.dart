import 'package:flutter/material.dart';

class TabProvider with ChangeNotifier {
  int _currentIndex = 0;
  // NEW: Properti untuk indeks TabController internal di OrdersPage
  int _ordersInitialTabIndex = 1; // Default ke tab 'All'

  int get currentIndex => _currentIndex;
  int get ordersInitialTabIndex => _ordersInitialTabIndex; // NEW GETTER

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }
  
  // NEW METHOD: Tambahkan fungsi ini
  void setOrdersInitialTab(int index) {
    _ordersInitialTabIndex = index;
    notifyListeners();
  }

  void resetTab() {
    _currentIndex = 0;
    _ordersInitialTabIndex = 1; // Reset juga index OrdersPage
    notifyListeners();
  }
}