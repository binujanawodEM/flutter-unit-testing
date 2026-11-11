import 'package:counter_unit_test_demo/cart/model/product.dart';

class CartItem {
  const CartItem({required this.product, required this.quantity})
    : assert(quantity > 0);

  final Product product;
  final int quantity;

  int get totalInCents => product.priceInCents * quantity;
}
