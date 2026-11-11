import 'package:counter_unit_test_demo/cart/model/cart_item.dart';
import 'package:counter_unit_test_demo/cart/model/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const coffee = Product(id: 'coffee', name: 'Coffee', priceInCents: 450);

  test('cart item calculates its total in cents', () {
    const item = CartItem(product: coffee, quantity: 3);

    expect(item.totalInCents, 1350);
  });

  test('cart items require a positive quantity', () {
    expect(() => CartItem(product: coffee, quantity: 0), throwsAssertionError);
  });

  test('product prices cannot be negative', () {
    expect(
      () => Product(id: 'invalid', name: 'Invalid', priceInCents: -1),
      throwsAssertionError,
    );
  });
}
