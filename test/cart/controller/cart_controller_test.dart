import 'package:counter_unit_test_demo/cart/controller/cart_controller.dart';
import 'package:counter_unit_test_demo/cart/controller/stock_repository.dart';
import 'package:counter_unit_test_demo/cart/model/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const coffee = Product(id: 'coffee', name: 'Coffee', priceInCents: 450);
  const tea = Product(id: 'tea', name: 'Tea', priceInCents: 350);

  late CartController controller;

  setUp(() {
    controller = CartController(InMemoryStockRepository());
  });

  // Checks that the first add puts one product in the cart.
  test('adds a product to the cart', () async {
    await controller.addProduct(coffee);

    expect(controller.items.single.product, coffee);
    expect(controller.items.single.quantity, 1);
  });

  // Checks that adding the same product increases its quantity.
  test('increments an item already in the cart', () async {
    await controller.addProduct(coffee);
    await controller.addProduct(coffee);

    expect(controller.items.single.quantity, 2);
  });

  // Checks that decrementing lowers quantity and removes the last item.
  test('decrements an item in the cart', () async {
    await controller.addProduct(coffee);
    await controller.addProduct(coffee);

    controller.decrementProduct(coffee.id);
    expect(controller.items.single.quantity, 1);

    controller.decrementProduct(coffee.id);
    expect(controller.items, isEmpty);
  });

  // Checks that remove deletes the chosen product.
  test('removes an item from the cart', () async {
    await controller.addProduct(coffee);
    await controller.addProduct(tea);

    controller.removeProduct(coffee.id);

    expect(controller.items.single.product, tea);
  });

  // Checks that totals include every product and quantity.
  test('calculates the cart total', () async {
    await controller.addProduct(coffee);
    await controller.addProduct(coffee);
    await controller.addProduct(tea);

    expect(controller.totalQuantity, 3);
    expect(controller.totalInCents, 1250);
  });
}
