class Product {
  const Product({
    required this.id,
    required this.name,
    required this.priceInCents,
  }) : assert(priceInCents >= 0);

  final String id;
  final String name;
  final int priceInCents;
}

const products = <Product>[
  Product(id: 'coffee', name: 'Coffee', priceInCents: 450),
  Product(id: 'tea', name: 'Tea', priceInCents: 350),
  Product(id: 'mug', name: 'Mug', priceInCents: 1250),
];
