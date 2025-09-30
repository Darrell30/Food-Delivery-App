import '../../models/restaurant.dart';
import '../../models/menu_item.dart';

class SearchService {
  // Database dummy kita untuk semua restoran
  final List<Restaurant> _allRestaurants = [
    Restaurant(
      id: 'r1',
      name: 'Sate Padang Mak Ciak',
      cuisineType: 'Indonesian',
      rating: 4.9,
      tier: 'Top Tier',
      menu: [
        MenuItem(id: 'm1', name: 'Sate Padang', price: 25000, imageUrl: 'https://via.placeholder.com/150'),
        MenuItem(id: 'm2', name: 'Kerupuk Kulit', price: 5000, imageUrl: 'https://via.placeholder.com/150'),
      ],
    ),
    Restaurant(
      id: 'r2',
      name: 'Nasi Goreng Mantap',
      cuisineType: 'Indonesian',
      rating: 4.8,
      tier: 'Top Tier',
      menu: [
        MenuItem(id: 'm3', name: 'Nasi Goreng Spesial', price: 30000, imageUrl: 'https://via.placeholder.com/150'),
      ],
    ),
    Restaurant(
      id: 'r3',
      name: 'Martabak Orins',
      cuisineType: 'Street Food',
      rating: 4.7,
      tier: 'Top Tier',
      menu: [],
    ),
    Restaurant(
      id: 'r4',
      name: 'Burger Queen',
      cuisineType: 'Western',
      rating: 4.5,
      tier: 'Top Tier',
      menu: [
         MenuItem(id: 'm4', name: 'Beef Burger', price: 45000, imageUrl: 'https://via.placeholder.com/150'),
         MenuItem(id: 'm5', name: 'Fries', price: 20000, imageUrl: 'https://via.placeholder.com/150'),
      ],
    ),
  ];

  // Fungsi ini dipanggil saat halaman Search pertama kali dibuka
  Future<List<Restaurant>> getTopTierRestaurants() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading
    return _allRestaurants.where((r) => r.tier == 'Top Tier').toList();
  }

  // Fungsi ini dipanggil saat pengguna melakukan pencarian
  Future<List<Restaurant>> searchRestaurants(String query) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi loading
    
    if (query.isEmpty) {
      return []; // <-- KEMBALIKAN DAFTAR KOSONG, BUKAN NULL
    }

    final lowerCaseQuery = query.toLowerCase();
    final results = _allRestaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(lowerCaseQuery);
    }).toList();

    return results; // <-- Ini akan menjadi daftar kosong [] jika tidak ada hasil
  }
}