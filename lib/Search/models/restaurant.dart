import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant {
  final String id;
  final String name;
  final String cuisineType;
  final double rating;
  final String tier;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisineType,
    required this.rating,
    required this.tier,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}