import 'package:flutter/material.dart';
import 'ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FutbolCarkApp());
}

class FutbolCarkApp extends StatelessWidget {
  const FutbolCarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Futbol Kariyer Çarkı',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const Root(),
    );
  }
}
