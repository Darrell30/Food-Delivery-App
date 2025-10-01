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
      tier: 'top',
      imageUrl: 'https://www.google.com/imgres?q=Sate%20padang%20mak%20ciak&imgurl=https%3A%2F%2Flookaside.fbsbx.com%2Flookaside%2Fcrawler%2Fmedia%2F%3Fmedia_id%3D100069547713098&imgrefurl=https%3A%2F%2Fwww.facebook.com%2Fmak.aciak87%2F&docid=-peARaN9MCrohM&tbnid=675w0mVf-LIHgM&vet=12ahUKEwiw2Kv1yIKQAxVp8jgGHcnPFfYQM3oECHkQAA..i&w=853&h=853&hcb=2&ved=2ahUKEwiw2Kv1yIKQAxVp8jgGHcnPFfYQM3oECHkQAA',
      menu: [
        MenuItem(id: 'm1', name: 'Sate Padang Daging', price: 28000, imageUrl: 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fgofood.co.id%2Fmedan%2Frestaurant%2Fsate-padang-mak-aciak-305ae521-5632-4cfc-b9d4-e7efbeb364dc&psig=AOvVaw3jXXd56KnfdlaSDxHpk8OP&ust=1759393298492000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCPD8xI_JgpADFQAAAAAdAAAAABAE'),
        MenuItem(id: 'm2', name: 'Kerupuk Kulit', price: 5000, imageUrl: 'https://www.google.com/imgres?q=kerupuk%20kulit&imgurl=https%3A%2F%2Fcdn0-production-images-kly.akamaized.net%2FlzhJi4AHq_vVUX2CAi_nvwa2YoE%3D%2F0x306%3A6240x3823%2F1200x675%2Ffilters%3Aquality(75)%3Astrip_icc()%3Aformat(jpeg)%2Fkly-media-production%2Fmedias%2F3764835%2Foriginal%2F080039900_1640058116-shutterstock_1820787197.jpg&imgrefurl=https%3A%2F%2Fwww.fimela.com%2Ffood%2Fread%2F4814760%2F5-cara-menggoreng-kerupuk-kulit-agar-mengembang-tidak-kempis&docid=Ik8K6DPLD6kVxM&tbnid=KetWhROqcSIc5M&vet=12ahUKEwjoptGbyYKQAxU72DgGHQI3BKEQM3oECFwQAA..i&w=1200&h=675&hcb=2&ved=2ahUKEwjoptGbyYKQAxU72DgGHQI3BKEQM3oECFwQAA'),
      ],
    ),
    Restaurant(
      id: 'r2',
      name: 'Nasi Goreng Mantap',
      cuisineType: 'Indonesian',
      rating: 4.8,
      tier: 'top',
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=500&q=80',
      menu: [
        MenuItem(id: 'm4', name: 'Nasi Goreng Spesial', price: 35000, imageUrl: 'https://www.google.com/imgres?q=nasi%20goreng%20spesial&imgurl=https%3A%2F%2Fasset.kompas.com%2Fcrops%2F3xYktcut3GtTLSvS9iNgqM4e380%3D%2F0x0%3A1000x667%2F1200x800%2Fdata%2Fphoto%2F2023%2F05%2F06%2F645677f368fc1.jpg&imgrefurl=https%3A%2F%2Fwww.kompas.com%2Ffood%2Fread%2F2023%2F05%2F08%2F080200675%2Fresep-nasi-goreng-spesial-hidangan-nasi-terenak-di-dunia-versi-cnn&docid=2AC1sDXm0smLnM&tbnid=pA8ft_gHnl_c4M&vet=12ahUKEwjs-e2pyYKQAxU9zjgGHe_RLecQM3oECBgQAA..i&w=1200&h=800&hcb=2&ved=2ahUKEwjs-e2pyYKQAxU9zjgGHe_RLecQM3oECBgQAA'),
        MenuItem(id: 'm6', name: 'Es Teh Manis', price: 8000, imageUrl: 'https://www.google.com/imgres?q=es%20teh%20manis&imgurl=https%3A%2F%2Fd1vbn70lmn1nqe.cloudfront.net%2Fprod%2Fwp-content%2Fuploads%2F2021%2F06%2F15093247%2FKetahui-Fakta-Es-Teh-Manis.jpg&imgrefurl=https%3A%2F%2Fwww.halodoc.com%2Fartikel%2Fminuman-menyegarkan-kenali-fakta-tentang-es-teh-manis%3Fsrsltid%3DAfmBOooYMef0vJjs0Qs1ixmurhz8fFFVf3PUY61g78qJwnEgWydFjDOm&docid=vMRcFpyxYjkfWM&tbnid=LlBoXaLasUVUkM&vet=12ahUKEwj9s4OzyYKQAxUkumMGHRRhIEwQM3oECCIQAA..i&w=702&h=465&hcb=2&ved=2ahUKEwj9s4OzyYKQAxUkumMGHRRhIEwQM3oECCIQAA'),
      ],
    ),
    Restaurant(
      id: 'r4',
      name: 'Burger King',
      cuisineType: 'Western',
      rating: 4.5,
      tier: 'top',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80',
      menu: [
         MenuItem(id: 'm9', name: 'Classic Beef Burger', price: 75000, imageUrl: 'https://www.google.com/imgres?q=classic%20beef%20burger&imgurl=https%3A%2F%2Fwww.appetitemag.co.uk%2Fwp-content%2Fuploads%2F2017%2F09%2FButcherBurger.jpg.webp&imgrefurl=https%3A%2F%2Fwww.appetitemag.co.uk%2Fclassic-beef-burgers-with-cheese%2F&docid=zDvbQHVQK0RIbM&tbnid=fX4TwdmKyuR80M&vet=12ahUKEwjr3Ky_yYKQAxWIzjgGHXocNzwQM3oFCIwBEAA..i&w=785&h=500&hcb=2&ved=2ahUKEwjr3Ky_yYKQAxWIzjgGHXocNzwQM3oFCIwBEAA'),
         MenuItem(id: 'm10', name: 'French Fries', price: 30000, imageUrl: 'https://www.google.com/imgres?q=french%20fries&imgurl=https%3A%2F%2Fimages.themodernproper.com%2Fproduction%2Fposts%2F2022%2FHomemade-French-Fries_8.jpg%3Fw%3D1200%26h%3D1200%26q%3D60%26fm%3Djpg%26fit%3Dcrop%26dm%3D1662474181%26s%3D15046582e76b761a200998df2dcad0fd&imgrefurl=https%3A%2F%2Fthemodernproper.com%2Fhomemade-french-fries&docid=wYNqYf38tjrhJM&tbnid=2LEfB4OrAidHOM&vet=12ahUKEwiB3dnGyYKQAxXd4TgGHV8UFFoQM3oECB0QAA..i&w=1200&h=1200&hcb=2&ved=2ahUKEwiB3dnGyYKQAxXd4TgGHV8UFFoQM3oECB0QAA'),
      ],
    ),
  ];

  Future<List<Restaurant>> getTopTierRestaurants() async {
    await Future.delayed(const Duration(seconds: 1));
    return _allRestaurants;
  }
  
  Future<List<Restaurant>> searchRestaurants(String query) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulasi jeda pencarian

    if (query.isEmpty) {
      return [];
    }

    final lowerCaseQuery = query.toLowerCase();

    // Logika untuk memfilter daftar restoran
    final results = _allRestaurants
        .where((restaurant) =>
            restaurant.name.toLowerCase().contains(lowerCaseQuery) ||
            restaurant.cuisineType.toLowerCase().contains(lowerCaseQuery))
        .toList();
        
    return results;
  }
}