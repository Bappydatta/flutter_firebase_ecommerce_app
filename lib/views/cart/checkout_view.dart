import 'package:flutter/material.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

final OrderController _orderController = OrderController();
final CartController _cartController = CartController();

class CheckoutView extends StatefulWidget {
  final double totalAmount;

  const CheckoutView({super.key, required this.totalAmount});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String _paymentMethod = "Card";

  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();

  void _confirmPayment() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final order = AppOrder(
        userId: user.uid, // ✅ USER SEGREGATION
        totalAmount: widget.totalAmount,
        paymentMethod: _paymentMethod,
        items: List.from(_cartController.items),
      );

      await _orderController.createOrder(order);
      _cartController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total: TND ${widget.totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text(
              "Payment Method",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            RadioListTile(
              title: const Text("Card"),
              value: "Card",
              groupValue: _paymentMethod,
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
            RadioListTile(
              title: const Text("Cash on Delivery"),
              value: "Cash",
              groupValue: _paymentMethod,
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),

            if (_paymentMethod == "Card") ...[
              const SizedBox(height: 20),
              TextField(
                controller: _cardController,
                decoration: const InputDecoration(labelText: "Card Number"),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      decoration: const InputDecoration(labelText: "MM/YY"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _cvcController,
                      decoration: const InputDecoration(labelText: "CVC"),
                    ),
                  ),
                ],
              ),
            ],

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _confirmPayment,
                child: const Text(
                  "Confirm Payment",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
