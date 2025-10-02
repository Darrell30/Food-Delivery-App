import 'package:json_annotation/json_annotation.dart';
import 'menu_item.dart'; 

part 'restaurant.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant {
  final String id;
  final String name;
  final String cuisineType;
  final double rating;
  final String tier;
  final String imageUrl;
  final List<MenuItem> menu;
  final bool isFeatured;
  final bool hasDiscount;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisineType,
    required this.rating,
    required this.tier,
    required this.imageUrl,
    required this.menu, required String deliveryTime, required int deliveryFee,
    this.isFeatured = false,
    this.hasDiscount = false,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);

  get deliveryTime => 15;

  get deliveryFee => 0;
  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}