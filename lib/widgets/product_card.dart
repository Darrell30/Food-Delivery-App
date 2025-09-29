import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final double price;

  const ProductCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk dari assets
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 120,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              "Rp ${price.toStringAsFixed(0)}",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}