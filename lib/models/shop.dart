import 'package:uuid/uuid.dart';

class Shop {
  final String uid = Uuid().v4();
  final String ownerId;
  final String shopIntro;
  final String shopDesc;
  final String bannerImagePath;
  final String category;
  final List<String> skills;

  Shop({
    required this.ownerId,
    required this.shopIntro,
    required this.shopDesc,
    required this.bannerImagePath,
    required this.category,
    required this.skills,
  });
}
