import 'package:flutter/material.dart';

import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = "Phones";
  String _selectedImage = "assets/images/phone.png";

  final List<String> _categories = ["Phones", "Computers", "Wearables"];

  final List<String> _images = [
    "assets/images/phone.png",
    "assets/images/redminote11.png",
    "assets/images/laptop.png",
    "assets/images/laptopdell.png",
    "assets/images/watch.png",
    "assets/images/watchsony.png",
  ];

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: '',
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text),
      category: _selectedCategory,
      image: _selectedImage,
      description: _descriptionController.text.trim(),
    );

    await _productController.addProduct(product);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added successfully")),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 🔹 Product name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Product Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 12),

              // 🔹 Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price (TND)"),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 12),

              // 🔹 Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() {
                  _selectedCategory = v!;
                }),
                decoration: const InputDecoration(labelText: "Category"),
              ),

              const SizedBox(height: 20),

              // 🔹 description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),

              // 🔹 Image selector label
              const Text(
                "Select Image",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // 🔹 Image selector (ASSETS)
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    final img = _images[index];
                    final selected = img == _selectedImage;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = img;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selected ? Colors.blue : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          img,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProduct,
                  child: const Text("Add Product"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
