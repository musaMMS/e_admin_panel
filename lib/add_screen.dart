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
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _uploadProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all fields and pick an image')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      final imageBytes = await _image!.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload to Supabase Storage
      final storage = Supabase.instance.client.storage;
      await storage.from('pro-update').uploadBinary(fileName, imageBytes);

      // Get public URL
      final publicUrl = storage.from('pro-update').getPublicUrl(fileName);

      // Insert product into database
      await Supabase.instance.client.from('products').insert({
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'image_url': publicUrl,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Product added successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Upload Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price (৳)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
            ),
            const SizedBox(height: 10),
            _image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(_image!, height: 150),
            )
                : const Text('No image selected'),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              onPressed: _uploadProduct,
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
