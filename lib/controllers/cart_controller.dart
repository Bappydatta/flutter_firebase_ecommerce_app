import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartController {
  static final CartController _instance = CartController._internal();
  CartController._internal();

  factory CartController() => _instance;

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addProduct(Product product) {
    final index =
        _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  void changeQuantity(Product product, int change) {
    final index =
        _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      final newQty = _items[index].quantity + change;
      if (newQty > 0) {
        _items[index].quantity = newQty;
      }
    }
  }

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  void clear() => _items.clear();
}
