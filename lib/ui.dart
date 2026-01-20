import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// =======================================================
///  MODEL + DATA
/// =======================================================

enum Position { gk, def, mid, fwd }

extension PositionX on Position {
  String get label {
    switch (this) {
      case Position.gk:
        return 'Kaleci';
      case Position.def:
        return 'Defans';
      case Position.mid:
        return 'Orta Saha';
      case Position.fwd:
        return 'Forvet';
    }
  }
}

class League {
  final String id;
  final String name;
  final String country;
  final int tier; // 1 = top
  final int teamCount;
  final List<String> teams; // boşsa otomatik placeholder

  const League({
    required this.id,
    required this.name,
    required this.country,
    required this.tier,
    required this.teamCount,
    this.teams = const [],
  });

  List<String> resolvedTeams() {
    if (teams.isNotEmpty) return teams;
    return List.generate(teamCount, (i) => '$name FC ${i + 1}');
  }
}

/// Avrupa için 34 “büyük lig” iskeleti.
/// Bazılarında gerçek takım listesi var, diğerleri placeholder.
final List<League> europe34 = [
  // Top 5
  const League(
    id: 'eng_pl',
    name: 'Premier League',
    country: 'İngiltere',
    tier: 1,
    teamCount: 20,
    teams: [
      'Manchester City','Arsenal','Liverpool','Manchester United','Chelsea',
      'Tottenham','Newcastle','Aston Villa','West Ham','Brighton',
      'Everton','Wolves','Crystal Palace','Brentford','Fulham',
      'Nottingham Forest','Bournemouth','Leicester','Southampton','Leeds',
    ],
  ),
  const League(
    id: 'esp_ll',
    name: 'LaLiga',
    country: 'İspanya',
    tier: 1,
    teamCount: 20,
    teams: [
      'Real Madrid','Barcelona','Atlético Madrid','Sevilla','Real Sociedad',
      'Villarreal','Athletic Bilbao','Valencia','Real Betis','Celta Vigo',
      'Getafe','Osasuna','Mallorca','Girona','Alavés',
      'Rayo Vallecano','Las Palmas','Leganés','Granada','Espanyol',
    ],
  ),
  const League(
    id: 'ger_buli',
    name: 'Bundesliga',
    country: 'Almanya',
    tier: 1,
    teamCount: 18,
    teams: [
      'Bayern Münih','Dortmund','Bayer Leverkusen','RB Leipzig','Frankfurt',
      'Stuttgart','Werder Bremen','Wolfsburg','Augsburg','Union Berlin',
      'Mainz','Freiburg','Köln','Hamburg','St. Pauli',
      'Heidenheim','Hoffenheim','M\'gladbach',
    ],
  ),
  const League(
    id: 'ita_sa',
    name: 'Serie A',
    country: 'İtalya',
    tier: 1,
    teamCount: 20,
    teams: [
      'Inter','Milan','Juventus','Napoli','Roma',
      'Lazio','Atalanta','Fiorentina','Bologna','Torino',
      'Genoa','Udinese','Cagliari','Sassuolo','Lecce',
      'Verona','Empoli','Parma','Venezia','Como',
    ],
  ),
  const League(
    id: 'fra_l1',
    name: 'Ligue 1',
    country: 'Fransa',
    tier: 1,
    teamCount: 18,
    teams: [
      'PSG','Marseille','Lyon','Monaco','Lille',
      'Rennes','Nice','Lens','Nantes','Strasbourg',
      'Montpellier','Toulouse','Brest','Reims','Metz',
      'Le Havre','Angers','Auxerre',
    ],
  ),

  // Türkiye + Portekiz + Hollanda + Belçika
  const League(
    id: 'tr_super',
    name: 'Süper Lig',
    country: 'Türkiye',
    tier: 2,
    teamCount: 20,
    teams: [
      'Galatasaray','Fenerbahçe','Beşiktaş','Trabzonspor','Başakşehir',
      'Konyaspor','Antalyaspor','Alanyaspor','Kayserispor','Rizespor',
      'Gaziantep FK','Hatayspor','Ankaragücü','Karagümrük','Göztepe',
      'Samsunspor','Kasımpaşa','Adana Demirspor','Sivasspor','Bursaspor',
    ],
  ),
  const League(id: 'por_lp', name: 'Primeira Liga', country: 'Portekiz', tier: 2, teamCount: 18),
  const League(id: 'ned_ere', name: 'Eredivisie', country: 'Hollanda', tier: 2, teamCount: 18),
  const League(id: 'bel_pl', name: 'Pro League', country: 'Belçika', tier: 2, teamCount: 16),

  // 2. ligler
  const League(id: 'eng_ch', name: 'Championship', country: 'İngiltere', tier: 2, teamCount: 24),
  const League(id: 'esp_sd', name: 'Segunda', country: 'İspanya', tier: 2, teamCount: 22),
  const League(id: 'ger_2b', name: '2. Bundesliga', country: 'Almanya', tier: 2, teamCount: 18),
  const League(id: 'ita_sb', name: 'Serie B', country: 'İtalya', tier: 2, teamCount: 20),
  const League(id: 'fra_l2', name: 'Ligue 2', country: 'Fransa', tier: 2, teamCount: 20),

  // Diğer Avrupa ligleri (tier 3-4 iskelet)
  const League(id: 'sco_sp', name: 'Scottish Premiership', country: 'İskoçya', tier: 3, teamCount: 12),
  const League(id: 'aut_bl', name: 'Bundesliga', country: 'Avusturya', tier: 3, teamCount: 12),
  const League(id: 'sui_sl', name: 'Super League', country: 'İsviçre', tier: 3, teamCount: 12),
  const League(id: 'den_sl', name: 'Superliga', country: 'Danimarka', tier: 3, teamCount: 12),
  const League(id: 'nor_el', name: 'Eliteserien', country: 'Norveç', tier: 3, teamCount: 16),
  const League(id: 'swe_as', name: 'Allsvenskan', country: 'İsveç', tier: 3, teamCount: 16),
  const League(id: 'gre_sl', name: 'Super League', country: 'Yunanistan', tier: 3, teamCount: 14),
  const League(id: 'irl_pl', name: 'Premier Division', country: 'İrlanda', tier: 4, teamCount: 10),
  const League(id: 'cze_fl', name: 'First League', country: 'Çekya', tier: 4, teamCount: 16),
  const League(id: 'pol_eks', name: 'Ekstraklasa', country: 'Polonya', tier: 4, teamCount: 18),
  const League(id: 'cro_hnl', name: 'HNL', country: 'Hırvatistan', tier: 4, teamCount: 10),
  const League(id: 'srb_sl', name: 'SuperLiga', country: 'Sırbistan', tier: 4, teamCount: 16),
  const League(id: 'rou_l1', name: 'Liga I', country: 'Romanya', tier: 4, teamCount: 16),
  const League(id: 'bul_fl', name: 'First League', country: 'Bulgaristan', tier: 4, teamCount: 16),
  const League(id: 'hun_nb1', name: 'NB I', country: 'Macaristan', tier: 4, teamCount: 12),
  const League(id: 'svk_fl', name: 'Fortuna Liga', country: 'Slovakya', tier: 4, teamCount: 12),
  const League(id: 'slo_pr', name: 'PrvaLiga', country: 'Slovenya', tier: 4, teamCount: 10),
  const League(id: 'isl_pl', name: 'Úrvalsdeild', country: 'İzlanda', tier: 4, teamCount: 12),
  const League(id: 'fin_vl', name: 'Veikkausliiga', country: 'Finlandiya', tier: 4, teamCount: 12),
  const League(id: 'ukr_upl', name: 'UPL', country: 'Ukrayna', tier: 4, teamCount: 16),
  const League(id: 'rus_rpl', name: 'RPL', country: 'Rusya', tier: 4, teamCount: 16),
  const League(id: 'ned_ed', name: 'Eerste Divisie', country: 'Hollanda', tier: 3, teamCount: 20),
  const League(id: 'por_l2', name: 'Liga Portugal 2', country: 'Portekiz', tier: 3, teamCount: 18),
];

