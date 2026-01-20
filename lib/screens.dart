import 'dart:math';
import 'package:flutter/material.dart';

import 'engine.dart';
import 'models.dart';
import 'ui.dart';

class FutbolcarkApp extends StatelessWidget {
  const FutbolcarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GameScope(
      game: GameController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: FutbolcarkTheme.theme(),
        home: const StartScreen(),
      ),
    );
  }
}

/// Basit InheritedWidget ile state erişimi (paket yok)
class GameScope extends InheritedNotifier<GameController> {
  const GameScope({super.key, required GameController game, required Widget child})
      : super(notifier: game, child: child);

  static GameController of(BuildContext context) {
    final s = context.dependOnInheritedWidgetOfExactType<GameScope>();
    assert(s != null, 'GameScope bulunamadı!');
    return s!.notifier!;
  }
}

// ------------------ START ------------------

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = GameScope.of(context);

    return Scaffold(
      body: GradientScaffold(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _topIcon(Icons.menu),
                  const Spacer(),
                  _topIcon(Icons.info_outline),
                ],
              ),
            ),
            const SizedBox(height: 26),

            // Stadium hissi (assets yok -> ışık/blur)
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.18,
                      child: CustomPaint(painter: _StadiumPainter()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black26,
                            border: Border.all(color: Colors.white24, width: 3),
                          ),
                          child: const Icon(Icons.person, size: 54, color: Colors.white70),
                        ),
                        const SizedBox(height: 18),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Row(
                            children: [
                              Expanded(
                                child: _bigCard(
                                  title: 'Yeni Kariyer',
                                  subtitle: 'PLAYER',
                                  icon: Icons.add,
                                  onTap: () => _openCareersSheet(context, game),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _bigCard(
                                  title: 'Devam Et',
                                  subtitle: 'PLAYER',
                                  icon: Icons.play_arrow,
                                  onTap: () => _openCareersSheet(context, game),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  _bottomTab('Kart ve Kadro', false),
                  _bottomTab('Kariyer', true),
                  _bottomTab('Lig', false),
                  _bottomTab('Düzenle', false),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  static Widget _topIcon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24, width: 1.2),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  static Widget _bottomTab(String t, bool active) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(active ? Icons.person : Icons.edit, color: active ? const Color(0xFFE7D33A) : Colors.white38, size: 18),
          const SizedBox(height: 6),
          Text(t, style: TextStyle(color: active ? const Color(0xFFE7D33A) : Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  static Widget _bigCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.black26,
          border: Border.all(color: Colors.white24, width: 1.2),
          boxShadow: const [BoxShadow(blurRadius: 14, color: Colors.black45)],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(opacity: 0.14, child: CustomPaint(painter: _CardFacetPainter())),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: Icon(icon, size: 34, color: Colors.white70),
            ),
            Positioned(
              left: 16,
              bottom: 22,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _openCareersSheet(BuildContext context, GameController game) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CareersSheet(game: game),
    );
  }
}

class _CareersSheet extends StatelessWidget {
  const _CareersSheet({required this.game});
  final GameController game;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF151C20),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white24, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Kariyerlerim', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: min(MediaQuery.of(context).size.height * 0.60, 520),
              child: ListView.builder(
                itemCount: game.slots.length,
                itemBuilder: (_, i) {
                  final c = game.slots[i];
                  final title = c == null ? 'Yeni Kariyer Oluştur' : c.profile.fullName;
                  final sub = c == null ? 'Slot ${i + 1}' : '${c.leagueName} • ${c.clubName}';
                  return _slotTile(
                    title: title,
                    subtitle: sub,
                    onTap: () {
                      game.selectedSlot = i;
                      Navigator.pop(context);
                      if (c == null) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => CreatePlayerScreen(slotIndex: i)));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CareerHomeScreen()));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slotTile({required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111518),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12, width: 1.0),
      ),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.person_add_alt_1, color: Colors.white70),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
        trailing: Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(color: Color(0xFF2AD07D), shape: BoxShape.circle),
          child: const Icon(Icons.play_arrow, color: Colors.black, size: 18),
        ),
      ),
    );
  }
}

