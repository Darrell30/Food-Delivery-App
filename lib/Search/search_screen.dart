import 'package:flutter/material.dart';
import 'models/restaurant.dart';
import 'services/search_service.dart';
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
  final bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadInitialResults();
    _searchController.addListener(_onSearchChanged);
  }
  
  void _loadInitialResults() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final results = await _searchService.getTopTierRestaurants();
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

  void _onSearchChanged() {
    setState(() {
    });
  }

  void _onSearch(String query) async {
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
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
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