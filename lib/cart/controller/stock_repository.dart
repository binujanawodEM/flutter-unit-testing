/// Provides the available stock for a product.
abstract class StockRepository {
  Future<int> availableQuantity(String productId);
}

/// Supplies stock quantities from a fixed in-memory catalogue.
class InMemoryStockRepository implements StockRepository {
  static const _stock = <String, int>{'coffee': 3, 'tea': 5, 'mug': 2};

  @override
  Future<int> availableQuantity(String productId) async {
    final quantity = _stock[productId];
    if (quantity == null) {
      throw ArgumentError.value(productId, 'productId', 'Unknown product');
    }
    return quantity;
  }
}
