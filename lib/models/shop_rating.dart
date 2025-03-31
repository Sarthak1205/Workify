import 'package:workify/models/rating.dart';

class ShopRating {
  int avgRating;
  int numOfReviews;
  List<Rating> reviewList;

  ShopRating({
    required this.avgRating,
    required this.numOfReviews,
    this.reviewList = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      "avgRating": avgRating,
      "numOfReviews": numOfReviews,
      "reviewList": reviewList.map((review) => review.toMap()).toList(),
    };
  }

  factory ShopRating.fromMap(Map<String, dynamic> data) {
    return ShopRating(
      avgRating: data["avgRating"] ?? 0,
      numOfReviews: data["numOfReviews"] ?? 0,
      reviewList: (data["reviewList"] as List<dynamic>?)
              ?.map((item) => Rating.fromMap(item))
              .toList() ??
          [],
    );
  }
}
