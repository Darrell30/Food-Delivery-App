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

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisineType,
    required this.rating,
    required this.tier,
    required this.imageUrl,
    required this.menu, required String deliveryTime, required int deliveryFee,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);

  get deliveryTime => null;

  get deliveryFee => null;
  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}