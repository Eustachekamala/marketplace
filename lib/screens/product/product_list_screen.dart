import 'package:flutter/material.dart';
import 'package:marketplace_supabase/screens/product/add_product_screen.dart';
import 'package:marketplace_supabase/services/auth_service.dart';
import 'package:marketplace_supabase/services/product_service.dart';
import 'package:marketplace_supabase/widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
               AuthService().signOut();
               ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Signed out successfully')));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: ProductService().streamProducts(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data;
          if (products == null || products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ProductCard(product: products[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddProductScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ]
      ),
    );
  }
}