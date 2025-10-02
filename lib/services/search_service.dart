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
      imageUrl: 'https://www.allrecipes.com/thmb/zkbaCZ-jqfW3CuqHWt6RgyjKe90=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/AR-burger-king-logo-2x1-36f974748d87434b9a2976adbc4e26aa.jpg',
      menu: [
        MenuItem(id: 'm9', name: 'Classic Beef Burger', price: 75000, imageUrl: ''),
        MenuItem(id: 'm10', name: 'French Fries', price: 30000, imageUrl: ''),
      ],
      deliveryTime: '10-20 min',
      deliveryFee: 4000,
    ),
     Restaurant(
      id: 'r5',
      name: 'Seven Eleven',
      cuisineType: 'Western',
      rating: 4.7,
      tier: 'Top Tier',
      imageUrl: 'https://t3.ftcdn.net/jpg/16/92/79/82/360_F_1692798230_n53kBhhGqsJfifyyVedHP0SiA9Jlpmay.jpg',
      menu: [
        MenuItem(id: 'm11', name: 'Onigiri', price: 20000, imageUrl: ''),
        MenuItem(id: 'm12', name: 'Samyang', price: 30000, imageUrl: ''),
        MenuItem(id: 'm13', name: 'Sandwich', price: 36000, imageUrl: ''),
        MenuItem(id: 'm14', name: 'Samyang', price: 30000, imageUrl: ''),
        MenuItem(id: 'm15', name: 'Sasauge', price: 21000, imageUrl: ''),
        MenuItem(id: 'm16', name: 'Salad', price: 15000, imageUrl: ''),
      ],
      deliveryTime: '10-15 min',
      deliveryFee: 5000,
    ),
    Restaurant(
      id: 'r6',
      name: 'Ramen House',
      cuisineType: 'Japanese ',
      rating: 5.0,
      tier: 'Top Tier',
      imageUrl: 'https://www.harapanrakyat.com/wp-content/uploads/2024/01/Yagami-Ramen-House-Sukabumi.jpg',
      menu: [
        MenuItem(id: 'm17', name: 'Tori Kara Ramen', price: 29000, imageUrl: ''),
        MenuItem(id: 'm18', name: 'Curry Katsu Rice', price: 29500, imageUrl: ''),
        MenuItem(id: 'm19', name: 'Japanese Curry Ramen', price: 28000, imageUrl: ''),
        MenuItem(id: 'm20', name: 'Karage Ramen', price: 29000, imageUrl: ''),
        MenuItem(id: 'm21', name: 'Katsu Ramen', price: 29000, imageUrl: ''),
        MenuItem(id: 'm22', name: 'Spicy Ramen  ', price: 28000, imageUrl: ''),
        MenuItem(id: 'm22', name: 'Basic Ramen  ', price: 23000, imageUrl: ''),
        MenuItem(id: 'm23', name: 'Kare Ramen  ', price: 20000, imageUrl: ''),
        MenuItem(id: 'm24', name: 'Gyoza  ', price: 18000, imageUrl: ''),
      ],
      deliveryTime: '20-30 min',
      deliveryFee: 5000,
    ),
    Restaurant(
      id: 'r7',
      name: 'Sushi World',
      cuisineType: 'Japanese ',
      rating: 4.8,
      tier: 'Top Tier',
      imageUrl: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/2b551767-9518-44e9-b158-6fb06b149890_restaurant-image_1674444263470.jpg?auto=format',
      menu: [
        MenuItem(id: 'm25', name: 'Sushi Roll', price: 30000, imageUrl: ''),
        MenuItem(id: 'm26', name: 'Sashimi', price: 21500, imageUrl: ''),
        MenuItem(id: 'm27', name: 'Nigiri', price: 34000, imageUrl: ''),
        MenuItem(id: 'm28', name: 'Special Roll', price: 35000, imageUrl: ''),
        MenuItem(id: 'm29', name: 'Teriyaki', price: 20000, imageUrl: ''),
        MenuItem(id: 'm30', name: 'Soup Noodles  ', price: 28000, imageUrl: ''),
      ],
      deliveryTime: '20-30 min',
      deliveryFee: 5000,
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