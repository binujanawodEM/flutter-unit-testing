import 'package:counter_unit_test_demo/cart/controller/stock_repository.dart';
import 'package:counter_unit_test_demo/cart/model/cart_item.dart';
import 'package:counter_unit_test_demo/cart/model/product.dart';
import 'package:flutter/foundation.dart';

class StockLimitException implements Exception {
  const StockLimitException();
}

class CartController extends ChangeNotifier {
  CartController(this._stockRepository);

  final StockRepository _stockRepository;
  final Map<String, CartItem> _items = {};
  bool _isLoading = false;
  bool _isDisposed = false;

  List<CartItem> get items => List.unmodifiable(_items.values);
  bool get isLoading => _isLoading;
  int get totalQuantity =>
      _items.values.fold(0, (total, item) => total + item.quantity);
  int get totalInCents =>
      _items.values.fold(0, (total, item) => total + item.totalInCents);

  Future<void> addProduct(Product product) async {
    _ensureNotLoading();
    _isLoading = true;
    notifyListeners();
    try {
      final available = await _stockRepository.availableQuantity(product.id);
      if (_isDisposed) return;
      final existing = _items[product.id];
      final quantity = (existing?.quantity ?? 0) + 1;
      if (quantity > available) {
        throw const StockLimitException();
      }
      _items[product.id] = CartItem(
        product: existing?.product ?? product,
        quantity: quantity,
      );
    } finally {
      _isLoading = false;
      if (!_isDisposed) notifyListeners();
    }
  }

  void decrementProduct(String productId) {
    _ensureNotLoading();
    final item = _items[productId];
    if (item == null) return;
    if (item.quantity == 1) {
      _items.remove(productId);
    } else {
      _items[productId] = CartItem(
        product: item.product,
        quantity: item.quantity - 1,
      );
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _ensureNotLoading();
    if (_items.remove(productId) != null) notifyListeners();
  }

  void _ensureNotLoading() {
    if (_isDisposed) {
      throw StateError('The cart has been disposed');
    }
    if (_isLoading) {
      throw StateError('A stock check is already in progress');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
