import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_supabase/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageServices {
  // we define the image picker
  final ImagePicker _picker = ImagePicker();

  // Pick image from the gallery
  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1080,
    );
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  //Upload File in the products bucket
  Future<String?> uploadImage(File file, String productId) async {
    final fileExt = file.path.split('.').last;
    final fileName = 'product_$productId.$fileExt';
    final filePath = 'products/$fileName';

    await supabase.storage
        .from('product-images')
        .upload(filePath, file, fileOptions: FileOptions(upsert: true));

    // get image url
    return supabase.storage.from('product-images').getPublicUrl(filePath);
  }

  // Delete image from products bucket
  Future<void> deleteProductImage(String productId) async {
    await supabase.storage
        .from('product-images')
        .remove(['products/product_$productId.*']);
    
  }
}