League leagueById(String id) => europe34.firstWhere((l) => l.id == id);

class Stats {
  int pac, sho, pas, dri, def, phy;
  Stats(this.pac, this.sho, this.pas, this.dri, this.def, this.phy);

  Map<String, dynamic> toJson() => {'pac': pac, 'sho': sho, 'pas': pas, 'dri': dri, 'def': def, 'phy': phy};
  static Stats fromJson(Map<String, dynamic> j) => Stats(j['pac'], j['sho'], j['pas'], j['dri'], j['def'], j['phy']);
}

class Career {
  String first;
  String last;
  String country;
  Position pos;
  int number;

  String leagueId;
  String team;

  int age;
  int season;
  int contractYearsLeft;
  int trophies;

  Stats stats;
  int overall;
  double marketValueM;

  Career({
    required this.first,
    required this.last,
    required this.country,
    required this.pos,
    required this.number,
    required this.leagueId,
    required this.team,
    required this.age,
    required this.season,
    required this.contractYearsLeft,
    required this.trophies,
    required this.stats,
    required this.overall,
    required this.marketValueM,
  });

  String get name => ('$first ${last.trim()}').trim();

  Map<String, dynamic> toJson() => {
        'first': first,
        'last': last,
        'country': country,
        'pos': pos.name,
        'number': number,
        'leagueId': leagueId,
        'team': team,
        'age': age,
        'season': season,
        'contractYearsLeft': contractYearsLeft,
        'trophies': trophies,
        'stats': stats.toJson(),
        'overall': overall,
        'marketValueM': marketValueM,
      };

