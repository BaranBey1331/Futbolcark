import 'package:flutter/material.dart';
import 'game.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Career? career;

  @override
  void initState() {
    super.initState();
    career = GameEngine.newCareer('Oyuncu');
  }

  void spin() {
    setState(() {
      final ovr = GameEngine.spinRating();
      career!.overall = ovr;
      career!.marketValue = (ovr * ovr) / 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = career!;
    return Scaffold(
      appBar: AppBar(title: const Text('Futbol Kariyer Çarkı')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              c.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('${c.league} • ${c.team}'),
            const SizedBox(height: 20),
            Text(
              'OVR ${c.overall}',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Piyasa: €${c.marketValue.toStringAsFixed(1)}M'),
            const Spacer(),
            FilledButton(
              onPressed: spin,
              child: const Text('Reyting Çarkı'),
            ),
          ],
        ),
      ),
    );
  }
}
