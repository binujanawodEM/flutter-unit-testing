import 'package:counter_unit_test_demo/home/model/counter.dart';
import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  final Counter _counter = Counter();

  int get count => _counter.value;

  void increment() {
    _counter.value++;
    notifyListeners();
  }

  void decrement() {
    _counter.value--;
    notifyListeners();
  }
}
