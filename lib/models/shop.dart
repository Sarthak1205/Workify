class Shop {
  final String shopId;
  final String ownerId;
  final String shopIntro;
  final String shopDesc;
  final String bannerImagePath;
  final String shopCategory;
  final int price;
  final List<Map<String, dynamic>> skills;

  Shop(
      {required this.shopId,
      required this.ownerId,
      required this.shopIntro,
      required this.shopDesc,
      required this.bannerImagePath,
      required this.shopCategory,
      required this.skills,
      required this.price});

  Map<String, dynamic> toMap() {
    return {
      "shopId": shopId,
      "ownerId": ownerId,
      "shopIntro": shopIntro,
      "shopDesc": shopDesc,
      "bannerImagePath": bannerImagePath,
      "shopCategory": shopCategory,
      "skills": skills,
      "prices": price
    };
  }

  factory Shop.fromMap(Map<String, dynamic> data) {
    return Shop(
      price: data["price"],
      shopId: data["shopId"],
      ownerId: data["ownerId"],
      shopIntro: data["shopIntro"],
      shopDesc: data["shopDesc"],
      bannerImagePath: data["bannerImagePath"],
      shopCategory: data["shopCategory"],
      skills: List<Map<String, dynamic>>.from(
        data["skills"] ?? [],
      ),
    );
  }
}
