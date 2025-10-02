import 'dart:async';
import 'package:food_delivery_app/models/restaurant.dart';
import 'package:food_delivery_app/models/menu_item.dart';

class SearchService {
  final List<Restaurant> _allRestaurants = [
    Restaurant(
      id: 'r1',
      name: 'Sate Padang Mak Ciak',
      cuisineType: 'Indonesian',
      rating: 4.9,
      tier: 'Top Tier',
      imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=1974',
      menu: [
        MenuItem(id: 'm1', name: 'Sate Padang Daging', price: 28000, imageUrl: ''),
        MenuItem(id: 'm2', name: 'Kerupuk Kulit', price: 5000, imageUrl: ''),
      ],
      deliveryTime: '25-35 min',
      deliveryFee: 4000,
    ),
    Restaurant(
      id: 'r2',
      name: 'Nasi Goreng Mantap',
      cuisineType: 'Indonesian',
      rating: 4.8,
      tier: 'Top Tier',
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=500&q=80',
      menu: [
        MenuItem(id: 'm4', name: 'Nasi Goreng Spesial', price: 35000, imageUrl: ''),
        MenuItem(id: 'm6', name: 'Es Teh Manis', price: 8000, imageUrl: ''),
      ],
      deliveryTime: '15-25 min',
      deliveryFee: 4000,
    ),
    Restaurant(
      id: 'r4',
      name: 'Burger King',
      cuisineType: 'Western',
      rating: 4.5,
      tier: 'Top Tier',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80',
      menu: [
        MenuItem(id: 'm9', name: 'Classic Beef Burger', price: 75000, imageUrl: ''),
        MenuItem(id: 'm10', name: 'French Fries', price: 30000, imageUrl: ''),
      ],
      deliveryTime: '10-20 min',
      deliveryFee: 4000,
    ),
     Restaurant(
      id: 'r4',
      name: 'Burger King',
      cuisineType: 'Western',
      rating: 4.5,
      tier: 'Top Tier',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80',
      menu: [
        MenuItem(id: 'm9', name: 'Classic Beef Burger', price: 75000, imageUrl: ''),
        MenuItem(id: 'm10', name: 'French Fries', price: 30000, imageUrl: ''),
      ],
      deliveryTime: '10-20 min',
      deliveryFee: 4000,
    ),
  ];

  Future<List<Restaurant>> getTopTierRestaurants() async {
    await Future.delayed(const Duration(seconds: 1));
    return _allRestaurants;
  }
  
  Future<List<Restaurant>> searchRestaurants(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.isEmpty) {
      return [];
    }

    final lowerCaseQuery = query.toLowerCase();
    
    final results = _allRestaurants
        .where((restaurant) =>
            restaurant.name.toLowerCase().contains(lowerCaseQuery) ||
            restaurant.cuisineType.toLowerCase().contains(lowerCaseQuery))
        .toList();
        
    return results;
  }
  
  Restaurant? getRestaurantByName(String name) {
    try {
      return _allRestaurants.firstWhere(
        (restaurant) => restaurant.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null; 
    }
  }
}