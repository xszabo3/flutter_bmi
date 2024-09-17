import 'package:flutter/material.dart';
import 'package:flutter_bmi/ui/bmi_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BMI calculator'),
        ),
        body: const Center(
          child: ProviderScope(
            child: BmiPage(),
          ),
        )
      ),
    );
  }
}
