import 'dart:async';
import 'package:food_delivery_app/models/restaurant.dart';
import 'package:food_delivery_app/models/menu_item.dart';

class SearchService {
  // Data dummy sekarang sudah dilengkapi dengan menu
  final List<Restaurant> _allRestaurants = [
    Restaurant(
      id: 'r1',
      name: 'Sate Padang Mak Ciak',
      cuisineType: 'Indonesian',
      rating: 4.9,
      tier: 'top',
      menu: [
        MenuItem(id: 'm1', name: 'Sate Padang Daging', price: 28000, imageUrl: 'https://via.placeholder.com/150'),
        MenuItem(id: 'm2', name: 'Sate Padang Lidah', price: 28000, imageUrl: 'https://via.placeholder.com/150'),
        MenuItem(id: 'm3', name: 'Kerupuk Kulit', price: 5000, imageUrl: 'https://via.placeholder.com/150'),
      ],
    ),
    Restaurant(
      id: 'r2',
      name: 'Nasi Goreng Mantap',
      cuisineType: 'Indonesian',
      rating: 4.8,
      tier: 'top',
      menu: [
        MenuItem(id: 'm4', name: 'Nasi Goreng Spesial', price: 35000, imageUrl: 'https://via.placeholder.com/150'),
        MenuItem(id: 'm5', name: 'Nasi Goreng Seafood', price: 40000, imageUrl: 'https://via.placeholder.com/150'),
        MenuItem(id: 'm6', name: 'Es Teh Manis', price: 8000, imageUrl: 'https://via.placeholder.com/150'),
      ],
    ),
    Restaurant(
      id: 'r3',
      name: 'Martabak Orins',
      cuisineType: 'Street Food',
      rating: 4.7,
      tier: 'top',
      menu: [
        MenuItem(id: 'm7', name: 'Martabak Telor Spesial', price: 55000, imageUrl: 'https://via.placeholder.com/150'),
        MenuItem(id: 'm8', name: 'Martabak Manis Coklat', price: 60000, imageUrl: 'https://via.placeholder.com/150'),
      ],
    ),
    Restaurant(
      id: 'r4',
      name: 'Burger Queen',
      cuisineType: 'Western',
      rating: 4.5,
      tier: 'top',
      menu: [
        MenuItem(id: 'm9', name: 'Classic Beef Burger', price: 75000, imageUrl: 'https://via.placeholder.com/150'),
        MenuItem(id: 'm10', name: 'French Fries', price: 30000, imageUrl: 'https://via.placeholder.com/150'),
        MenuItem(id: 'm11', name: 'Cola', price: 15000, imageUrl: 'https://via.placeholder.com/150'),
      ],
    ),
  ];

  Future<List<Restaurant>> getTopTierRestaurants() async {
    await Future.delayed(const Duration(seconds: 1));
    final results = _allRestaurants.where((r) => r.tier == 'top').toList();
    return results;
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    return [];
  }
}