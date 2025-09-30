import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/restaurant.dart';
import 'package:food_delivery_app/Search/services/search_service.dart';
import 'package:food_delivery_app/widgets/restaurant_card.dart';

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

  final List<String> _categories = [
    'Pizza', 'Burgers', 'Sushi', 'Dessert', 'Coffee', 'Healthy'
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialResults();
    _searchController.addListener(() => setState(() {}));
  }
  
  void _loadInitialResults() async {
    setState(() => _isLoading = true);
    try {
      final results = await _searchService.getTopTierRestaurants();
      if (!mounted) return;
      setState(() => _searchResults = results);
    } catch (e) {
      _showError('Failed to load popular restaurants.');
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _onSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      final results = await _searchService.searchRestaurants(query);
      if (!mounted) return;
      setState(() => _searchResults = results);
    } catch (e) {
      _showError('Failed to perform search.');
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchBar(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBodyContent(),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: _onSearch,
        decoration: InputDecoration(
          hintText: 'Search restaurants or food...',
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _loadInitialResults();
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    // If the search bar is empty, show the initial layout
    if (_searchController.text.isEmpty && !_isLoading) {
      return ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Top Categories'),
          const SizedBox(height: 12),
          _buildCategoriesGrid(),
          const SizedBox(height: 24),
          _buildSectionTitle('Popular Near You'),
          const SizedBox(height: 12),
          // We call the same results list builder here
          _buildResultsList(),
        ],
      );
    } else {
      // Otherwise, show only the search results
      return _buildResultsList();
    }
  }

  Widget _buildCategoriesGrid() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _categories.map((category) {
        return ActionChip(
          label: Text(category),
          onPressed: () {
            _searchController.text = category;
            _onSearch(category);
          },
        );
      }).toList(),
    );
  }

  Widget _buildResultsList() {
    if (_searchResults.isEmpty) {
      return const Center(child: Text('No results found.'));
    }
    // ✅ --- THE FIX IS APPLIED HERE --- ✅
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      // These two lines solve the nested scrolling error
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // ---
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final restaurant = _searchResults[index];
        return RestaurantCard(restaurant: restaurant);
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}