// ------------------ CREATE PLAYER ------------------

class CreatePlayerScreen extends StatefulWidget {
  const CreatePlayerScreen({super.key, required this.slotIndex});
  final int slotIndex;

  @override
  State<CreatePlayerScreen> createState() => _CreatePlayerScreenState();
}

class _CreatePlayerScreenState extends State<CreatePlayerScreen> {
  final first = TextEditingController(text: 'Player');
  final last = TextEditingController(text: '');
  Position pos = Position.st;
  int number = 9;
  String country = 'Almanya';

  @override
  void dispose() {
    first.dispose();
    last.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = GameScope.of(context);

    return Scaffold(
      body: GradientScaffold(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const SizedBox(height: 14),
              const Text('Yeni Kariyer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),

              // üst grid (videodaki 4 kutu hissi)
              Row(
                children: [
                  Expanded(child: _miniBox(icon: Icons.badge, label: 'Kart')),
                  const SizedBox(width: 12),
                  Expanded(child: _miniBox(icon: Icons.sports_soccer, label: 'Saha')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _miniBox(icon: Icons.gps_fixed, label: 'Hedef')),
                  const SizedBox(width: 12),
                  Expanded(child: _miniBox(icon: Icons.checkroom, label: 'Forma')),
                ],
              ),

              const SizedBox(height: 16),
              _twoInputsRow(
                leftLabel: 'İsim',
                left: TextField(
                  controller: first,
                  decoration: _inputDec('Player'),
                ),
                rightLabel: 'Soy İsim',
                right: TextField(
                  controller: last,
                  decoration: _inputDec(''),
                ),
              ),
              const SizedBox(height: 12),
              _twoInputsRow(
                leftLabel: 'Kıta',
                left: _drop<String>(
                  value: 'Avrupa',
                  items: const ['Avrupa'],
                  onChanged: (_) {},
                ),
                rightLabel: 'Ülke',
                right: _drop<String>(
                  value: country,
                  items: const ['Almanya'],
                  onChanged: (v) => setState(() => country = v ?? 'Almanya'),
                ),
              ),
              const SizedBox(height: 12),
              _twoInputsRow(
                leftLabel: 'Pozisyon',
                left: _drop<Position>(
                  value: pos,
                  items: Position.values,
                  labelOf: (p) => p.tr,
                  onChanged: (v) => setState(() => pos = v ?? Position.st),
                ),
                rightLabel: 'Forma Numarası',
                right: _drop<int>(
                  value: number,
                  items: List<int>.generate(30, (i) => i + 1),
                  onChanged: (v) => setState(() => number = v ?? 9),
                ),
              ),

              const SizedBox(height: 14),
              GlassButton(
                text: 'Galeriden Fotoğraf Ekle',
                icon: Icons.image_outlined,
                onTap: () {
                  // v0.1: placeholder (assets + image picker sonra)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('v0.1: Fotoğraf özelliği sonra eklenecek.')),
                  );
                },
              ),
              const SizedBox(height: 12),
              GlassButton(
                text: 'İlerle',
                icon: Icons.arrow_forward,
                onTap: () {
                  final profile = PlayerProfile(
                    firstName: first.text.trim().isEmpty ? 'Player' : first.text.trim(),
                    lastName: last.text.trim(),
                    country: country,
                    position: pos,
                    shirtNumber: number,
                  );
                  game.createCareerInSlot(slotIndex: widget.slotIndex, profile: profile);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CareerHomeScreen()));
                },
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  static BoxDecoration _boxDec() => BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1.2),
      );

  Widget _miniBox({required IconData icon, required String label}) {
    return Container(
      height: 140,
      decoration: _boxDec(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 40),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDec(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: kGlass,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white24, width: 1.2),
        ),
      );

