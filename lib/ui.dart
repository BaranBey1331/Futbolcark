import 'dart:math';
import 'package:flutter/material.dart';
import 'models.dart';

const kBgTop = Color(0xFF0A1A20);
const kBgMid = Color(0xFF0E2B34);
const kBgBot = Color(0xFF0E232B);

const kGlass = Color(0x332A3C44);
const kBorder = Color(0xFF6D8B97);
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
      ),
    );
  }
}

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
      child: SafeArea(
        top: topPadding,
        child: child,
      ),
    );
  }
}

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
            color: kGlass,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: enabled ? const Color(kBorder.value) : Colors.white24, width: 1.2),
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
                    fontWeight: FontWeight.w600,
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
              color: kGlass,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(kBorder.value), width: 1.2),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: const TextStyle(fontWeight: FontWeight.w600),
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

class WheelView extends StatelessWidget {
  const WheelView({
    super.key,
    required this.segments,
    required this.rotationTurns,
  });

  final List<WheelSegment> segments;
  final double rotationTurns; // 0..1..n (turns)
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // tekerlek
          AnimatedRotation(
            turns: rotationTurns,
            duration: const Duration(milliseconds: 1),
            child: CustomPaint(
              painter: _WheelPainter(segments: segments),
              child: const SizedBox.expand(),
            ),
          ),
          // merkez top (futbol)
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
          // sağ pointer (videodaki beyaz çıkıntı)
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

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = Colors.white70;

    // dış halka gölge
    canvas.drawCircle(center, radius + 6, Paint()..color = Colors.black38);

    final total = segments.fold<double>(0, (a, b) => a + b.weight);
    double start = -pi / 2;

    for (final s in segments) {
      final sweep = (s.weight / total) * pi * 2;
      final paint = Paint()..color = s.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        true,
        paint,
      );

      // segment çizgileri
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

      // yazı
      final mid = start + sweep / 2;
      final textPainter = TextPainter(
        text: TextSpan(
          text: s.label,
          style: TextStyle(
            color: s.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: radius);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(mid);

      // dışa doğru
      final rText = radius * 0.72;
      canvas.translate(rText, 0);
      canvas.rotate(pi / 2);

      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();

      start += sweep;
    }

    // dış çerçeve
    canvas.drawCircle(center, radius, borderPaint);

    // hafif radial highlight (metal hissi)
    final radial = RadialGradient(
      colors: [
        Colors.white.withOpacity(0.14),
        Colors.transparent,
        Colors.black.withOpacity(0.18),
      ],
      stops: const [0.0, 0.65, 1.0],
    );
    final overlay = Paint()..shader = radial.createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, overlay);
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) => true;
}

class ResultOverlay extends StatelessWidget {
  const ResultOverlay({
    super.key,
    required this.title,
    required this.valueBig,
    this.icon,
  });

  final String title;
  final String valueBig;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: min(MediaQuery.of(context).size.width * 0.84, 420),
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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              valueBig,
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.42,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerCardView extends StatelessWidget {
  const PlayerCardView({super.key, required this.career});

  final PlayerCareer career;

  @override
  Widget build(BuildContext context) {
    final p = career.profile;
    final s = career.stats;

    return Container(
      width: min(MediaQuery.of(context).size.width * 0.70, 340),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white24, width: 1.2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF616B73),
            Color(0xFF2D3338),
            Color(0xFF7C858B),
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
                style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    career.positionShort,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  // bayrak yerine basit şerit (assets yok)
                  Container(
                    width: 42,
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
                  ),
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
            p.lastName.isEmpty ? p.firstName : p.lastName,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 8,
            children: [
              _stat('HIZ', s.pace),
              _stat('ŞUT', s.shot),
              _stat('PAS', s.pass),
              _stat('DRI', s.drib),
              _stat('DEF', s.def),
              _stat('FİZ', s.phy),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _stat(String label, int v) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(width: 6),
        Text('$v', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
      ],
    );
  }
}
