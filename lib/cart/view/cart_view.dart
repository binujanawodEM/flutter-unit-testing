import 'package:counter_unit_test_demo/cart/controller/cart_controller.dart';
import 'package:counter_unit_test_demo/cart/controller/stock_repository.dart';
import 'package:counter_unit_test_demo/cart/model/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  String _price(int cents) =>
      '\$${cents ~/ 100}.${(cents % 100).toString().padLeft(2, '0')}';

  Future<void> _addProduct(BuildContext context, Product product) async {
    try {
      await context.read<CartController>().addProduct(product);
    } on StockLimitException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No more ${product.name} available.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not check stock. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartController(InMemoryStockRepository()),
      child: Consumer<CartController>(
        builder: (context, controller, child) => Scaffold(
          appBar: AppBar(title: const Text('Shopping cart')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Products', style: Theme.of(context).textTheme.titleLarge),
              if (controller.isLoading) const LinearProgressIndicator(),
              for (final product in products)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(product.name),
                  subtitle: Text(_price(product.priceInCents)),
                  trailing: TextButton.icon(
                    onPressed: controller.isLoading
                        ? null
                        : () => _addProduct(context, product),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add'),
                  ),
                ),
              const Divider(),
              Text('Your cart', style: Theme.of(context).textTheme.titleLarge),
              if (controller.items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Your cart is empty.'),
                ),
              for (final item in controller.items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.product.name),
                  subtitle: Text(
                    '${item.quantity} × ${_price(item.product.priceInCents)} = ${_price(item.totalInCents)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Remove one',
                        onPressed: controller.isLoading
                            ? null
                            : () =>
                                  controller.decrementProduct(item.product.id),
                        icon: const Icon(Icons.remove),
                      ),
                      IconButton(
                        tooltip: 'Add one',
                        onPressed: controller.isLoading
                            ? null
                            : () => _addProduct(context, item.product),
                        icon: const Icon(Icons.add),
                      ),
                      IconButton(
                        tooltip: 'Remove item',
                        onPressed: controller.isLoading
                            ? null
                            : () => controller.removeProduct(item.product.id),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Total (${controller.totalQuantity} items)'),
                trailing: Text(
                  _price(controller.totalInCents),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
