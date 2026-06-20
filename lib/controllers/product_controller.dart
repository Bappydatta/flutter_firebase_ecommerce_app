import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductController {
  final _productsRef =
      FirebaseFirestore.instance.collection('products');

  // 🔹 Real-time products
  Stream<List<Product>> getProducts() {
    return _productsRef.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  // 🔹 Add product (asset image path)
  Future<void> addProduct(Product product) async {
    await _productsRef.add(product.toMap());
  }

  // 🔹 Update product
  Future<void> updateProduct(Product product) async {
    await _productsRef.doc(product.id).update(product.toMap());
  }

  // 🔹 Delete product
  Future<void> deleteProduct(String productId) async {
    await _productsRef.doc(productId).delete();
  }
}
