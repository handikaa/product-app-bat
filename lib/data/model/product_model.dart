import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:product_bat/domain/entities/product_entity.dart';

class ProductModel extends Equatable {
  final int? id;
  final String? title;
  final double? price;
  final String? description;
  final String? category;
  final String? image;
  final RatingModel? rating;

  const ProductModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    title: json["title"],
    price: json["price"]?.toDouble(),
    description: json["description"],
    category: json["category"],
    image: json["image"],
    rating: json["rating"] == null
        ? null
        : RatingModel.fromJson(json["rating"]),
  );

  ProductEntity toEntity() => ProductEntity(
    id: id ?? 0,
    title: title ?? '',
    price: price ?? 0,
    description: description ?? '',
    category: category ?? '',
    image: image ?? '',
    ratingEntity: rating?.toEntity() ?? RatingEntity(rate: 0, count: 0),
  );

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    category,
    image,
    rating,
  ];
}

class RatingModel extends Equatable {
  final double? rate;
  final int? count;

  RatingModel({this.rate, this.count});

  factory RatingModel.fromRawJson(String str) =>
      RatingModel.fromJson(json.decode(str));

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      RatingModel(rate: json["rate"]?.toDouble(), count: json["count"]);

  RatingEntity toEntity() => RatingEntity(rate: rate ?? 0, count: count ?? 0);

  @override
  List<Object?> get props => [rate, count];
}
