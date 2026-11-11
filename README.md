# counter_unit_test_demo

A small Flutter counter app organised as an MVC feature, with unit tests for its controller.

## Project layout

```text
counter_unit_test_demo/
├── lib/
│   ├── main.dart
│   └── home/
│       ├── controller/home_controller.dart
│       ├── model/counter.dart
│       └── view/home_view.dart
├── test/
│   └── home/controller/home_controller_test.dart
├── pubspec.yaml
└── README.md
```

Flutter's generated platform folders (such as `android/`, `ios/`, and `web/`)
are also included.

## Create and test

```sh
flutter create counter_unit_test_demo
cd counter_unit_test_demo
flutter test test/home/controller/
```
