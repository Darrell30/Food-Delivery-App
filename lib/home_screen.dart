import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.account_circle, color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "DELIVERING TO",
              style: TextStyle(fontSize: 12, color: Color.fromRGBO(39, 0, 197, 1)),
            ),
            Text(
              "1122 Street Ave",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.keyboard_arrow_down, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // 🔹 kategori (scroll horizontal)
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CategoryItem(icon: Icons.local_grocery_store, label: "Convenience"),
                CategoryItem(icon: Icons.fastfood, label: "Fast Food"),
                CategoryItem(icon: Icons.lunch_dining, label: "Burgers"),
                CategoryItem(icon: Icons.set_meal, label: "Chicken"),
                CategoryItem(icon: Icons.ramen_dining, label: "Asian"),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // 🔹 filter (scroll horizontal)
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterChip(label: const Text("Over 4.5 ★"), onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(label: const Text("Under 30 min"), onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(label: const Text("Pickup"), onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(label: const Text("Vegetarian"), onSelected: (_) {}),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // 🔹 Banner promo
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                "No delivery fee\nTry DashPass FREE for 30 days",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 Section: Order Within Vicinity
          const SectionTitle(title: "Order Within Vicinity"),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(
                  child: ProductCard(
                      name: "Smart & Final",
                      subtitle: "47 min • \$3.99 delivery")),
              SizedBox(width: 10),
              Expanded(
                  child: ProductCard(
                      name: "7-Eleven", subtitle: "29 min • \$2.99 delivery")),
            ],
          ),
          const SizedBox(height: 20),

          // 🔹 Section: Special Offers
          const SectionTitle(title: "Special Offers for You"),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(
                  child: ProductCard(
                      name: "Ramen House", subtitle: "Free delivery")),
              SizedBox(width: 10),
              Expanded(
                  child: ProductCard(
                      name: "Sushi World", subtitle: "20% OFF")),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const Text("See All", style: TextStyle(color: Color.fromRGBO(39, 0, 197, 1))),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String subtitle;

  const ProductCard({super.key, required this.name, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: const Center(child: Icon(Icons.image, size: 40)),
              ),
            ),
            const SizedBox(height: 5),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}