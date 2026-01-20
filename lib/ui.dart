import 'dart:math';
import 'package:flutter/material.dart';
import 'models.dart';

/// === Renkler / Tema ===
/// (Video + ss'lerdeki koyu yeşilimsi arka plan / cam efekt hissi)
const kBgTop = Color(0xFF07161C);
const kBgMid = Color(0xFF0B2530);
const kBgBot = Color(0xFF081F26);

const kGlass = Color(0x2AFFFFFF);
const kGlassStrong = Color(0x331A2226);

const kBorder = Color(0xFF6D8B97);
const kBorderSoft = Color(0x33FFFFFF);

const kTextSoft = Color(0xFFBFD0D7);

class FutbolcarkTheme {
  static ThemeData theme() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2F5562),
        brightness: Brightness.dark,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: kBgBot,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      dividerColor: Colors.white24,
    );
  }
}

/// Koyu gradient arkaplan
class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.child,
    this.topPadding = true,
  });

  final Widget child;
  final bool topPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kBgTop, kBgMid, kBgBot],
        ),
      ),
      child: SafeArea(top: topPadding, child: child),
    );
  }
}

/// Basit "cam kart"
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 16,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: kGlassStrong,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: kBorderSoft, width: 1.0),
        boxShadow: const [
          BoxShadow(blurRadius: 18, color: Colors.black54),
        ],
      ),
      child: child,
    );
  }
}

/// Büyük ana buton (ss'lerdeki gibi)
class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.enabled = true,
    this.height = 56,
  });

  final String text;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool enabled;
  final double height;

  @override
  Widget build(BuildContext context) {
    final fg = enabled ? Colors.white : Colors.white38;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onTap : null,
        child: Ink(
          decoration: BoxDecoration(
            color: kGlassStrong,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: enabled ? kBorder : Colors.white24,
              width: 1.2,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: fg),
                  const SizedBox(width: 10),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: fg,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 2'li küçük butonlar için
class SmallGlassButton extends StatelessWidget {
  const SmallGlassButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 54,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: kGlassStrong,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBorder, width: 1.2),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Label" başlık
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// === ÇARK GÖRÜNÜMÜ ===
/// Pointer sağda, merkezde top ikonu (ss'lere benzer)
class WheelView extends StatelessWidget {
  const WheelView({
    super.key,
    required this.segments,
    required this.rotationTurns,
  });

  final List<WheelSegment> segments;
  final double rotationTurns;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Çark
          AnimatedRotation(
            turns: rotationTurns,
            duration: const Duration(milliseconds: 1),
            child: CustomPaint(
              painter: _WheelPainter(segments: segments),
              child: const SizedBox.expand(),
            ),
          ),

          // Orta top
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [
                BoxShadow(blurRadius: 12, color: Colors.black45),
              ],
            ),
            child: const Icon(Icons.sports_soccer, color: Colors.black, size: 26),
          ),

          // Pointer
          Align(
            alignment: Alignment.centerRight,
            child: CustomPaint(
              painter: _PointerPainter(),
              child: const SizedBox(width: 44, height: 90),
            ),
          ),
        ],
      ),
    );
  }
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white;
    final shadow = Paint()..color = Colors.black45;

    final path = Path()
      ..moveTo(size.width, size.height * 0.5)
      ..lineTo(0, size.height * 0.30)
      ..lineTo(0, size.height * 0.70)
      ..close();

    canvas.drawPath(path.shift(const Offset(-2, 2)), shadow);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WheelPainter extends CustomPainter {
  _WheelPainter({required this.segments});
  final List<WheelSegment> segments;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = min(size.width, size.height) * 0.48;

    // dış gölge halkası
    canvas.drawCircle(center, radius + 6, Paint()..color = Colors.black38);

    // dilimler
    final total = segments.fold<double>(0, (a, b) => a + b.weight);
    double start = -pi / 2;

    for (final s in segments) {
      final sweep = (s.weight / total) * pi * 2;

      // dilim rengi
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        true,
        Paint()..color = s.color,
      );

      // dilim çizgisi
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        true,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = Colors.white24,
      );

      // metin
      final mid = start + sweep / 2;
      final textPainter = TextPainter(
        text: TextSpan(
          text: s.label,
          style: TextStyle(
            color: s.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: radius);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(mid);

      final rText = radius * 0.72;
      canvas.translate(rText, 0);
      canvas.rotate(pi / 2);

      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();

      start += sweep;
    }

    // dış çerçeve
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = Colors.white70,
    );

    // hafif parlama / vignette
    final radial = RadialGradient(
      colors: [
        Colors.white.withOpacity(0.12),
        Colors.transparent,
        Colors.black.withOpacity(0.20),
      ],
      stops: const [0.0, 0.65, 1.0],
    );
    final overlay = Paint()
      ..shader = radial.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    canvas.drawCircle(center, radius, overlay);
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) => true;
}

