import 'package:flutter/material.dart';
import 'package:workify/models/tag.dart';

class TagTile extends StatelessWidget {
  final Tag tag;
  const TagTile({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(tag.imagePath, width: 40, height: 40),
      title: Text(tag.categoryName),
    );
  }
}
