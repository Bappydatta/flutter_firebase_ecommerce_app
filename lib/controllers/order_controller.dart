import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order_model.dart';

class OrderController {
  final CollectionReference _ordersRef =
      FirebaseFirestore.instance.collection('orders');

  // 🔹 Create order
  Future<void> createOrder(AppOrder order) async {
    await _ordersRef.add(order.toMap());
  }

  // 🔹 Get orders for CURRENT USER ONLY
  Stream<QuerySnapshot> getUserOrders() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _ordersRef
  .where('userId', isEqualTo: user.uid)
  .snapshots();
  }
}
