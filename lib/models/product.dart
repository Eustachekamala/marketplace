import 'package:marketplace_supabase/main.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String? description;
  final String? imageUrl;
  final String userId;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl, required this.userId, required this.createdAt,
  });

  // Convert a map to a Product object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      description: map['description'] as String?,
      imageUrl: map['imageUrl'] as String?,
      userId: map['userId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Convert the Product object to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'user_id': supabase.auth.currentUser!.id,
    };
  }

  // check the owner
  bool get isOwner => userId == supabase.auth.currentUser!.id;
}