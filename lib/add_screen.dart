import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _uploadProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _image == null) return;

    final imageBytes = await _image!.readAsBytes();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final imageUrl = await Supabase.instance.client.storage
        .from('product-images')
        .uploadBinary('images/$fileName.jpg', imageBytes);

    final publicUrl = Supabase.instance.client.storage
        .from('product-images')
        .getPublicUrl('images/$fileName.jpg');

    await Supabase.instance.client.from('products').insert({
      'name': _nameController.text,
      'price': double.parse(_priceController.text),
      'image_url': publicUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Added')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Product Name')),
            TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price')),
            const SizedBox(height: 10),
            ElevatedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.image), label: const Text('Pick Image')),
            const SizedBox(height: 10),
            _image != null ? Image.file(_image!, height: 100) : const SizedBox(),
            const Spacer(),
            ElevatedButton(onPressed: _uploadProduct, child: const Text('Add Product')),
          ],
        ),
      ),
    );
  }
}