  Widget _twoInputsRow({
    required String leftLabel,
    required Widget left,
    required String rightLabel,
    required Widget right,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(leftLabel, style: const TextStyle(color: kTextSoft, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            left,
          ]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(rightLabel, style: const TextStyle(color: kTextSoft, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            right,
          ]),
        ),
      ],
    );
  }

  Widget _drop<T>({
    required T value,
    required List items,
    String Function(dynamic v)? labelOf,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kGlass,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF12181C),
          iconEnabledColor: Colors.white70,
          items: items
              .map<DropdownMenuItem<T>>((e) => DropdownMenuItem<T>(
                    value: e as T,
                    child: Text(labelOf?.call(e) ?? e.toString()),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ------------------ CAREER HOME ------------------

class CareerHomeScreen extends StatelessWidget {
  const CareerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = GameScope.of(context);
    final c = game.career!;
    final p = c.profile;

    return Scaffold(
      body: GradientScaffold(
        child: Column(
          children: [
            const SizedBox(height: 14),
            PlayerCardView(career: c),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  GlassButton(
                    text: 'İlerle',
                    icon: Icons.arrow_forward,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const WheelTeamScreen()));
                    },
                  ),
                  const SizedBox(height: 12),
                  GlassButton(
                    text: 'Kariyer Geçmişi',
                    icon: Icons.table_chart_outlined,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('v0.1: Kariyer geçmişi sonra.')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SmallGlassButton(
                        text: 'Görevler',
                        icon: Icons.check_box_outlined,
                        onTap: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('v0.1: Görevler sonra.'))),
                      ),
                      const SizedBox(width: 12),
                      SmallGlassButton(
                        text: 'Haberler',
                        icon: Icons.newspaper_outlined,
                        onTap: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('v0.1: Haberler sonra.'))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SmallGlassButton(
                        text: 'Düzenle',
                        icon: Icons.edit,
                        onTap: () {
                          // basit: create ekranına geri
                          Navigator.push(context, MaterialPageRoute(builder: (_) => CreatePlayerScreen(slotIndex: game.selectedSlot)));
                        },
                      ),
                      const SizedBox(width: 12),
                      SmallGlassButton(
                        text: 'Ana Menü',
                        icon: Icons.home,
                        onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '${p.country} • ${c.leagueName} • ${c.clubName} • ${c.marketValueM}M€',
                style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ WHEELS (videodaki gibi: altta Çevir + İlerle) ------------------

class WheelTeamScreen extends StatelessWidget {
  const WheelTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = GameScope.of(context);
    return WheelScreen(
      title: 'Takım',
      segments: game.teamWheel(),
      spinText: 'Sınırsız Çevir',
      onResult: (seg) => game.applyTeamResult(seg.label),
      onNext: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WheelAssistScreen())),
    );
  }
}

class WheelAssistScreen extends StatelessWidget {
  const WheelAssistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = GameScope.of(context);
    return WheelScreen(
      title: '${game.career!.leagueName}\nAsist Sayısı',
      segments: game.assistWheel(),
      spinText: 'Çevir',
      overlayTitle: 'Asist Sayısı',
      overlayIcon: Icons.sports_soccer,
      onResult: (_) {},
      onNext: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WheelEuropeCupScreen())),
    );
  }
}

class WheelEuropeCupScreen extends StatelessWidget {
  const WheelEuropeCupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = GameScope.of(context);
    return WheelScreen(
      title: 'Avrupa Kupası Puan',
      segments: game.europeCupPointsWheel(),
      spinText: 'Sınırsız Çevir',
      overlayTitle: 'Avrupa Kupası Puan',
      overlayIcon: Icons.emoji_events_outlined,
      onResult: (_) {},
      onNext: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WheelContractScreen())),
    );
  }
}

class WheelContractScreen extends StatelessWidget {
  const WheelContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = GameScope.of(context);
    return WheelScreen(
      title: 'Sözleşme Süresi',
      segments: game.contractWheel(),
      spinText: 'Çevir',
      overlayTitle: 'Sözleşme Süresi',
      overlayIcon: Icons.description_outlined,
      onResult: (seg) => game.applyContractYears(int.tryParse(seg.label) ?? 3),
      onNext: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeagueTableScreen())),
    );
  }
}

