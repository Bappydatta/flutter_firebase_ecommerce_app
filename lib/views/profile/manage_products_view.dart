import 'package:flutter/material.dart';

import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';
import '../products/edit_product_view.dart';

class ManageProductsView extends StatelessWidget {
  const ManageProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = ProductController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Products"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Product>>(
        stream: controller.getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!;

          if (products.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                child: ListTile(
                  leading: Image.asset(
                    product.image,
                    width: 50,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image),
                  ),
                  title: Text(product.name),
                  subtitle: Text(
                    "TND ${product.price.toStringAsFixed(2)}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✏️ Edit
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditProductView(product: product),
                            ),
                          );
                        },
                      ),

                      // 🗑 Delete
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm =
                              await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete Product"),
                              content: const Text(
                                  "Are you sure you want to delete this product?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await controller.deleteProduct(product.id);
                          }
                        },
                      ),
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
