# Shopping Cart Unit Testing Demo

A Flutter shopping cart demo focused on unit tests for adding, incrementing,
decrementing, removing items, and calculating totals. It has no counter feature
or widget tests.

The cart controller checks stock before adding products. Tests exercise the
controller and models directly without rendering widgets.

## Project layout

```text
shopping_cart_unit_test_demo/
├── lib/
│   ├── main.dart
│   └── cart/
│       ├── controller/       # Cart rules and stock repository
│       ├── model/            # Product and cart item
│       └── view/
├── test/
│   └── cart/                 # Cart unit tests and fake repository
├── pubspec.yaml
└── README.md
```

## Run

```sh
flutter pub get
flutter run
```

The app opens directly to the cart. Stock is simulated in memory, with no
network or persistence.

## Run unit tests

```sh
flutter test test/cart/
flutter analyze
```
