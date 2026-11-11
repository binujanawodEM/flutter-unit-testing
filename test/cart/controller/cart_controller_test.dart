import 'dart:async';

import 'package:counter_unit_test_demo/cart/controller/cart_controller.dart';
import 'package:counter_unit_test_demo/cart/controller/stock_repository.dart';
import 'package:counter_unit_test_demo/cart/model/product.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeStockRepository implements StockRepository {
  final Map<String, int> stock = {};
  Object? error;
  Completer<int>? pending;

  @override
  Future<int> availableQuantity(String productId) async {
    if (error case final error?) throw error;
    if (pending case final pending?) return pending.future;
    return stock[productId] ?? 0;
  }
}

void main() {
  const coffee = Product(id: 'coffee', name: 'Coffee', priceInCents: 450);
  const tea = Product(id: 'tea', name: 'Tea', priceInCents: 350);

  group('CartController', () {
    late FakeStockRepository stock;
    late CartController controller;

    setUp(() {
      stock = FakeStockRepository()..stock.addAll({'coffee': 3, 'tea': 2});
      controller = CartController(stock);
    });

    test('starts empty with zero totals', () {
      expect(controller.items, isEmpty);
      expect(controller.totalQuantity, 0);
      expect(controller.totalInCents, 0);
      expect(controller.isLoading, isFalse);
    });

    test('adds products and calculates exact totals', () async {
      await controller.addProduct(coffee);
      await controller.addProduct(coffee);
      await controller.addProduct(tea);

      expect(controller.items, hasLength(2));
      expect(controller.items.first.quantity, 2);
      expect(controller.items.first.totalInCents, 900);
      expect(controller.totalQuantity, 3);
      expect(controller.totalInCents, 1250);
    });

    test('decrement reduces quantity and removes the last item', () async {
      await controller.addProduct(coffee);
      await controller.addProduct(coffee);
      controller.decrementProduct(coffee.id);
      expect(controller.items.single.quantity, 1);
      controller.decrementProduct(coffee.id);
      expect(controller.items, isEmpty);
    });

    test('remove deletes an item; missing products are ignored', () async {
      await controller.addProduct(coffee);
      await controller.addProduct(tea);
      controller.removeProduct(coffee.id);
      controller.removeProduct('missing');
      controller.decrementProduct('missing');
      expect(controller.items.single.product, tea);
      expect(controller.totalInCents, 350);
    });

    test('rejects additions when stock is zero or exhausted', () async {
      stock.stock['coffee'] = 1;
      stock.stock['tea'] = 0;
      await controller.addProduct(coffee);
      await expectLater(
        controller.addProduct(coffee),
        throwsA(isA<StockLimitException>()),
      );
      await expectLater(
        controller.addProduct(tea),
        throwsA(isA<StockLimitException>()),
      );
      expect(controller.totalQuantity, 1);
      expect(controller.isLoading, isFalse);
    });

    test('repository failures leave the cart unchanged', () async {
      await controller.addProduct(coffee);
      stock.error = StateError('Stock unavailable');
      await expectLater(controller.addProduct(tea), throwsStateError);
      expect(controller.items.single.product, coffee);
      expect(controller.totalInCents, 450);
      expect(controller.isLoading, isFalse);
    });

    test('items are an unmodifiable snapshot', () async {
      await controller.addProduct(coffee);
      final snapshot = controller.items;
      expect(() => snapshot.clear(), throwsUnsupportedError);
      await controller.addProduct(tea);
      expect(snapshot, hasLength(1));
      expect(controller.items, hasLength(2));
    });

    test('blocks mutations while checking stock', () async {
      stock.pending = Completer<int>();
      final addition = controller.addProduct(coffee);
      expect(controller.isLoading, isTrue);
      await expectLater(controller.addProduct(tea), throwsStateError);
      expect(() => controller.removeProduct(coffee.id), throwsStateError);
      expect(() => controller.decrementProduct(coffee.id), throwsStateError);
      stock.pending!.complete(3);
      await addition;
      expect(controller.isLoading, isFalse);
      expect(controller.totalQuantity, 1);
    });

    test('notifies listeners of loading, cart changes and failures', () async {
      final states = <String>[];
      controller.addListener(() {
        states.add('${controller.isLoading}:${controller.totalQuantity}');
      });

      await controller.addProduct(coffee);
      controller.decrementProduct(coffee.id);
      controller.removeProduct('missing');
      stock.error = StateError('Stock unavailable');
      await expectLater(controller.addProduct(tea), throwsStateError);

      expect(states, ['true:0', 'false:1', 'false:0', 'true:0', 'false:0']);
    });

    test('notifies listeners when an existing item is removed', () async {
      await controller.addProduct(coffee);
      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.removeProduct(coffee.id);

      expect(notifications, 1);
      expect(controller.items, isEmpty);
    });

    test(
      'does not notify or change items after disposal during a stock check',
      () async {
        stock.pending = Completer<int>();
        var notifications = 0;
        controller.addListener(() => notifications++);
        final addition = controller.addProduct(coffee);

        controller.dispose();
        stock.pending!.complete(3);
        await addition;

        expect(notifications, 1);
        expect(controller.items, isEmpty);
        expect(controller.isLoading, isFalse);
        expect(() => controller.removeProduct(coffee.id), throwsStateError);
        await expectLater(controller.addProduct(coffee), throwsStateError);
      },
    );
  });
}
