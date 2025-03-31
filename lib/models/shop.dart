import 'package:workify/models/shop_rating.dart';

class Shop {
  final String shopId;
  final String ownerId;
  final String shopIntro;
  final String shopDesc;
  final String bannerImagePath;
  final String shopCategory;
  final List<String> skills;
  ShopRating shopRating;

  Shop({
    required this.shopId,
    required this.ownerId,
    required this.shopIntro,
    required this.shopDesc,
    required this.bannerImagePath,
    required this.shopCategory,
    required this.skills,
    required this.shopRating,
  });

  Map<String, dynamic> toMap() {
    return {
      "shopId": shopId,
      "ownerId": ownerId,
      "shopIntro": shopIntro,
      "shopDesc": shopDesc,
      "bannerImagePath": bannerImagePath,
      "shopCategory": shopCategory,
      "skills": skills,
      "shopRating": shopRating.toMap(),
    };
  }

  factory Shop.fromMap(Map<String, dynamic> data) {
    return Shop(
      shopId: data["shopId"],
      ownerId: data["ownerId"],
      shopIntro: data["shopIntro"],
      shopDesc: data["shopDesc"],
      bannerImagePath: data["bannerImagePath"],
      shopCategory: data["shopCategory"],
      skills: List<String>.from(data["skills"] ?? []),
      shopRating: ShopRating.fromMap(data["shopRating"] ?? {}),
    );
  }
}