class WheelScreen extends StatefulWidget {
  const WheelScreen({
    super.key,
    required this.title,
    required this.segments,
    required this.spinText,
    required this.onResult,
    required this.onNext,
    this.overlayTitle,
    this.overlayIcon,
  });

  final String title;
  final List<WheelSegment> segments;
  final String spinText;
  final void Function(WheelSegment seg) onResult;
  final VoidCallback onNext;
  final String? overlayTitle;
  final IconData? overlayIcon;

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late Animation<double> _anim;

  double _turns = 0; // tekerlek dönüşü
  bool _spinning = false;
  WheelSegment? _last;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 3600));
    _anim = Tween<double>(begin: 0, end: 0).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic))
      ..addListener(() {
        setState(() => _turns = _anim.value);
      })
      ..addStatusListener((s) async {
        if (s == AnimationStatus.completed) {
          setState(() => _spinning = false);

          if (_last != null && mounted) {
            await showDialog(
              context: context,
              barrierColor: Colors.transparent,
              builder: (_) => Stack(
                children: [
                  Center(
                    child: ResultOverlay(
                      title: widget.overlayTitle ?? widget.title.replaceAll('\n', ' '),
                      valueBig: _last!.label.replaceAll('-', '–'),
                      icon: widget.overlayIcon ?? Icons.emoji_events_outlined,
                    ),
                  ),
                ],
              ),
            );
          }
        }
      });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientScaffold(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 18),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 18),
              WheelView(
                segments: widget.segments,
                rotationTurns: _turns,
              ),
              const Spacer(),
              GlassButton(
                text: widget.spinText,
                icon: Icons.refresh,
                enabled: !_spinning,
                onTap: _spinning ? null : () => _spin(),
              ),
              const SizedBox(height: 12),
              GlassButton(
                text: 'İlerle',
                icon: Icons.arrow_forward,
                enabled: !_spinning,
                onTap: _spinning ? null : widget.onNext,
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  void _spin() {
    final game = GameScope.of(context);
    final idx = game.spinPickIndex(widget.segments);
    final selected = widget.segments[idx];

    // hedef: pointer sağda (0 rad). painter start -90° olduğu için açı hesabı şart.
    final totalW = widget.segments.fold<double>(0, (a, b) => a + b.weight);
    double start = -pi / 2;
    for (int i = 0; i < idx; i++) {
      start += (widget.segments[i].weight / totalW) * pi * 2;
    }
    final sweep = (selected.weight / totalW) * pi * 2;
    final mid = start + sweep / 2;

    // Sağ pointer 0 rad: tekerlek mid'i 0'a gelsin -> rotation = -mid
    final targetAngle = -mid;

    // Turn’e çevir: rad / 2π
    final targetTurns = targetAngle / (2 * pi);

    // ekstra tur: videodaki hız için 7-10 tur
    final extra = 7 + game.rng.nextInt(4);
    final end = _turns + extra + (targetTurns - _turns % 1);

    _last = selected;
    widget.onResult(selected);

    setState(() => _spinning = true);

    _anim = Tween<double>(begin: _turns, end: end).animate(
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic),
    );

    _c
      ..reset()
      ..forward();
  }
}

// ------------------ LEAGUE TABLE ------------------

class LeagueTableScreen extends StatelessWidget {
  const LeagueTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = GameScope.of(context);
    final rows = game.buildDemoLeagueTable();

