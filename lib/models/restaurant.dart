import 'package:json_annotation/json_annotation.dart';
import 'menu_item.dart'; 

part 'restaurant.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final String cuisineType;
  final double rating;
  final String deliveryTime;
  final double deliveryFee;
  final String tier;
  final List<MenuItem> menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cuisineType,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.tier,
    required this.menu,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}