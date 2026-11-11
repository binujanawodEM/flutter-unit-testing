import 'package:counter_unit_test_demo/home/model/counter.dart';

class HomeController {
  final Counter _counter = Counter();

  int get count => _counter.value;

  void increment() {
    _counter.value++;
  }

  void decrement() {
    _counter.value--;
  }
}