import 'package:flutter/material.dart';

class PickUpScreen extends StatelessWidget {
  const PickUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Dummy data restoran
    final restaurants = [
      {
        "name": "Burger King",
        "address": "Jl. Sudirman No. 45, Jakarta",
        "distance": "200 m",
        "image": "https://picsum.photos/200/100?1"
      },
      {
        "name": "Pizza Hut",
        "address": "Jl. Thamrin No. 22, Jakarta",
        "distance": "450 m",
        "image": "https://picsum.photos/200/100?2"
      },
      {
        "name": "KFC",
        "address": "Jl. MH Thamrin No. 99, Jakarta",
        "distance": "800 m",
        "image": "https://picsum.photos/200/100?3"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Pick Up",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final r = restaurants[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // 📸 Gambar restoran
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.network(
                    r["image"]!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),

                // 📑 Info restoran
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r["name"]!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r["address"]!,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.red),
                            const SizedBox(width: 4),
                            Text(
                              r["distance"]!,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ➡️ Tombol ambil
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Pickup di ${r["name"]} berhasil!"),
                        ),
                      );
                    },
                    child: const Text("Pick Up"),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
