// lib/services/search_service.dart
import 'dart:async';
import '../models/restaurant.dart';

class SearchService {
  Future<List<Restaurant>> searchRestaurants(String query) async {
    await Future.delayed(const Duration(seconds: 1));

    final List<Restaurant> dummyData = [
      Restaurant(id: '1', name: 'Burger Queen', cuisineType: 'Western', rating: 4.5),
      Restaurant(id: '2', name: 'Nasi Goreng Mantap', cuisineType: 'Indonesian', rating: 4.8),
      Restaurant(id: '3', name: 'Sate Padang Mak Ciak', cuisineType: 'Indonesian', rating: 4.9),
      Restaurant(id: '4', name: 'Taco Bell', cuisineType: 'Mexican', rating: 4.2),
      Restaurant(id: '5', name: 'Martabak Orins', cuisineType: 'Street Food', rating: 4.7),
    ];

    if (query.isEmpty) {
      return [];
    }
    
    return dummyData
        .where((restaurant) =>
            restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.cuisineType.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}