  static Career fromJson(Map<String, dynamic> j) => Career(
        first: j['first'],
        last: j['last'],
        country: j['country'],
        pos: Position.values.firstWhere((p) => p.name == j['pos']),
        number: j['number'],
        leagueId: j['leagueId'],
        team: j['team'],
        age: j['age'],
        season: j['season'],
        contractYearsLeft: j['contractYearsLeft'],
        trophies: j['trophies'],
        stats: Stats.fromJson(j['stats']),
        overall: j['overall'],
        marketValueM: (j['marketValueM'] as num).toDouble(),
      );
}

/// =======================================================
///  ENGINE (ağırlıklar + hesaplar)
/// =======================================================

final _rng = Random();

int computeOverall(Stats s, Position p) {
  double o;
  switch (p) {
    case Position.fwd:
      o = s.pac * 0.15 + s.sho * 0.35 + s.pas * 0.10 + s.dri * 0.20 + s.def * 0.05 + s.phy * 0.15;
      break;
    case Position.mid:
      o = s.pac * 0.10 + s.sho * 0.15 + s.pas * 0.25 + s.dri * 0.20 + s.def * 0.15 + s.phy * 0.15;
      break;
    case Position.def:
      o = s.pac * 0.10 + s.sho * 0.05 + s.pas * 0.10 + s.dri * 0.10 + s.def * 0.40 + s.phy * 0.25;
      break;
    case Position.gk:
      o = s.pac * 0.05 + s.sho * 0.05 + s.pas * 0.10 + s.dri * 0.10 + s.def * 0.45 + s.phy * 0.25;
      break;
  }
  return o.round().clamp(1, 99);
}

Stats statsFromOverall(int base, Position pos) {
  int j(int v) => (v + _rng.nextInt(9) - 4).clamp(30, 99);
  int pac = base, sho = base, pas = base, dri = base, def = base, phy = base;

  switch (pos) {
    case Position.fwd:
      pac = base + 5; sho = base + 6; pas = base - 6; dri = base + 3; def = base - 18; phy = base - 2;
      break;
    case Position.mid:
      pac = base - 2; sho = base - 2; pas = base + 5; dri = base + 3; def = base - 2; phy = base - 1;
      break;
    case Position.def:
      pac = base - 6; sho = base - 18; pas = base - 6; dri = base - 8; def = base + 10; phy = base + 6;
      break;
    case Position.gk:
      pac = base - 20; sho = base - 25; pas = base - 5; dri = base - 15; def = base + 12; phy = base + 3;
      break;
  }

  return Stats(j(pac), j(sho), j(pas), j(dri), j(def), j(phy));
}

double marketValueM({
  required int overall,
  required int age,
  required int leagueTier,
  required int trophies,
}) {
  // oyun tadında (sonra gerçekçi yaparız)
  final base = pow(max(0, overall - 50), 2) / 18; // rating artınca hızlı büyür
  final ageMul = age <= 23 ? 1.25 : age <= 27 ? 1.10 : age <= 30 ? 0.95 : 0.80;
  final tierMul = leagueTier == 1 ? 1.40 : leagueTier == 2 ? 1.15 : leagueTier == 3 ? 0.95 : 0.80;
  final trophyMul = 1.0 + min(0.6, trophies * 0.05);
  return ((base * ageMul * tierMul * trophyMul) / 10).clamp(0.1, 350.0);
}

