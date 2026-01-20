import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1B23), Color(0xFF08141A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 18),
              const _HeaderTitle('Kariyer'),
              const SizedBox(height: 18),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _CareerCard(
                          title: 'Yeni Kariyer',
                          subtitle: 'Başla',
                          icon: Icons.add,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CreatePlayerScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CareerCard(
                          title: 'Devam Et',
                          subtitle: 'Yakında',
                          icon: Icons.play_arrow,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Devam et: bir sonraki adımda kaydetme ekleyeceğiz.')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const _BottomHint(),
            ],
          ),
        ),
      ),
    );
  }
}

class CreatePlayerScreen extends StatefulWidget {
  const CreatePlayerScreen({super.key});

  @override
  State<CreatePlayerScreen> createState() => _CreatePlayerScreenState();
}

class _CreatePlayerScreenState extends State<CreatePlayerScreen> {
  final nameCtrl = TextEditingController(text: 'Player');
  final surnameCtrl = TextEditingController();

  String continent = 'Avrupa';
  String country = 'Almanya';
  String position = 'Santrafor';
  int number = 9;

  @override
  void dispose() {
    nameCtrl.dispose();
    surnameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullName = (surnameCtrl.text.trim().isEmpty)
        ? nameCtrl.text.trim()
        : '${nameCtrl.text.trim()} ${surnameCtrl.text.trim()}';

    return Scaffold(
      appBar: AppBar(title: const Text('Oyuncu Oluştur')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1B23), Color(0xFF08141A)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _previewTile(Icons.badge, 'Kart')),
                  const SizedBox(width: 10),
                  Expanded(child: _previewTile(Icons.map, 'Saha')),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _previewTile(Icons.my_location, 'Hedef')),
                  const SizedBox(width: 10),
                  Expanded(child: _previewTile(Icons.sports_soccer, 'Forma')),
                ],
              ),
              const SizedBox(height: 14),

              _LabeledField(
                label: 'İsim',
                child: TextField(
                  controller: nameCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Player',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _LabeledField(
                label: 'Soy İsim',
                child: TextField(
                  controller: surnameCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Soy isim',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _LabeledField(
                      label: 'Kıta',
                      child: _Dropdown<String>(
                        value: continent,
                        items: const ['Avrupa', 'G. Amerika', 'K. Amerika', 'Asya', 'Afrika', 'Okyanusya'],
                        onChanged: (v) => setState(() => continent = v),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _LabeledField(
                      label: 'Ülke',
                      child: _Dropdown<String>(
                        value: country,
                        items: const ['Almanya', 'Türkiye', 'İngiltere', 'İspanya', 'İtalya', 'Fransa', 'Brezilya', 'Arjantin'],
                        onChanged: (v) => setState(() => country = v),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _LabeledField(
                      label: 'Pozisyon',
                      child: _Dropdown<String>(
                        value: position,
                        items: const ['Santrafor', 'Kanat', '10 Numara', 'Orta Saha', 'Stoper', 'Bek', 'Kaleci'],
                        onChanged: (v) => setState(() => position = v),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _LabeledField(
                      label: 'Forma Numarası',
                      child: _Dropdown<int>(
                        value: number,
                        items: const [7, 9, 10, 11, 17, 21, 30, 99],
                        onChanged: (v) => setState(() => number = v),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RatingWheelScreen(
                        playerName: fullName.isEmpty ? 'Player' : fullName,
                        country: country,
                        position: position,
                        number: number,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('İlerle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _previewTile(IconData icon, String text) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: const Color(0xFF0E2731),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(height: 6),
            Text(text, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class RatingWheelScreen extends StatefulWidget {
  final String playerName;
  final String country;
  final String position;
  final int number;

  const RatingWheelScreen({
    super.key,
    required this.playerName,
    required this.country,
    required this.position,
    required this.number,
  });

  @override
  State<RatingWheelScreen> createState() => _RatingWheelScreenState();
}

class _RatingWheelScreenState extends State<RatingWheelScreen> {
  final StreamController<int> selected = StreamController<int>();
  int? last;

  // Ağırlık: 60-65 daha sık, 70-74 orta, 80+ nadir
  late final List<int> wheelValues = [
    ...List.filled(10, 60),
    ...List.filled(10, 61),
    ...List.filled(10, 62),
    ...List.filled(10, 63),
    ...List.filled(10, 64),
    ...List.filled(10, 65),
    ...List.filled(8, 66),
    ...List.filled(8, 67),
    ...List.filled(8, 68),
    ...List.filled(6, 69),
    ...List.filled(6, 70),
    ...List.filled(6, 71),
    ...List.filled(6, 72),
    ...List.filled(5, 73),
    ...List.filled(5, 74),
    ...List.filled(3, 75),
    ...List.filled(3, 76),
    ...List.filled(2, 77),
    ...List.filled(2, 78),
    ...List.filled(1, 79),
    ...List.filled(1, 80),
    ...List.filled(1, 81),
    ...List.filled(1, 82),
    ...List.filled(1, 83),
    ...List.filled(1, 84),
    ...List.filled(1, 85),
    ...List.filled(1, 86),
    ...List.filled(1, 87),
    ...List.filled(1, 88),
    ...List.filled(1, 89),
  ];

  final rng = Random();

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  void spin() {
    final i = rng.nextInt(wheelValues.length);
    selected.add(i);
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Başlangıç Reytingi';

    return Scaffold(
      appBar: AppBar(title: const Text('Reyting Çarkı')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1B23), Color(0xFF08141A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 18),
              _HeaderTitle(title),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FortuneWheel(
                    selected: selected.stream,
                    indicators: const <FortuneIndicator>[
                      FortuneIndicator(
                        alignment: Alignment.centerRight,
                        child: TriangleIndicator(color: Colors.white),
                      ),
                    ],
                    items: [
                      for (final v in wheelValues)
                        FortuneItem(
                          child: Text(
                            '$v',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        )
                    ],
                    onAnimationEnd: () {
                      final idx = (selected.hasListener) ? last : last;
                      // last'ı streamden alamıyoruz; seçimi spin() içinde hesaplıyoruz.
                    },
                    onFocusItemChanged: (index) {
                      last = wheelValues[index];
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () {
                    spin();
                    Future.delayed(const Duration(milliseconds
