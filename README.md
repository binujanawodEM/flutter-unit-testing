# counter_unit_test_demo

A Flutter unit-testing demo with a counter and a shopping cart, organised as separate MVC features. The tests focus on Dart logic, not widgets.

Each feature provides its controller with `ChangeNotifierProvider`. Controllers notify their listeners when state changes; the views rebuild through `Consumer`. Controller tests exercise the logic and notifications directly, without rendering widgets.

## Project layout

```text
counter_unit_test_demo/
├── lib/
│   ├── main.dart
│   ├── home/                  # Counter feature
│   │   ├── controller/
│   │   ├── model/
│   │   └── view/
│   └── cart/                  # Shopping cart feature
│       ├── controller/       # Cart rules and stock repository
│       ├── model/            # Product and cart item
│       └── view/
├── test/
│   ├── home/controller/      # Counter unit tests
│   └── cart/                 # Cart unit tests and fake repository
├── pubspec.yaml
└── README.md
```

Flutter's generated platform folders (such as `android/`, `ios/`, and `web/`)
are also included.

## Run

```sh
flutter pub get
flutter run
```

Open **Cart** from the counter screen. The counter stays unchanged when you return; the cart starts empty each time it is opened. Stock is simulated in memory, with no network or persistence.

## Run the unit tests

```sh
flutter test test/home/controller/
flutter test test/cart/
flutter analyze
```

## 30-minute demonstration

1. **Counter basics (5 minutes):** Explain `group`, `test`, `expect` and why `setUp` creates a fresh controller for each test.
2. **Arrange, act, assert (10 minutes):** Walk through adding products and checking the cart's quantities and totals. Prices are stored as cents to keep arithmetic exact.
3. **Boundaries (5 minutes):** Show empty carts, removal and stock limits. Explain how tests describe expected behaviour.
4. **Async and isolation (7 minutes):** Explain the `StockRepository` interface and the hand-written fake. Run the tests for stock failures, loading notifications and a pending request without calling a real service.
5. **Failure and discussion (3 minutes):** Temporarily change an expected total in a test, rerun it to inspect the failure, then restore the expected value and rerun it.

The cart view is included for trying the feature manually; widget testing is outside this demonstration.
