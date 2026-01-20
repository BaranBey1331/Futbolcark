import 'package:flutter/material.dart';

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
      home: const Scaffold(
        body: Center(
          child: Text(
            'Futbol Kariyer Çarkı\n(Altyapı hazır)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
