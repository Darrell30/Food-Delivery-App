// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
  id: json['id'] as String,
  name: json['name'] as String,
  cuisineType: json['cuisineType'] as String,
  rating: (json['rating'] as num).toDouble(),
  tier: json['tier'] as String,
  menu: (json['menu'] as List<dynamic>)
      .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cuisineType': instance.cuisineType,
      'rating': instance.rating,
      'tier': instance.tier,
      'menu': instance.menu.map((e) => e.toJson()).toList(),
    };
