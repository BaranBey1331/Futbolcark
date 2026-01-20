import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const FutbolCarkApp());
}

class FutbolCarkApp extends StatelessWidget {
  const FutbolCarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Futbol Kariyer Çarkı',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
