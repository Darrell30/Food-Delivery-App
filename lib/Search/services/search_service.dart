import 'dart:async';
import '../models/restaurant.dart';

class SearchService {
  Future<List<Restaurant>> searchRestaurants(String query) async {

    final List<Map<String, dynamic>> dummyData = [
      {'id': '1', 'name': 'Burger Queen', 'cuisineType': 'Western', 'rating': 4.5, 'latitude': -6.2088, 'longitude': 106.8456, 'tier': 'top'},
      {'id': '2', 'name': 'Nasi Goreng Mantap', 'cuisineType': 'Indonesian', 'rating': 4.8, 'latitude': -6.2208, 'longitude': 106.8488, 'tier': 'top'},
      {'id': '3', 'name': 'Sate Padang Mak Ciak', 'cuisineType': 'Indonesian', 'rating': 4.9, 'latitude': -6.2150, 'longitude': 106.8350, 'tier': 'top'},
      {'id': '4', 'name': 'Taco Bell', 'cuisineType': 'Mexican', 'rating': 4.2, 'latitude': -6.2250, 'longitude': 106.8500, 'tier': 'standard'},
      {'id': '5', 'name': 'Martabak Orins', 'cuisineType': 'Street Food', 'rating': 4.7, 'latitude': -6.2100, 'longitude': 106.8400, 'tier': 'top'},
      {'id': '6', 'name': 'Kebab Turki Baba Rafi', 'cuisineType': 'Turkish', 'rating': 4.6, 'latitude': -6.2120, 'longitude': 106.8420, 'tier': 'standard'},
    ];

    List<Restaurant> restaurants = dummyData.map((json) => Restaurant.fromJson(json)).toList();

    return restaurants
        .where((restaurant) =>
            restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.cuisineType.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Metode baru untuk mendapatkan restoran top tier
  Future<List<Restaurant>> getTopTierRestaurants() async {
    final List<Map<String, dynamic>> dummyData = [
      {'id': '1', 'name': 'Burger Queen', 'cuisineType': 'Western', 'rating': 4.5, 'latitude': -6.2088, 'longitude': 106.8456, 'tier': 'top'},
      {'id': '2', 'name': 'Nasi Goreng Mantap', 'cuisineType': 'Indonesian', 'rating': 4.8, 'latitude': -6.2208, 'longitude': 106.8488, 'tier': 'top'},
      {'id': '3', 'name': 'Sate Padang Mak Ciak', 'cuisineType': 'Indonesian', 'rating': 4.9, 'latitude': -6.2150, 'longitude': 106.8350, 'tier': 'top'},
      {'id': '4', 'name': 'Taco Bell', 'cuisineType': 'Mexican', 'rating': 4.2, 'latitude': -6.2250, 'longitude': 106.8500, 'tier': 'standard'},
      {'id': '5', 'name': 'Martabak Orins', 'cuisineType': 'Street Food', 'rating': 4.7, 'latitude': -6.2100, 'longitude': 106.8400, 'tier': 'top'},
    ];

    List<Restaurant> restaurants = dummyData.map((json) => Restaurant.fromJson(json)).toList();

    return restaurants
        .where((r) => r.tier == 'top')
        .toList()
        ..sort((a, b) => b.rating.compareTo(a.rating));
  }
}