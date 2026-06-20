import 'package:flutter/material.dart';

import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';

class EditProductView extends StatefulWidget {
  final Product product;

  const EditProductView({super.key, required this.product});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final _formKey = GlobalKey<FormState>();
  final ProductController _controller = ProductController();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  late String _category;
  late String _image;

  final List<String> _categories = [
    "Phones",
    "Computers",
    "Wearables",
  ];

  final List<String> _images = [
    "assets/images/phone.png",
    "assets/images/redminote11.png",
    "assets/images/laptop.png",
    "assets/images/laptopdell.png",
    "assets/images/watch.png",
    "assets/images/watchsony.png",
  ];

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.product.name);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);

    _category = widget.product.category;
    _image = widget.product.image;
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = Product(
      id: widget.product.id,
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text),
      category: _category,
      image: _image,
      description: _descriptionController.text.trim(),
    );

    await _controller.updateProduct(updated);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: "Name"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: "Price"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField(
                value: _category,
                items: _categories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
                decoration:
                    const InputDecoration(labelText: "Category"),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),

              const SizedBox(height: 16),

              const Text("Image"),

              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    final img = _images[index];
                    final selected = img == _image;

                    return GestureDetector(
                      onTap: () => setState(() => _image = img),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selected
                                ? Colors.blue
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Image.asset(img, width: 70),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _save,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
