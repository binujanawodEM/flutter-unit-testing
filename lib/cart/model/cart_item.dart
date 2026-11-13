import 'package:counter_unit_test_demo/cart/model/product.dart';

/// A product and the quantity currently in the cart.
class CartItem {
  const CartItem({required this.product, required this.quantity})
    : assert(quantity > 0);

  final Product product;
  final int quantity;

  /// Returns the item's total price in cents.
  int get totalInCents => product.priceInCents * quantity;
}
