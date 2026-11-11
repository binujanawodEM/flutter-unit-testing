import 'package:counter_unit_test_demo/home/controller/home_controller.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current count:'),
            Text(controller.count.toString()),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      controller.decrement();
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      controller.increment();
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}