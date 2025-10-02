import 'package:flutter/material.dart';

class TabProvider with ChangeNotifier {
  int _currentIndex = 0;
  int _ordersInitialTabIndex = 1; 

  int get currentIndex => _currentIndex;
  int get ordersInitialTabIndex => _ordersInitialTabIndex; 

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }
  
  void setOrdersInitialTab(int index) {
    _ordersInitialTabIndex = index;
    notifyListeners();
  }

  void resetTab() {
    _currentIndex = 0;
    _ordersInitialTabIndex = 1; 
    notifyListeners();
  }
}