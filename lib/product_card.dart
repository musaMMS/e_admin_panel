import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
class ProductCard extends StatelessWidget {
  final Map product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(imageUrl: product['image_url'], width: 60, fit: BoxFit.cover),
        ),
        title: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('৳${product['price'].toString()}'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
        ]),
      ),
    );
  }
}
