import 'dart:io';

import 'package:flutter/material.dart';
import 'package:marketplace_supabase/main.dart';
import 'package:marketplace_supabase/services/storage_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  void _pickImage() async {
    final file = await StorageServices().pickImage();
    if (file != null) setState(() => _imageFile = file);
  }

  void _submit() async {
    if (_name.text.isEmpty || _price.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and price are required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // insert product
      final response = await supabase
          .from('products')
          .insert({
            'name': _name.text.trim(),
            'price': double.parse(_price.text.trim()),
            'description': _description.text.trim(),
            'user_id': supabase.auth.currentUser!.id,
          })
          .select()
          .single();

      final productId = response['id'] as String;

      // upload image if selected
      if (_imageFile != null) {
        final imageUrl = await StorageServices().uploadImage(
          _imageFile!,
          productId,
        );

        // update product with image URL
        await supabase
            .from('products')
            .update({'image_url': imageUrl})
            .eq('id', productId);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_imageFile!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 48),
                          SizedBox(height: 8),
                          Text('Tap to add image'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Name
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Price
            TextField(
              controller: _price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _description,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('List Product'),
            ),
          ],
        ),
      ),
    );
  }
}
