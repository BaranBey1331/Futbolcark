import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models.dart';

/// v0.1 Alpha (0001)
class GameController extends ChangeNotifier {
  final Rng rng = Rng();

  // 6 slot demo
  final List<PlayerCareer?> slots = List<PlayerCareer?>.filled(6, null);

  int selectedSlot = 0;
  PlayerCareer? get career => slots[selectedSlot];

  // --- LİG / TAKIM ---
  static const String germanLeague = 'Bundesliga';

  static const List<String> germanTeams = <String>[
    'Bayern Münih',
    'Dortmund',
    'Bayer Leverkusen',
    'RB Leipzig',
    'Hamburg',
    'Köln',
    'Frankfurt',
    'Mainz',
    'Freiburg',
    'Union Berlin',
    'Wolfsburg',
    'Stuttgart',
    'Hoffen',
    'Heiden',
    'Augsbu',
    'Werder',
    'St Pauli',
    'B Mön',
  ];

  /// Takım çarkı: eşit değil — güçlü takımlar daha yüksek olasılık.
  List<WheelSegment> teamWheel() {
    const red = Color(0xFFB12A2A);
    const blue = Color(0xFF2B6FD6);
    const yellow = Color(0xFFE7D33A);
    const black = Color(0xFF0B0E10);
    const green = Color(0xFF3AA05A);

    return <WheelSegment>[
      WheelSegment(label: 'Bayern Münih', weight: 0.20, color: red),
      WheelSegment(label: 'Dortmund', weight: 0.14, color: yellow, textColor: black),
      WheelSegment(label: 'Bayer Leverkusen', weight: 0.12, color: black),
      WheelSegment(label: 'RB Leipzig', weight: 0.10, color: blue),
      WheelSegment(label: 'Frankfurt', weight: 0.07, color: red),
      WheelSegment(label: 'Union Berlin', weight: 0.06, color: red),
      WheelSegment(label: 'Wolfsburg', weight: 0.05, color: green),
      WheelSegment(label: 'Freiburg', weight: 0.05, color: black),
      WheelSegment(label: 'Stuttgart', weight: 0.05, color: red),
      WheelSegment(label: 'Mainz', weight: 0.04, color: red),
      WheelSegment(label: 'Hamburg', weight: 0.04, color: blue),
      WheelSegment(label: 'Köln', weight: 0.03, color: red),
      WheelSegment(label: 'Werder', weight: 0.03, color: green),
      WheelSegment(label: 'St Pauli', weight: 0.02, color: red),
      WheelSegment(label: 'Hoffen', weight: 0.02, color: blue),
      WheelSegment(label: 'Heiden', weight: 0.02, color: blue),
      WheelSegment(label: 'Augsbu', weight: 0.01, color: red),
      WheelSegment(label: 'B Mön', weight: 0.01, color: black),
    ];
  }

  /// Asist çarkı
  List<WheelSegment> assistWheel() {
    const r1 = Color(0xFFB12A2A);
    const r2 = Color(0xFFE04A3A);
    const o1 = Color(0xFFE08A2A);
    const y1 = Color(0xFFE7D33A);
    const g1 = Color(0xFF3AA05A);
    const g2 = Color(0xFF2B7E52);
    const darkText = Color(0xFF101316);

    return [
      WheelSegment(label: '0-2', weight: 0.08, color: r1),
      WheelSegment(label: '3-4', weight: 0.10, color: r2),
      WheelSegment(label: '5-6', weight: 0.22, color: o1),
      WheelSegment(label: '7', weight: 0.22, color: y1, textColor: darkText),
      WheelSegment(
        label: '8',
        weight: 0.20,
        color: Color.lerp(y1, g1, 0.35)!,
        textColor: darkText,
      ),
      WheelSegment(label: '9', weight: 0.18, color: g1),
      WheelSegment(label: '10', weight: 0.10, color: g2),
    ];
  }

  /// Avrupa Kupası Puan
  List<WheelSegment> europeCupPointsWheel() {
    const g = Color(0xFF2B7E52);
    const y = Color(0xFFE7D33A);
    const o = Color(0xFFE08A2A);
    const r = Color(0xFFB12A2A);
    const darkText = Color(0xFF101316);

    return [
      WheelSegment(label: '0', weight: 0.10, color: g),
      WheelSegment(label: '15-20', weight: 0.18, color: g),
      WheelSegment(label: '21-24', weight: 0.14, color: y, textColor: darkText),
      WheelSegment(label: '9-10', weight: 0.16, color: o),
      WheelSegment(label: '11-12', weight: 0.22, color: y, textColor: darkText),
      WheelSegment(label: '3-4', weight: 0.14, color: o),
      WheelSegment(label: '27-28', weight: 0.06, color: r),
    ];
  }

  List<WheelSegment> contractWheel() {
    const c1 = Color(0xFF1F4EA3);
    const c2 = Color(0xFF2B7E52);
    const c3 = Color(0xFFE08A2A);
    const c4 = Color(0xFF6A2A7A);

    return [
      WheelSegment(label: '2', weight: 0.18, color: c1),
      WheelSegment(label: '3', weight: 0.32, color: c4),
      WheelSegment(label: '4', weight: 0.28, color: c3),
      WheelSegment(label: '5', weight: 0.22, color: c2),
    ];
  }

