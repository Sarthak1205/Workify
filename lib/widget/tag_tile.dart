import 'package:flutter/material.dart';
import 'package:workify/models/tag.dart';
import 'package:workify/pages/shop_by_tag.dart';

class TagTile extends StatelessWidget {
  final Tag tag;
  const TagTile({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShopByTag(tag: tag.categoryName)));
      },
      child: ListTile(
        leading: Image.asset(tag.imagePath, width: 40, height: 40),
        title: Text(tag.categoryName),
      ),
    );
  }
}
