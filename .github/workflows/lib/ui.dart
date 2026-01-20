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
                    Future.delayed(const Duration(milliseconds: 900), () {
                      if (!mounted) return;
                      final ovr = last ?? 70;
                      showDialog(
                        context: context,
                        builder: (_) => _RatingDialog(
                          name: widget.playerName,
                          country: widget.country,
                          position: widget.position,
                          number: widget.number,
                          overall: ovr,
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Çevir'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingDialog extends StatelessWidget {
  final String name;
  final String country;
  final String position;
  final int number;
  final int overall;

  const _RatingDialog({
    required this.name,
    required this.country,
    required this.position,
    required this.number,
    required this.overall,
  });

  int clamp(int v) => v.clamp(1, 99);

  @override
  Widget build(BuildContext context) {
    // basit stat üretimi (sonra gerçek formül yaparız)
    final pace = clamp(overall + 5);
    final shot = clamp(overall + 6);
    final pass = clamp(overall - 14);
    final dri = clamp(overall + 4);
    final def = clamp(overall - 40);
    final phy = clamp(overall - 2);

    return Dialog(
      backgroundColor: const Color(0xFF151A1E),
      insetPadding: const EdgeInsets.all(18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 26, backgroundColor: Colors.white10, child: Icon(Icons.person, color: Colors.white70)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('#$number  ${name.toUpperCase()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(country, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text(position, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text('$overall', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900)),
            const Text('Reyting', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            _statRow('PAC', pace, 'ŞUT', shot, 'PAS', pass),
            const SizedBox(height: 10),
            _statRow('DRI', dri, 'DEF', def, 'FİZ', phy),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tamam'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String a, int av, String b, int bv, String c, int cv) {
    Widget box(String k, int v) => Expanded(
          child: Column(
            children: [
              Text('$v', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(k, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        );

    return Row(
      children: [
        box(a, av),
        box(b, bv),
        box(c, cv),
      ],
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  final String text;
  const _HeaderTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
    );
  }
}

class _CareerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _CareerCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

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
              Align(
                alignment: Alignment.topRight,
                child: Icon(icon, color: Colors.white70),
              ),
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

class _BottomHint extends StatelessWidget {
  const _BottomHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        'İlk hedef: Reyting çarkı + oyuncu oluşturma',
        style: TextStyle(color: Colors.white.withOpacity(.55)),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final void Function(T v) onChanged;

  const _Dropdown({required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((e) => DropdownMenuItem<T>(value: e, child: Text('$e'))).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}
