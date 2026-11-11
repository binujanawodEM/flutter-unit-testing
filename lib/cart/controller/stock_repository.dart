abstract class StockRepository {
  Future<int> availableQuantity(String productId);
}

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
