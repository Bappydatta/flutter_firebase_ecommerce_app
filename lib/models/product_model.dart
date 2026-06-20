class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String image;
  final String description; // ✅ NEW

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
    required this.description,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      category: map['category'],
      image: map['image'],
      description: map['description'] ?? '', // SAFE
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'image': image,
      'description': description,
    };
  }
}