/// Ağırlıklı seçim (1%, 20%, 40% gibi)
class Weighted<T> {
  final T value;
  final int weight; // pozitif
  const Weighted(this.value, this.weight);
}

T pickWeighted<T>(List<Weighted<T>> items) {
  final total = items.fold<int>(0, (a, b) => a + b.weight);
  final r = _rng.nextInt(total);
  int acc = 0;
  for (final it in items) {
    acc += it.weight;
    if (r < acc) return it.value;
  }
  return items.last.value;
}

/// =======================================================
///  STORAGE
/// =======================================================

class Store {
  static const _key = 'career_v2';

  static Future<Career?> load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null) return null;
    try {
      return Career.fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  static Future<void> save(Career c) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, jsonEncode(c.toJson()));
  }

  static Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_key);
  }
}

/// =======================================================
///  UI ROOT
/// =======================================================

class Root extends StatefulWidget {
  const Root({super.key});
  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  Career? career;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final c = await Store.load();
    if (!mounted) return;
    setState(() {
      career = c;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return career == null
        ? StartScreen(
            onContinue: null,
            onNew: () async {
              final created = await Navigator.push<Career>(
                context,
                MaterialPageRoute(builder: (_) => const CreatePlayerScreen()),
              );
              if (created != null) {
                await Store.save(created);
                setState(() => career = created);
              }
            },
          )
        : CareerShell(
            career: career!,
            onReset: () async {
              await Store.clear();
              setState(() => career = null);
            },
            onSave: (c) async {
              await Store.save(c);
              setState(() => career = c);
            },
          );
  }
}

/// =======================================================
///  START
/// =======================================================

class StartScreen extends StatelessWidget {
  final VoidCallback onNew;
  final VoidCallback? onContinue;