    return Scaffold(
      body: GradientScaffold(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text('Lig', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _table(rows, title: 'German League'),
                      const SizedBox(height: 14),
                      _legend(),
                      const SizedBox(height: 18),
                      // altta ikinci lig hissi (videodaki gibi)
                      _table(rows.reversed.take(6).toList(), title: 'German Second League'),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: GlassButton(
                text: 'Ana Menü',
                icon: Icons.home,
                onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legend() {
    Widget item(Color c, String t) {
      return Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 8),
          Text(t, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
        ],
      );
    }

    return Column(
      children: [
        item(const Color(0xFF2B7E52), 'Şampiyonlar Kupası'),
        const SizedBox(height: 6),
        item(const Color(0xFF2B6FD6), 'Avrupa Kupası'),
        const SizedBox(height: 6),
        item(const Color(0xFFE08A2A), 'Konferans Kupası'),
        const SizedBox(height: 6),
        item(const Color(0xFFB12A2A), 'Küme Düşme'),
      ],
    );
  }

  Widget _table(List<LeagueTableRow> rows, {required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24, width: 1.2),
          ),
          child: Column(
            children: [
              _header(),
              const Divider(height: 1, color: Colors.white12),
              ...List.generate(rows.length, (i) => _row(i + 1, rows[i])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header() {
    TextStyle s = const TextStyle(color: Colors.white60, fontWeight: FontWeight.w800, fontSize: 12);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 26, child: Text('#', style: s)),
          const SizedBox(width: 6),
          Expanded(child: Text('Takım', style: s)),
          SizedBox(width: 30, child: Text('O', style: s, textAlign: TextAlign.right)),
          SizedBox(width: 30, child: Text('G', style: s, textAlign: TextAlign.right)),
          SizedBox(width: 30, child: Text('B', style: s, textAlign: TextAlign.right)),
          SizedBox(width: 30, child: Text('M', style: s, textAlign: TextAlign.right)),
          SizedBox(width: 34, child: Text('P', style: s, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _row(int rank, LeagueTableRow r) {
    Color zone;
    if (rank <= 4) {
      zone = const Color(0xFF2B7E52);
    } else if (rank <= 6) {
      zone = const Color(0xFF2B6FD6);
    } else if (rank == 7) {
      zone = const Color(0xFFE08A2A);
    } else if (rank >= 16) {
      zone = const Color(0xFFB12A2A);
    } else {
      zone = Colors.transparent;
    }

    return Container(
      color: zone == Colors.transparent ? Colors.transparent : zone.withOpacity(0.18),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: zone == Colors.transparent ? Colors.white10 : zone,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(child: Text(r.team, style: const TextStyle(fontWeight: FontWeight.w700))),
          SizedBox(width: 30, child: Text('${r.played}', textAlign: TextAlign.right)),
          SizedBox(width: 30, child: Text('${r.wins}', textAlign: TextAlign.right)),
          SizedBox(width: 30, child: Text('${r.draws}', textAlign: TextAlign.right)),
          SizedBox(width: 30, child: Text('${r.losses}', textAlign: TextAlign.right)),
          SizedBox(width: 34, child: Text('${r.points}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w900))),
        ],
      ),
    );
  }
}

// ------------------ PAINTERS (görsel hissi) ------------------

class _StadiumPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white;
    final blur = Paint()..color = Colors.white.withOpacity(0.08);

    // üst ışıklar
    for (int i = 0; i < 6; i++) {
      final x = size.width * (0.12 + i * 0.15);
      canvas.drawCircle(Offset(x, size.height * 0.10), 28, blur);
      canvas.drawCircle(Offset(x, size.height * 0.10), 8, p..color = Colors.white.withOpacity(0.10));
    }

    // saha çizgi hissi
    final field = Rect.fromLTWH(size.width * 0.12, size.height * 0.45, size.width * 0.76, size.height * 0.22);
    canvas.drawRRect(
      RRect.fromRectAndRadius(field, const Radius.circular(18)),
      Paint()..color = Colors.white.withOpacity(0.05),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CardFacetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(7);
    final p = Paint()..color = Colors.white.withOpacity(0.06);
    for (int i = 0; i < 22; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final w = 40 + rnd.nextDouble() * 90;
      final h = 30 + rnd.nextDouble() * 70;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), const Radius.circular(14)),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
