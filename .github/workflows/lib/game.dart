import 'dart:math';

class Career {
  String name;
  String league;
  String team;
  int overall;
  double marketValue;

  Career({
    required this.name,
    required this.league,
    required this.team,
    required this.overall,
    required this.marketValue,
  });
}

class GameEngine {
  static final _rng = Random();

  static Career newCareer(String name) {
    final overall = 60 + _rng.nextInt(21); // 60–80
    return Career(
      name: name,
      league: 'Bundesliga',
      team: 'Bayern Münih',
      overall: overall,
      marketValue: _calcMarketValue(overall),
    );
  }

  static int spinRating() {
    return 60 + _rng.nextInt(21);
  }

  static double _calcMarketValue(int ovr) {
    return ((ovr - 50) * (ovr - 50)) / 15;
  }
}
