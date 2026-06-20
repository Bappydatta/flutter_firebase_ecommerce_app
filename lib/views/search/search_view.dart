import 'package:flutter/material.dart';

import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';
import '../home/product_details_view.dart';

enum SortOption {
  none,
  priceLowToHigh,
  priceHighToLow,
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final ProductController _productController = ProductController();

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  String _query = "";
  SortOption _sortOption = SortOption.none;

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  List<Product> _applyFilters(List<Product> products) {
    final minPrice = double.tryParse(_minPriceController.text);
    final maxPrice = double.tryParse(_maxPriceController.text);

    List<Product> filtered = products.where((product) {
      final matchesName =
          product.name.toLowerCase().contains(_query);

      final matchesMin =
          minPrice == null || product.price >= minPrice;

      final matchesMax =
          maxPrice == null || product.price <= maxPrice;

      return matchesName && matchesMin && matchesMax;
    }).toList();

    if (_sortOption == SortOption.priceLowToHigh) {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortOption == SortOption.priceHighToLow) {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // 🔍 Search bar
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _query = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search product",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 💰 Price filters
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minPriceController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: "Min price",
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _maxPriceController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: "Max price",
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ↕ Sort
              DropdownButtonFormField<SortOption>(
                value: _sortOption,
                decoration:
                    const InputDecoration(labelText: "Sort by"),
                items: const [
                  DropdownMenuItem(
                    value: SortOption.none,
                    child: Text("None"),
                  ),
                  DropdownMenuItem(
                    value: SortOption.priceLowToHigh,
                    child: Text("Cheapest first"),
                  ),
                  DropdownMenuItem(
                    value: SortOption.priceHighToLow,
                    child: Text("Most expensive first"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _sortOption = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // 🟦 Firestore products
              Expanded(
                child: StreamBuilder<List<Product>>(
                  stream: _productController.getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error loading products"),
                      );
                    }

                    final allProducts = snapshot.data ?? [];
                    final filteredProducts =
                        _applyFilters(allProducts);

                    if (filteredProducts.isEmpty) {
                      return const Center(
                        child: Text("No products found"),
                      );
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5 / 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return _productCard(
                          filteredProducts[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 SAME product card (images preserved)
  Widget _productCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProductDetailsView(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "TND ${product.price.toStringAsFixed(2)}",
                    style:
                        const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
