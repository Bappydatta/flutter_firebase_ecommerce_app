import 'package:flutter/material.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../models/product_model.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;

  const ProductDetailsView({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsView> createState() =>
      _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final CartController _cartController = CartController();
  final WishlistController _wishlistController =
      WishlistController();

  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  // 🔹 Check if product is favorite
  void _loadFavorite() async {
    final fav =
        await _wishlistController.isFavorite(widget.product.id);
    if (mounted) {
      setState(() => _isFav = fav);
    }
  }

  // 🔹 Toggle favorite
  void _toggleFavorite() async {
    if (_isFav) {
      await _wishlistController.remove(widget.product.id);
    } else {
      await _wishlistController.add(widget.product);
    }
    _loadFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Product Image
          Container(
            height: height * 0.4,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              widget.product.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 60),
            ),
          ),

          // 🔹 Product Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "TND ${widget.product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),

                // 🔹 Description
                Text(
                  widget.product.description,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),

          const Spacer(),

          // 🔹 Add to Cart Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  _cartController.addProduct(widget.product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Added to cart")),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
