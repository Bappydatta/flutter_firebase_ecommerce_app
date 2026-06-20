import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controllers/order_controller.dart';

class OrdersHistoryView extends StatelessWidget {
  OrdersHistoryView({super.key});

  final OrderController _orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _orderController.getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("No orders found"));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data =
                  orders[index].data() as Map<String, dynamic>;

              final items =
                  List<Map<String, dynamic>>.from(data['items']);

              final Timestamp? ts = data['createdAt'];
              final date =
                  ts != null ? ts.toDate() : DateTime.now();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date: ${date.toLocal()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "Payment: ${data['paymentMethod']}"),
                      Text(
                        "Total: TND ${data['totalAmount']}",
                        style:
                            const TextStyle(color: Colors.blue),
                      ),
                      const Divider(),

                      ...items.map((item) => Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child:
                                      Text(item['name'])),
                              Text(
                                  "x${item['quantity']}"),
                            ],
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