  // --- OYUNCU OLUŞTURMA ---
  void createCareerInSlot({
    required int slotIndex,
    required PlayerProfile profile,
  }) {
    selectedSlot = slotIndex;

    final teamSegs = teamWheel();
    final team = teamSegs[rng.weightedIndex(teamSegs.map((e) => e.weight).toList())].label;

    final overall = _calcOverall(profile.position);
    final stats = _calcStats(profile.position, overall);
    final mv = _calcMarketValueM(overall, profile.position);

    slots[slotIndex] = PlayerCareer(
      profile: profile,
      overall: overall,
      stats: stats,
      marketValueM: mv,
      leagueName: germanLeague,
      clubName: team,
      contractYears: 3,
    );

    notifyListeners();
  }

  void applyTeamResult(String team) {
    final c = career;
    if (c == null) return;
    slots[selectedSlot] = PlayerCareer(
      profile: c.profile,
      overall: c.overall,
      stats: c.stats,
      marketValueM: c.marketValueM,
      leagueName: c.leagueName,
      clubName: team,
      contractYears: c.contractYears,
    );
    notifyListeners();
  }

  void applyContractYears(int years) {
    final c = career;
    if (c == null) return;
    slots[selectedSlot] = PlayerCareer(
      profile: c.profile,
      overall: c.overall,
      stats: c.stats,
      marketValueM: c.marketValueM,
      leagueName: c.leagueName,
      clubName: c.clubName,
      contractYears: years,
    );
    notifyListeners();
  }

  int spinPickIndex(List<WheelSegment> segments) {
    return rng.weightedIndex(segments.map((e) => e.weight).toList());
  }

  // --- LİG TABLOSU (demo) ---
  List<LeagueTableRow> buildDemoLeagueTable() {
    final teams = List<String>.from(germanTeams);
    teams.remove('Bayern Münih');
    teams.remove('Dortmund');
    teams.remove('Bayer Leverkusen');
    teams.remove('Union Berlin');
    teams.insertAll(0, ['Bayer Leverkusen', 'Union Berlin', 'Bayern Münih', 'Dortmund']);

    final rows = <LeagueTableRow>[];

    for (int i = 0; i < teams.length; i++) {
      final strength = 1.0 - (i * 0.03);
      final w = max(0, (18 * strength).round());
      final d = rng.range(3, 9);
      final l = max(0, 34 - w - d);

      final gf = rng.range(35, 85) + (w ~/ 2);
      final ga = rng.range(20, 65) - (w ~/ 3);

      rows.add(LeagueTableRow(
        team: teams[i],
        played: 34,
        wins: w.clamp(0, 34),
        draws: d.clamp(0, 34),
        losses: l.clamp(0, 34),
        gf: gf.clamp(0, 120),
        ga: max(0, ga),
      ));
    }

    rows.sort((a, b) {
      final p = b.points.compareTo(a.points);
      if (p != 0) return p;
      final gd = b.gd.compareTo(a.gd);
      if (gd != 0) return gd;
      return b.gf.compareTo(a.gf);
    });

    return rows;
  }

  // --- FORMÜLLER ---
  int _calcOverall(Position p) {
    final base = rng.range(60, 79);
    final bump = rng.nextDouble();
    if (bump > 0.93) return rng.range(85, 92);
    if (bump > 0.80) return rng.range(80, 84);
    return base;
  }

  StatLine _calcStats(Position p, int ovr) {
    int clampInt(int v) => v.clamp(20, 99);

    final posBias = switch (p) {
      Position.gk => (pace: -10, shot: -30, pass: -10, drib: -15, def: 20, phy: 10),
      Position.cb => (pace: -5, shot: -20, pass: -10, drib: -10, def: 20, phy: 15),
      Position.lb || Position.rb => (pace: 10, shot: -10, pass: 5, drib: 5, def: 10, phy: 5),
      Position.cm => (pace: 5, shot: 0, pass: 15, drib: 10, def: 5, phy: 5),
      Position.cam => (pace: 5, shot: 10, pass: 15, drib: 15, def: -10, phy: 0),
      Position.lw || Position.rw => (pace: 15, shot: 10, pass: 5, drib: 15, def: -15, phy: -5),
      Position.st => (pace: 8, shot: 18, pass: -2, drib: 8, def: -20, phy: 10),
    };

    final pace = clampInt(ovr + rng.range(-8, 8) + posBias.pace);
    final shot = clampInt(ovr + rng.range(-10, 10) + posBias.shot);
    final pass = clampInt(ovr + rng.range(-10, 10) + posBias.pass);
    final drib = clampInt(ovr + rng.range(-10, 10) + posBias.drib);
    final def = clampInt(ovr + rng.range(-10, 10) + posBias.def);
    final phy = clampInt(ovr + rng.range(-10, 10) + posBias.phy);

    return (pace: pace, shot: shot, pass: pass, drib: drib, def: def, phy: phy);
  }

  int _calcMarketValueM(int ovr, Position p) {
    final posMul = switch (p) {
      Position.st || Position.cam || Position.lw || Position.rw => 1.25,
      Position.cm => 1.15,
      Position.lb || Position.rb => 1.05,
      Position.cb => 1.00,
      Position.gk => 0.85,
    };

    final x = max(0, ovr - 58);
    final base = pow(x.toDouble(), 1.85) * 0.12;
    final rnd = 0.85 + (rng.nextDouble() * 0.35);
    return max(1, (base * posMul * rnd).round());
  }
}
