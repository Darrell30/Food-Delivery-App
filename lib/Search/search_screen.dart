import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/search_service.dart';
import '../widgets/restaurant_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  List<Restaurant> _searchResults = [];
  bool _isLoading = false;

  void _onSearch(String query) async {
    if (query.isEmpty) {
      if (!mounted) return;
      setState(() {
        _searchResults = [];
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _searchService.searchRestaurants(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onSubmitted: _onSearch,
          decoration: const InputDecoration(
            hintText: 'Cari restoran atau menu...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(child: Text('Tidak ada hasil yang ditemukan.'))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final restaurant = _searchResults[index];
                    return RestaurantCard(restaurant: restaurant);
                  },
                ),
    );
  }
}