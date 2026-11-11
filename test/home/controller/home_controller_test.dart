import 'package:counter_unit_test_demo/home/controller/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeController', () {
    late HomeController controller;

    setUp(() {
      controller = HomeController();
    });

    test('starts at zero', () {
      expect(controller.count, 0);
    });

    test('increment increases the count by one', () {
      controller.increment();

      expect(controller.count, 1);
    });

    test('decrement decreases the count by one', () {
      controller.decrement();

      expect(controller.count, -1);
    });

    test('repeated operations update the count', () {
      controller.increment();
      controller.increment();
      controller.decrement();

      expect(controller.count, 1);
    });

    test('notifies listeners when the count changes', () {
      final values = <int>[];
      controller.addListener(() => values.add(controller.count));

      controller.increment();
      controller.decrement();

      expect(values, [1, 0]);
    });
  });
}