/// === Sonuç Overlay (popup) ===
/// (İstersen daha sonra main.dart içinde showDialog ile açarsın)
class ResultOverlay extends StatelessWidget {
  const ResultOverlay({
    super.key,
    required this.title,
    required this.valueBig,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String valueBig;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final w = min(MediaQuery.of(context).size.width * 0.86, 420);

    return Center(
      child: Container(
        width: w,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xCC1A2226),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white30, width: 1.2),
          boxShadow: const [BoxShadow(blurRadius: 24, color: Colors.black54)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(subtitle!, style: const TextStyle(color: kTextSoft)),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              valueBig,
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

/// === Player Kart Görünümü (ss'lere benzer) ===
class PlayerCardView extends StatelessWidget {
  const PlayerCardView({super.key, required this.career});
  final PlayerCareer career;

  @override
  Widget build(BuildContext context) {
    final p = career.profile;
    final s = career.stats;

    final w = min(MediaQuery.of(context).size.width * 0.80, 360);

    return Container(
      width: w,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white24, width: 1.2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6B747B),
            Color(0xFF2D3338),
            Color(0xFF7E878D),
          ],
        ),
        boxShadow: const [
          BoxShadow(blurRadius: 22, color: Colors.black54),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${career.overall}',
                style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    career.positionShort,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  _flagGermany(),
                ],
              ),
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(Icons.person, size: 42, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Text(
            (p.lastName.isEmpty ? p.firstName : p.lastName).toUpperCase(),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            p.positionLabel,
            style: const TextStyle(color: kTextSoft, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 10),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),

          // 2 satır 3'lü stat kutuları
          Row(
            children: [
              Expanded(child: StatBox(label: 'HIZ', value: s.pace)),
              const SizedBox(width: 12),
              Expanded(child: StatBox(label: 'ŞUT', value: s.shot)),
              const SizedBox(width: 12),
              Expanded(child: StatBox(label: 'PAS', value: s.pass)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: StatBox(label: 'DRI', value: s.drib)),
              const SizedBox(width: 12),
              Expanded(child: StatBox(label: 'DEF', value: s.def)),
              const SizedBox(width: 12),
              Expanded(child: StatBox(label: 'FİZ', value: s.phy)),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _flagGermany() {
    return Container(
      width: 44,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black38),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.red, Colors.yellow],
        ),
      ),
    );
  }
}

/// Stat kutusu (ss’deki gri kareler gibi)
class StatBox extends StatelessWidget {
  const StatBox({super.key, required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x332A3C44),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24, width: 1.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$value',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: kTextSoft,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// === Form alanları (Create Player ekranında kullanırsın) ===
class GlassTextField extends StatelessWidget {
  const GlassTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return _GlassFieldShell(
      label: label,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24),
          border: InputBorder.none,
          isCollapsed: true,
          contentPadding: const EdgeInsets.only(top: 12),
        ),
      ),
    );
  }
}

class GlassDropdown<T> extends StatelessWidget {
  const GlassDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return _GlassFieldShell(
      label: label,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          dropdownColor: const Color(0xFF101B20),
          iconEnabledColor: Colors.white70,
          style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
    );
  }
}

class _GlassFieldShell extends StatelessWidget {
  const _GlassFieldShell({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: kGlassStrong,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.white70,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