  const StartScreen({super.key, required this.onNew, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return _Bg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Text('Kariyer', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w300)),
                const SizedBox(height: 8),
                Text('Avrupa (34 lig) • Çarklar: Lig/Takım • Reyting • Sözleşme • Transfer • Kupa',
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(.65))),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: _BigTile(
                        title: 'Yeni Kariyer',
                        subtitle: 'Başla',
                        icon: Icons.add,
                        onTap: onNew,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _BigTile(
                        title: 'Devam Et',
                        subtitle: onContinue == null ? 'Kayıt yok' : 'Devam',
                        icon: Icons.play_arrow,
                        disabled: onContinue == null,
                        onTap: onContinue ?? () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('Not: Bu sürüm “çekirdek” — görünüş/kurallarını beraber netleştirip güçlendireceğiz.',
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 12)),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// =======================================================
///  CREATE PLAYER
/// =======================================================

class CreatePlayerScreen extends StatefulWidget {
  const CreatePlayerScreen({super.key});
  @override
  State<CreatePlayerScreen> createState() => _CreatePlayerScreenState();
}

class _CreatePlayerScreenState extends State<CreatePlayerScreen> {
  final firstCtrl = TextEditingController(text: 'Player');
  final lastCtrl = TextEditingController();

  String country = 'Türkiye';
  Position pos = Position.fwd;
  int number = 9;

  League league = europe34.first;
  String team = '';

  @override
  void initState() {
    super.initState();
    league = leagueById('ger_buli');
    team = league.resolvedTeams().first;
  }

  @override
  void dispose() {
    firstCtrl.dispose();
    lastCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Bg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Oyuncu Oluştur')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Oyuncu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _Input(label: 'İsim', controller: firstCtrl)),
                      const SizedBox(width: 10),
                      Expanded(child: _Input(label: 'Soy İsim', controller: lastCtrl)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Dropdown<String>(
                    label: 'Ülke',
                    value: country,
                    items: const ['Türkiye','Almanya','İngiltere','İspanya','İtalya','Fransa','Hollanda','Portekiz'],
                    onChanged: (v) => setState(() => country = v!),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _Dropdown<Position>(
                          label: 'Pozisyon',
                          value: pos,
                          items: Position.values,
                          itemLabel: (p) => p.label,
                          onChanged: (v) => setState(() => pos = v!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Dropdown<int>(
                          label: 'Numara',
                          value: number,
                          items: List.generate(30, (i) => i + 1),
                          onChanged: (v) => setState(() => number = v!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Lig / Takım', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  _Dropdown<League>(
                    label: 'Lig (Avrupa 34)',
                    value: league,
                    items: europe34,
                    itemLabel: (l) => '${l.name} (${l.country})',
                    onChanged: (v) {
                      setState(() {
                        league = v!;
                        team = league.resolvedTeams().first;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _Dropdown<String>(
                    label: 'Takım',
                    value: team,
                    items: league.resolvedTeams(),
                    onChanged: (v) => setState(() => team = v!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Başlangıç Reytingi (Ağırlıklı)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text('60–66 çok sık • 67–74 orta • 75+ nadir', style: TextStyle(color: Colors.white.withOpacity(.7))),
                  const SizedBox(height: 10),
                  _PrimaryButton(
                    text: 'Reyting Çarkı',
                    icon: Icons.casino,
                    onTap: () async {
                      final base = await showWeightedWheel<int>(
                        context: context,
                        title: 'Başlangıç Reytingi',
                        items: ratingWeights(),
                        label: (v) => v.toString(),
                      );
                      if (base == null) return;

                      final st = statsFromOverall(base, pos);
                      final ovr = computeOverall(st, pos);
                      final mv = marketValueM(overall: ovr, age: 18, leagueTier: league.tier, trophies: 0);

                      final career = Career(
                        first: firstCtrl.text.trim().isEmpty ? 'Player' : firstCtrl.text.trim(),
                        last: lastCtrl.text.trim(),
                        country: country,
                        pos: pos,
                        number: number,
                        leagueId: league.id,
                        team: team,
                        age: 18,
                        season: 1,
                        contractYearsLeft: 3,
                        trophies: 0,
                        stats: st,
                        overall: ovr,
                        marketValueM: mv,
                      );

                      if (!mounted) return;
                      Navigator.pop(context, career); // Root'a dön
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Weighted<int>> ratingWeights() {
  // “her şey eşit olmasın” — ağırlık örneği
  // 60-66: %~60, 67-74: %~35, 75+: %~5
  final items = <Weighted<int>>[];
  void add(int v, int w) => items.add(Weighted(v, w));
  for (int v = 60; v <= 66; v++) add(v, 20); // 7*20=140
  for (int v = 67; v <= 74; v++) add(v, 12); // 8*12=96
  for (int v = 75; v <= 79; v++) add(v, 3);  // 5*3=15
  for (int v = 80; v <= 86; v++) add(v, 1);  // 7*1=7
  return items;
}

/// =======================================================
///  CAREER SHELL
/// =======================================================

class CareerShell extends StatefulWidget {
  final Career career;
  final Future<void> Function(Career c) onSave;
  final Future<void> Function() onReset;

  const CareerShell({super.key, required this.career, required this.onSave, required this.onReset});

  @override
  State<CareerShell> createState() => _CareerShellState();
}

class _CareerShellState extends State<CareerShell> {
  late Career c;
  int tab = 0;

  @override
  void initState() {
    super.initState();
    c = widget.career;
  }

  Future<void> commit(Career updated) async {
    updated.overall = computeOverall(updated.stats, updated.pos);
    final league = leagueById(updated.leagueId);
    updated.marketValueM = marketValueM(
      overall: updated.overall,
      age: updated.age,
      leagueTier: league.tier,
      trophies: updated.trophies,
    );
    await widget.onSave(updated);
    if (!mounted) return;
    setState(() => c = updated);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CareerPage(c: c, onUpdate: commit),
      WheelsPage(c: c, onUpdate: commit),
      SettingsPage(onReset: widget.onReset),
    ];

    return _Bg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: pages[tab]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (i) => setState(() => tab = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.person), label: 'Kariyer'),
            NavigationDestination(icon: Icon(Icons.casino), label: 'Çarklar'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Ayarlar'),
          ],
        ),
      ),
    );
  }
}

class CareerPage extends StatelessWidget {
  final Career c;
  final Future<void> Function(Career) onUpdate;

  const CareerPage({super.key, required this.c, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final league = leagueById(c.leagueId);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${c.name}\n${c.pos.label}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
            ),
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withOpacity(.10),
              child: Text('${c.overall}', style: const TextStyle(fontWeight: FontWeight.w900)),
            )
          ],
        ),
        const SizedBox(height: 8),
        Text('${league.name} • ${c.team}   |  Sezon ${c.season} • Yaş ${c.age}',
            style: TextStyle(color: Colors.white.withOpacity(.7))),
        const SizedBox(height: 12),
        _Card(
          child: Row(
            children: [
              Expanded(child: _StatBox(label: 'Piyasa', value: '€${c.marketValueM.toStringAsFixed(1)}M')),
              const SizedBox(width: 10),
              Expanded(child: _StatBox(label: 'Kupa', value: '${c.trophies}')),
              const SizedBox(width: 10),
              Expanded(child: _StatBox(label: 'Sözl.', value: '${c.contractYearsLeft}y')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Statlar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _MiniStat('HIZ', c.stats.pac)),
                Expanded(child: _MiniStat('ŞUT', c.stats.sho)),
                Expanded(child: _MiniStat('PAS', c.stats.pas)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _MiniStat('DRI', c.stats.dri)),
                Expanded(child: _MiniStat('DEF', c.stats.def)),
                Expanded(child: _MiniStat('FİZ', c.stats.phy)),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}

class WheelsPage extends StatelessWidget {
  final Career c;
  final Future<void> Function(Career) onUpdate;

  const WheelsPage({super.key, required this.c, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final league = leagueById(c.leagueId);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Çarklar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),

        _PrimaryButton(
          text: 'Lig Çarkı (Avrupa 34)',
          icon: Icons.public,
          onTap: () async {
            final picked = await showWeightedWheel<League>(
              context: context,
              title: 'Lig',
              items: leagueWeights(),
              label: (l) => l.name,
            );
            if (picked == null) return;

            final newTeam = picked.resolvedTeams()[_rng.nextInt(picked.teamCount)];
            final updated = c
              ..leagueId = picked.id
              ..team = newTeam;
            await onUpdate(updated);
            if (context.mounted) showDialog(context: context, builder: (_) => _ResultDialog('Lig', picked.name, newTeam));
          },
        ),
        const SizedBox(height: 10),

        _PrimaryButton(
          text: 'Takım Çarkı',
          icon: Icons.sports_soccer,
          onTap: () async {
            final teams = league.resolvedTeams();
            final picked = await showWheel<String>(
              context: context,
              title: 'Takım',
              items: teams,
              label: (t) => t,
            );
            if (picked == null) return;
            final updated = c..team = picked;
            await onUpdate(updated);
            if (context.mounted) showDialog(context: context, builder: (_) => _ResultDialog('Takım', picked, null));
          },
        ),
        const SizedBox(height: 10),

        _PrimaryButton(
          text: 'Sözleşme Çarkı',
          icon: Icons.description,
          onTap: () async {
            final picked = await showWeightedWheel<int>(
              context: context,
              title: 'Sözleşme (yıl)',
              items: const [
                Weighted(1, 10),
                Weighted(2, 22),
                Weighted(3, 30),
                Weighted(4, 20),
                Weighted(5, 8),
              ],
              label: (v) => '$v yıl',
            );
            if (picked == null) return;
            final updated = c..contractYearsLeft = picked;
            await onUpdate(updated);
            if (context.mounted) showDialog(context: context, builder: (_) => _ResultDialog('Sözleşme', '$picked yıl', null));
          },
        ),
        const SizedBox(height: 10),

        _PrimaryButton(
          text: 'Transfer Çarkı (Ağırlıklı)',
          icon: Icons.swap_horiz,
          onTap: () async {
            final outcome = await showWeightedWheel<String>(
              context: context,
              title: 'Transfer',
              items: const [
                Weighted('Teklif yok', 40),
                Weighted('Kiralık teklif', 20),
                Weighted('Transfer teklif', 20),
                Weighted('Sözleşme uzatma', 12),
                Weighted('Serbest kaldın', 6),
                Weighted('Büyük kulüp ilgisi', 2),
              ],
              label: (v) => v,
            );
            if (outcome == null) return;

            Career updated = c;

            if (outcome == 'Sözleşme uzatma') {
              updated = c..contractYearsLeft = min(5, c.contractYearsLeft + 1);
            } else if (outcome == 'Serbest kaldın') {
              final newLeague = await showWeightedWheel<League>(
                context: context,
                title: 'Yeni Lig',
                items: leagueWeights(),
                label: (l) => l.name,
              );
              if (newLeague == null) return;
              final newTeam = newLeague.resolvedTeams()[_rng.nextInt(newLeague.teamCount)];
              updated = c
                ..leagueId = newLeague.id
                ..team = newTeam
                ..contractYearsLeft = 2;
            } else if (outcome == 'Transfer teklif' || outcome == 'Büyük kulüp ilgisi') {
              final teams = league.resolvedTeams().where((t) => t != c.team).toList();
              if (teams.isNotEmpty) updated = c..team = teams[_rng.nextInt(teams.length)];
            }

            await onUpdate(updated);
            if (context.mounted) showDialog(context: context, builder: (_) => _ResultDialog('Transfer', outcome, '${leagueById(updated.leagueId).name} • ${updated.team}'));
          },
        ),
        const SizedBox(height: 10),

        _PrimaryButton(
          text: 'Kupa Çarkı',
          icon: Icons.emoji_events,
          onTap: () async {
            final cup = await showWeightedWheel<String>(
              context: context,
              title: 'Kupalar',
              items: const [
                Weighted('Kupa yok', 55),
                Weighted('Ulusal Kupa', 22),
                Weighted('Lig Şampiyonluğu', 15),
                Weighted('Avrupa Kupası', 6),
                Weighted('Süper Kupa', 2),
              ],
              label: (v) => v,
            );
            if (cup == null) return;

            final updated = c;
            if (cup != 'Kupa yok') updated.trophies += 1;
            await onUpdate(updated);

            if (context.mounted) showDialog(context: context, builder: (_) => _ResultDialog('Kupa', cup, null));
          },
        ),
        const SizedBox(height: 10),

        _PrimaryButton(
          text: 'Sezon İlerlet',
          icon: Icons.fast_forward,
          onTap: () async {
            final updated = simulateSeason(c);
            await onUpdate(updated);
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (_) => _ResultDialog(
                  'Sezon Bitti',
                  'Sezon ${updated.season}',
                  'OVR ${c.overall} → ${updated.overall}\nPiyasa €${updated.marketValueM.toStringAsFixed(1)}M',
                ),
              );
            }
          },
        ),

        const SizedBox(height: 10),
        _Card(
          child: Text(
            'Şu an: ${league.name} • ${c.team}\n'
            'Sonra ekleyeceğiz: lig sonuç simülasyonu, maç etkisi, sakatlık sistemi, gerçekçi transfer havuzu, kupa mantığı.',
            style: TextStyle(color: Colors.white.withOpacity(.65)),
          ),
        ),
      ],
    );
  }
}

List<Weighted<League>> leagueWeights() {
  // Top ligler daha olası (örnek ağırlık)
  final out = <Weighted<League>>[];
  for (final l in europe34) {
    final w = l.tier == 1 ? 22 : l.tier == 2 ? 16 : l.tier == 3 ? 10 : 7;
    out.add(Weighted(l, w));
  }
  return out;
}

Career simulateSeason(Career c) {
  // Yaş +1, sezon +1, sözleşme -1
  c.age += 1;
  c.season += 1;
  c.contractYearsLeft = max(0, c.contractYearsLeft - 1);

  // performans olayları (ağırlıklı)
  final event = pickWeighted<String>(const [
    Weighted('Normal sezon', 55),
    Weighted('İyi sezon (+)', 20),
    Weighted('Kötü sezon (-)', 12),
    Weighted('Sakatlık', 8),
    Weighted('Yılın çıkışı (++)', 5),
  ]);

  int bump(int v) => v.clamp(30, 99);

  void addAll(int d) {
    c.stats.pac = bump(c.stats.pac + d);
    c.stats.sho = bump(c.stats.sho + d);
    c.stats.pas = bump(c.stats.pas + d);
    c.stats.dri = bump(c.stats.dri + d);
    c.stats.def = bump(c.stats.def + d);
    c.stats.phy = bump(c.stats.phy + d);
  }

  switch (event) {
    case 'İyi sezon (+)':
      addAll(1 + _rng.nextInt(2)); // +1..+2
      break;
    case 'Kötü sezon (-)':
      addAll(-1);
      break;
    case 'Sakatlık':
      // hız/fizik düşsün
      c.stats.pac = bump(c.stats.pac - 2);
      c.stats.phy = bump(c.stats.phy - 2);
      break;
    case 'Yılın çıkışı (++)':
      addAll(2 + _rng.nextInt(2)); // +2..+3
      break;
    default:
      // Normal: küçük gelişim
      if (c.age <= 23) addAll(1);
      break;
  }

  c.overall = computeOverall(c.stats, c.pos);
  final league = leagueById(c.leagueId);
  c.marketValueM = marketValueM(overall: c.overall, age: c.age, leagueTier: league.tier, trophies: c.trophies);
  return c;
}

/// =======================================================
///  WHEEL UI HELPERS
/// =======================================================

Future<T?> showWheel<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required String Function(T) label,
}) {
  // eşit olasılık
  final weighted = items.map((e) => Weighted(e, 1)).toList();
  return showWeightedWheel(context: context, title: title, items: weighted, label: label);
}

Future<T?> showWeightedWheel<T>({
  required BuildContext context,
  required String title,
  required List<Weighted<T>> items,
  required String Function(T) label,
}) async {
  // FortuneWheel segmentleri aynı boyut. O yüzden:
  // - Görsel çark = sade liste
  // - Gerçek seçim = ağırlıklı pickWeighted(items)
  // Bu sayede %1-%20-%40 gibi olasılıkları gerçekten uygularız.
  final display = items.map((e) => e.value).toList();

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _WheelSheet<T>(
      title: title,
      displayItems: display,
      pick: () => pickWeighted(items),
      label: label,
    ),
  );
}

class _WheelSheet<T> extends StatefulWidget {
  final String title;
  final List<T> displayItems;
  final T Function() pick;
  final String Function(T) label;

  const _WheelSheet({
    required this.title,
    required this.displayItems,
    required this.pick,
    required this.label,
  });

  @override
  State<_WheelSheet<T>> createState() => _WheelSheetState<T>();
}

class _WheelSheetState<T> extends State<_WheelSheet<T>> {
  final StreamController<int> _selected = StreamController<int>();
  T? _picked;
  int? _pickedIndex;

  @override
  void dispose() {
    _selected.close();
    super.dispose();
  }

  void spin() {
    _picked = widget.pick();

    // Görselde seçilecek index’i bul (ilk eşleşen)
    final idx = widget.displayItems.indexWhere((e) => e == _picked);
    _pickedIndex = idx >= 0 ? idx : _rng.nextInt(widget.displayItems.length);
    _selected.add(_pickedIndex!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 14,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF11252A),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(.10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            SizedBox(
              height: 320,
              child: FortuneWheel(
                selected: _selected.stream,
                indicators: const [
                  FortuneIndicator(
                    alignment: Alignment.topCenter,
                    child: TriangleIndicator(color: Colors.white),
                  ),
                ],
                items: [
                  for (final it in widget.displayItems)
                    FortuneItem(
                      child: Text(widget.label(it), style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  _PrimaryButton(text: 'Çevir', icon: Icons.refresh, onTap: spin),
                  const SizedBox(height: 10),
                  _PrimaryButton(
                    text: 'İleri',
                    icon: Icons.arrow_forward,
                    onTap: () {
                      if (_picked == null) spin();
                      Navigator.pop(context, _picked);
                    },
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================================================
///  SETTINGS
/// =======================================================

class SettingsPage extends StatelessWidget {
  final Future<void> Function() onReset;
  const SettingsPage({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Ayarlar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        _PrimaryButton(
          text: 'Kariyeri Sıfırla',
          icon: Icons.delete_forever,
          onTap: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Emin misin?'),
                content: const Text('Kayıt silinecek.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Vazgeç')),
                  FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sil')),
                ],
              ),
            );
            if (ok == true) {
              await onReset();
            }
          },
        ),
      ],
    );
  }
}

/// =======================================================
///  UI PIECES
/// =======================================================

class _Bg extends StatelessWidget {
  final Widget child;
  const _Bg({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B1619), Color(0xFF0D1B1E)],
        ),
      ),
      child: child,
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: child,
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;

  const _PrimaryButton({required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

class _BigTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool disabled;

  const _BigTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(.10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28),
              const Spacer(),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(.65))),
            ],
          ),
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _Input({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final String Function(T)? itemLabel;
  final ValueChanged<T?> onChanged;

  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabel,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(itemLabel?.call(e) ?? e.toString()),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(.65), fontSize: 12)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final int val;
  const _MiniStat(this.label, this.val);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        children: [
          Text('$val', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(.65), fontSize: 12)),
        ],
      ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  final String title;
  final String big;
  final String? small;

  const _ResultDialog(this.title, this.big, this.small);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(big, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          if (small != null) ...[
            const SizedBox(height: 8),
            Text(small!, style: TextStyle(color: Colors.white.withOpacity(.7))),
          ]
        ],
      ),
      actions: [
        FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam')),
      ],
    );
  }
}
