import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item_model.dart';

class AppOrder {
  final String userId;
  final double totalAmount;
  final String paymentMethod;
  final List<CartItem> items;

  AppOrder({
    required this.userId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'createdAt': FieldValue.serverTimestamp(),
      'items': items.map((item) {
        return {
          'productId': item.product.id,
          'name': item.product.name,
          'price': item.product.price,
          'quantity': item.quantity,
        };
      }).toList(),
    };
  }
}
