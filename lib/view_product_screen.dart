import 'package:e_admin_panel/product_card.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'add_screen.dart';
class ViewProductsScreen extends StatefulWidget {
  const ViewProductsScreen({super.key});

  @override
  State<ViewProductsScreen> createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
  List _products = [];

  Future<void> _loadProducts() async {
    final data = await Supabase.instance.client.from('products').select();
    setState(() => _products = data);
  }

  Future<void> _deleteProduct(int id) async {
    await Supabase.instance.client.from('products').delete().eq('id', id);
    _loadProducts();
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductScreen()));
          _loadProducts();
        },
        child: const Icon(Icons.add),
      ),
      body: _products.isEmpty
          ? const Center(child: Text('No Products'))
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ProductCard(
            product: product,
            onEdit: () {}, // Future: implement edit screen
            onDelete: () => _deleteProduct(product['id']),
          );
        },
      ),
    );
  }
}
