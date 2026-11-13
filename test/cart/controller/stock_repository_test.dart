import 'package:counter_unit_test_demo/cart/controller/stock_repository.dart';
import 'package:counter_unit_test_demo/cart/model/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final repository = InMemoryStockRepository();

  // Confirms every listed product returns a valid non-negative stock count.
  test('every catalogue product has available stock', () async {
    for (final product in products) {
      expect(
        await repository.availableQuantity(product.id),
        greaterThanOrEqualTo(0),
      );
    }
  });

  // Confirms requests for products outside the catalogue fail.
  test('unknown products cause an error', () async {
    await expectLater(
      repository.availableQuantity('unknown'),
      throwsArgumentError,
    );
  });
}
