import 'package:flutter/material.dart';
import '../models/service.dart';

class ServiceTile extends StatelessWidget {
  final Service service;
  const ServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(service.title),
        subtitle: Text('${service.category} • \$${service.price} • ⭐ ${service.rating}'),
        leading: Icon(Icons.work_outline),
      ),
    );
  }
}