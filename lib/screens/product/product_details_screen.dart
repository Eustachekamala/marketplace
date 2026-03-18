import 'package:flutter/material.dart';
import 'package:marketplace_supabase/models/product.dart';
import 'package:marketplace_supabase/services/product_service.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  void _delete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ProductService().deleteProduct(product.id);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          // Only show delete for owner
          if (product.isOwner)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (product.imageUrl != null)
              Image.network(
                product.imageUrl!,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  if (product.description != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      product.description!,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],

                  const SizedBox(height: 16),
                  Text(
                    'Listed ${product.createdAt.toLocal()}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),

                  // Buy button (for other users)
                  if (!product.isOwner) ...[
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Purchase flow coming soon!')),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Buy Now'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}