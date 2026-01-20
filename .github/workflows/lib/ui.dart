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
              const Text('Kariyer', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w300)),
              const SizedBox(height: 18),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _CardBtn(
                          title: 'Yeni Kariyer',
                          subtitle: 'Başla',
                          icon: Icons.add,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CreatePlayerScreen()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CardBtn(
                          title: 'Devam Et',
                          subtitle: 'Yakında',
                          icon: Icons.play_arrow,
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Kaydetme sistemi birazdan gelecek.')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text('İlk hedef: Reyting çarkı', style: TextStyle(color: Colors.white54)),
              ),
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _lbl('İsim'),
            TextField(controller: nameCtrl, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 10),
            _lbl('Soy İsim'),
            TextField(controller: surnameCtrl, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 10),

            _lbl('Ülke'),
            DropdownButtonFormField<String>(
              value: country,
              items: const ['Almanya','Türkiye','İngiltere','İspanya','İtalya','Fransa']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => country = v ?? country),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),

            _lbl('Pozisyon'),
            DropdownButtonFormField<String>(
              value: position,
              items: const ['Santrafor','Kanat','10 Numara','Orta Saha','Stoper','Bek','Kaleci']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => position = v ?? position),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),

            _lbl('Forma Numarası'),
            DropdownButtonFormField<int>(
              value: number,
              items: const [7,9,10,11,17,21,30,99]
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e'))).toList(),
              onChanged: (v) => setState(() => number = v ?? number),
              decoration: const InputDecoration(border: OutlineInputBorder()),
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
    );
  }

  Widget _lbl(String s) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(s, style: const TextStyle(color: Colors.white70)),
  );
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
  final rng = Random();
  int? last;

  late final List<int> wheelValues = [
    ...List.filled(12, 60),
    ...List.filled(12, 61),
    ...List.filled(12, 62),
    ...List.filled(12, 63),
    ...List.filled(12, 64),
    ...List.filled(12, 65),
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

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  void spin() {
    selected.add(rng.nextInt(wheelValues.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Başlangıç Reytingi')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1B23), Color(0xFF08141A)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: FortuneWheel(
                selected: selected.stream,
                indicators: const [
                  FortuneIndicator(
                    alignment: Alignment.centerRight,
                    child: TriangleIndicator(color: Colors.white),
                  )
                ],
                items: [
                  for (final v in wheelValues)
                    FortuneItem(child: Text('$v', style: const TextStyle(fontWeight: FontWeight.w700))),
                ],
                onFocusItemChanged: (idx) => last = wheelValues[idx],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: () {
                  spin();
                  Future.delayed(const Duration(milliseconds: 900), () {
                    final ovr = last ?? 70;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('${widget.playerName}  (#${widget.number})'),
                        content: Text('${widget.country} • ${widget.position}\n\nOVR: $ovr'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam')),
                        ],
                      ),
                    );
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Çevir'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CardBtn extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _CardBtn({required this.title, required this.subtitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF101C22),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          height: 220,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF15252D), Color(0xFF0E1B21)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.topRight, child: Icon(icon, color: Colors.white70)),
              const Spacer(),
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
