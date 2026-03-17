import 'package:marketplace_supabase/main.dart';
import 'package:marketplace_supabase/models/product.dart';

class ProductService {
  // Real time fetch products
  Stream<List<Product>> streamProducts() {
    return supabase
        .from('products')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((list) => list.map(Product.fromMap).toList());
  }

  // Create product
  Future<void> createProduct(Map<String, dynamic> data) {
    return supabase.from('products').insert(data);
  }

  // Update product
  Future<void> updateProduct(String id, Map<String, dynamic> data) {
    return supabase.from('products').update(data).eq('id', id);
  }

  // Delete product
  Future<void> deleteProduct(String id) {
    return supabase.from('products').delete().eq('id', id);
  }
}