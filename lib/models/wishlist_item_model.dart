class WishlistItem {
  final String productId;
  final String name;
  final double price;
  final String image;

  WishlistItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'image': image,
    };
  }
}
