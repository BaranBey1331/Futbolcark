import 'dart:math';
import 'package:flutter/material.dart';

enum Position {
  gk('Kaleci', 'KL'),
  cb('Stoper', 'STP'),
  lb('Sol Bek', 'SLB'),
  rb('Sağ Bek', 'SGB'),
  cm('Orta Saha', 'OS'),
  cam('10 Numara', '10'),
  lw('Sol Kanat', 'SLK'),
  rw('Sağ Kanat', 'SGK'),
  st('Santrafor', 'SNT');

  const Position(this.tr, this.short);
  final String tr;
  final String short;
}

typedef StatLine = ({int pace, int shot, int pass, int drib, int def, int phy});

class PlayerProfile {
  PlayerProfile({
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.position,
    required this.shirtNumber,
  });

  final String firstName;
  final String lastName;
  final String country;
  final Position position;
  final int shirtNumber;

  String get fullName => '${firstName.trim()} ${lastName.trim()}'.trim();
}

class PlayerCareer {
  PlayerCareer({
    required this.profile,
    required this.overall,
    required this.stats,
    required this.marketValueM,
    required this.leagueName,
    required this.clubName,
    required this.contractYears,
  });

  final PlayerProfile profile;
  final int overall; // 50-99
  final StatLine stats;
  final int marketValueM; // milyon €
  final String leagueName;
  final String clubName;
  final int contractYears;

  String get positionShort => profile.position.short;
}

class WheelSegment {
  WheelSegment({
    required this.label,
    required this.weight,
    required this.color,
    this.textColor = Colors.white,
  });

  final String label;
  final double weight; // olasılık oranı
  final Color color;
  final Color textColor;
}

class LeagueTableRow {
  LeagueTableRow({
    required this.team,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.gf,
    required this.ga,
  });

  final String team;
  final int played, wins, draws, losses, gf, ga;

  int get points => wins * 3 + draws;
  int get gd => gf - ga;
}

class Rng {
  Rng([int? seed]) : _rng = Random(seed ?? DateTime.now().millisecondsSinceEpoch);
  final Random _rng;

  int nextInt(int max) => _rng.nextInt(max);
  double nextDouble() => _rng.nextDouble();

  int range(int min, int max) => min + _rng.nextInt(max - min + 1);

  T pick<T>(List<T> items) => items[_rng.nextInt(items.length)];

  int weightedIndex(List<double> weights) {
    final sum = weights.fold<double>(0, (a, b) => a + b);
    final r = nextDouble() * sum;
    double c = 0;
    for (int i = 0; i < weights.length; i++) {
      c += weights[i];
      if (r <= c) return i;
    }
    return weights.length - 1;
  }
}
