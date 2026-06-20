import 'package:flutter/material.dart';
import '../../controllers/wishlist_controller.dart';

class WishlistView extends StatelessWidget {
  WishlistView({super.key});

  final WishlistController _wishlistController = WishlistController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Wishlist")),
      body: FutureBuilder(
        future: _wishlistController.getAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return const Center(child: Text("Wishlist is empty"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  leading: Image.asset(item.image, width: 50),
                  title: Text(item.name),
                  subtitle: Text(
                    "TND ${item.price.toStringAsFixed(2)}",
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
