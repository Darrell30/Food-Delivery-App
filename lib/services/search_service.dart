import 'dart:async';
import 'package:food_delivery_app/models/restaurant.dart';
import 'package:food_delivery_app/models/menu_item.dart';

class SearchService {
  final List<Restaurant> _allRestaurants = [
    Restaurant(
      id: 'r1',
      name: 'Sate Padang Mak Ciak',
      cuisineType: 'Indonesian',
      isFeatured: true,
      rating: 4.9,
      tier: 'Top Tier',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSO9zO42EsCYJcZcWrB--PyiUElAeN7Qq6ogQ&s',
      menu: [
        MenuItem(
            id: 'm1',
            name: 'Sate Padang Daging',
            price: 28000,
            imageUrl:
                'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/ad7a12cb-2783-4e6c-838a-0f0f49c418b5_Go-Biz_20210915_223207.jpeg'),
        MenuItem(
            id: 'm2',
            name: 'Kerupuk Kulit',
            price: 5000,
            imageUrl:
                'https://i0.wp.com/halalmui.org/wp-content/uploads/2022/09/2022-09-01-Kerupuk-Kulit-Kenali-Bahaya-dan-Potensi-Haramnya.jpg'),
      ],
      deliveryTime: '25-35 min',
      deliveryFee: 4000,
    ),
    Restaurant(
      id: 'r2',
      name: 'Nasi Goreng Mantap',
      cuisineType: 'Indonesian',
      hasDiscount: true,
      rating: 4.8,
      tier: 'Top Tier',
      imageUrl:
          'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=500&q=80',
      menu: [
        MenuItem(
            id: 'm4',
            name: 'Nasi Goreng Spesial',
            price: 35000,
            imageUrl:
                'https://blue.kumparan.com/image/upload/fl_progressive,fl_lossy,c_fill,f_auto,q_auto:best,w_640/v1609516996/bi21rvb0ralsympgks14.jpg'),
        MenuItem(
            id: 'm6',
            name: 'Es Teh Manis',
            price: 8000,
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQRFexYu0ilo7doTTlBKs-7Q-CEHn5wrJybg&s'),
      ],
      deliveryTime: '15-25 min',
      deliveryFee: 4000,
    ),
    Restaurant(
      id: 'r4',
      name: 'Burger King',
      isFeatured: true,
      cuisineType: 'Western',
      rating: 4.5,
      tier: 'Top Tier',
      imageUrl:
          'https://www.allrecipes.com/thmb/zkbaCZ-jqfW3CuqHWt6RgyjKe90=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/AR-burger-king-logo-2x1-36f974748d87434b9a2976adbc4e26aa.jpg',
      menu: [
        MenuItem(
            id: 'm9',
            name: 'Classic Beef Burger',
            price: 75000,
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqBoSEDVIHwp_nLqWjsWUmxBUckJQjTPuJyw&s'),
        MenuItem(
            id: 'm10',
            name: 'French Fries',
            price: 30000,
            imageUrl:
                'https://images.themodernproper.com/production/posts/2022/Homemade-French-Fries_8.jpg?w=1200&h=1200&q=60&fm=jpg&fit=crop&dm=1662474181&s=15046582e76b761a200998df2dcad0fd'),
      ],
      deliveryTime: '10-20 min',
      deliveryFee: 4000,
    ),
    Restaurant(
      id: 'r5',
      name: 'Seven Eleven',
      isFeatured: true,
      cuisineType: 'Western',
      rating: 4.7,
      tier: 'Top Tier',
      imageUrl:
          'https://t3.ftcdn.net/jpg/16/92/79/82/360_F_1692798230_n53kBhhGqsJfifyyVedHP0SiA9Jlpmay.jpg',
      menu: [
        MenuItem(
            id: 'm11',
            name: 'Onigiri',
            price: 20000,
            imageUrl:
                'https://brokebankvegan.com/wp-content/uploads/2023/01/Onigiri-23.jpg'),
        MenuItem(
            id: 'm12',
            name: 'Samyang',
            price: 30000,
            imageUrl:
                'https://yoona.id/wp-content/uploads/2023/02/kalori-samyang.jpg'),
        MenuItem(
            id: 'm13',
            name: 'Sandwich',
            price: 36000,
            imageUrl:
                'https://www.southernliving.com/thmb/UW4kKKL-_M3WgP7pkL6Pb6lwcgM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Ham_Sandwich_011-1-49227336bc074513aaf8fdbde440eafe.jpg'),
        MenuItem(
            id: 'm14',
            name: 'Dumplings',
            price: 30000,
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh6MVdLO9VoRc5F2frJ8AVND5im-voq6r59g&s'),
        MenuItem(
            id: 'm15',
            name: 'Sausage',
            price: 21000,
            imageUrl:
                'https://www.rachelcooks.com/wp-content/uploads/2025/01/How-to-Cook-Breakfast-Sausage-Links014-web-square.jpg'),
        MenuItem(
            id: 'm16',
            name: 'Salad',
            price: 15000,
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR__tuaCCeBfBPjeM7l81rHzPBAeMrbfDIIIw&s'),
      ],
      deliveryTime: '10-15 min',
      deliveryFee: 5000,
    ),
    Restaurant(
      id: 'r6',
      name: 'Ramen House',
      hasDiscount: true,
      cuisineType: 'Japanese ',
      rating: 5.0,
      tier: 'Top Tier',
      imageUrl:
          'https://www.harapanrakyat.com/wp-content/uploads/2024/01/Yagami-Ramen-House-Sukabumi.jpg',
      menu: [
        MenuItem(
            id: 'm17',
            name: 'Tori Kara Ramen',
            price: 29000,
            imageUrl: 'https://i.ytimg.com/vi/cnxssFtBHHc/maxresdefault.jpg'),
        MenuItem(
            id: 'm18',
            name: 'Curry Katsu Rice',
            price: 29500,
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9zmqmHfd9rD6CFN-b8UrdV3G2fHvmmI1MiQ&s'),
        MenuItem(
            id: 'm19',
            name: 'Japanese Curry Ramen',
            price: 28000,
            imageUrl:
                'https://glebekitchen.com/wp-content/uploads/2020/11/currychickenramentopbowl.jpg'),
        MenuItem(
            id: 'm20',
            name: 'Karage Ramen',
            price: 29000,
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTerR7VkMGwYcGXLBtVYNpRj1Yy5A3WNYypXQ&s'),
        MenuItem(
            id: 'm21',
            name: 'Katsu Ramen',
            price: 29000,
            imageUrl:
                'https://jz-eats.com/wp-content/uploads/2023/06/chicken-katsu-ramen.png'),
        MenuItem(
            id: 'm22',
            name: 'Spicy Ramen  ',
            price: 28000,
            imageUrl:
                'https://dinnerthendessert.com/wp-content/uploads/2023/08/Spicy-Ramen-10.jpg'),
        MenuItem(
            id: 'm23',
            name: 'Basic Ramen  ',
            price: 23000,
            imageUrl: 'https://i.ytimg.com/vi/B8y3SSmz4sg/maxresdefault.jpg'),
        MenuItem(
            id: 'm24',
            name: 'Kare Ramen  ',
            price: 20000,
            imageUrl:
                'https://images.squarespace-cdn.com/content/v1/65e1de05b19d2c14209b89a3/d0529cb3-e6dd-492d-b1f8-849bd50abb96/oxtail-kare-kare.jpg'),
        MenuItem(
            id: 'm25',
            name: 'Gyoza  ',
            price: 18000,
            imageUrl:
                'https://buckets.sasa.co.id/v1/AUTH_Assets/Assets/p/website/medias/page_medias/chicken-gyoza.jpeg'),
      ],
      deliveryTime: '20-30 min',
      deliveryFee: 5000,
    ),
    Restaurant(
      id: 'r7',
      name: 'Sushi Tei',
      hasDiscount: true,
      cuisineType: 'Japanese ',
      rating: 4.8,
      tier: 'Top Tier',
      imageUrl:
          'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/2b551767-9518-44e9-b158-6fb06b149890_restaurant-image_1674444263470.jpg?auto=format',
      menu: [
        MenuItem(
            id: 'm26',
            name: 'Sushi Roll',
            price: 30000,
            imageUrl:
                'https://media-cdn.tripadvisor.com/media/photo-s/02/10/44/16/sushi-tei.jpg'),
        MenuItem(
            id: 'm27',
            name: 'Sashimi',
            price: 21500,
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmRyxvh10RHeZkwSMiHLOT7qGXBMaXPsWhZA&s'),
        MenuItem(
            id: 'm28',
            name: 'Onigiri',
            price: 34000,
            imageUrl:
                'https://www.dapurkobe.co.id/wp-content/uploads/onigiri-ayam-suwir-bumbu-bebek.jpg'),
        MenuItem(
            id: 'm29',
            name: 'Special Roll',
            price: 35000,
            imageUrl:
                'https://www.wasabiko.com/wp-content/uploads/2023/02/Wasabiko-Sushi-Poke-Manassas-Virginia-Web-Menu-Header-SpecialRoll.jpg'),
        MenuItem(
            id: 'm30',
            name: 'Teriyaki',
            price: 20000,
            imageUrl:
                'https://cdn.stoneline.de/media/7f/d5/7c/1728996917/chicken-teriyaki-mit-reis.jpeg?ts=1728996917'),
        MenuItem(
            id: 'm31',
            name: 'Soup Noodles  ',
            price: 28000,
            imageUrl:
                'https://www.recipetineats.com/tachyon/2016/06/Chinese-Noodle-Soup-SQ.jpg'),
      ],
      deliveryTime: '20-30 min',
      deliveryFee: 5000,
    ),
    Restaurant(
      id: 'r8',
      name: 'Sate Maranggi',
      isFeatured: true,
      cuisineType: 'Indonesian',
      rating: 5.0,
      tier: 'Top Tier',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfDiinV898T1PCFEBbwnKDLn-E3tO--m8cdQ&s',
      menu: [
        MenuItem(
            id: 'm32',
            name: 'Sate Maranggi',
            price: 36000,
            imageUrl:
                'https://assets.unileversolutions.com/recipes-v2/252568.png'),
        MenuItem(
            id: 'm33',
            name: 'Sate Kambing',
            price: 40000,
            imageUrl:
                'https://www.dapurkobe.co.id/wp-content/uploads/sate-kambing-bumbu-kecap.jpg'),
        MenuItem(
            id: 'm34',
            name: 'Sop Sapi',
            price: 25000,
            imageUrl:
                'https://www.unileverfoodsolutions.co.id/dam/global-ufs/mcos/SEA/calcmenu/recipes/ID-recipes/sop-daging-sapi-empuk-untuk-menu-family-friendly/header_2.jpg'),
        MenuItem(
            id: 'm35',
            name: 'Sop Kambing',
            price: 30000,
            imageUrl:
                'https://assets.unileversolutions.com/recipes-v2/258430.jpg'),
        MenuItem(
            id: 'm36',
            name: 'Nasi',
            price: 5000,
            imageUrl:
                'https://i0.wp.com/rsum.bandaacehkota.go.id/wp-content/uploads/2025/03/nasi.webp?fit=1068%2C561&ssl=1'),
        MenuItem(
            id: 'm37',
            name: 'Es Teh Tawar',
            price: 5000,
            imageUrl:
                'https://cdn.rri.co.id/berita/Surakarta/o/1721268027141-es_teh/tej3a2y7x45orm3.jpeg'),
      ],
      deliveryTime: '20-30 min',
      deliveryFee: 7500,
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

  Future<List<Restaurant>> getFeaturedRestaurants() async {
    await Future.delayed(const Duration(seconds: 1));
    return _allRestaurants
        .where((restaurant) => restaurant.isFeatured)
        .toList();
  }

  Future<List<Restaurant>> getDiskon() async {
    await Future.delayed(const Duration(seconds: 1));
    return _allRestaurants
        .where((restaurant) => restaurant.hasDiscount)
        .toList();
  }
}
