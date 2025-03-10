import 'package:flutter/material.dart';
import 'package:player_replacement/All%20Leagues/Bundesliga/Bundesliga.dart';
import 'package:player_replacement/All%20Leagues/Eredivise/Eredivise.dart';
import 'package:player_replacement/Home%20Page/homePage.dart';
import 'package:player_replacement/Player%20Positions/playerPositions.dart';
import 'package:player_replacement/Player%20Replacement/playerReplacement.dart';
import 'package:player_replacement/PlayerComparison/playerComparison.dart';
import 'All Leagues/allLeagues.dart';
import 'All Leagues/La Liga/LaLiga.dart';
import 'All Leagues/LigaPortugal/LigaPortugal.dart';
import 'All Leagues/Ligue 1/Ligue1.dart';
import 'All Leagues/Premier League/PremierLeague.dart';
import 'All Leagues/Serie A/SerieA.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Player Replacement',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => PlayerComparison(),
        '/PlayerReplacement': (context) => PlayerReplacement(),
        '/PlayerComparison': (context) => PlayerComparison(),
        '/AllTeams': (context) => AllLeagues(),
        '/PremierLeague': (context) => PremierLeague(),
        '/LaLiga': (context) => LaLiga(),
        '/Eredivise': (context) => Eredivise(),
        '/SerieA': (context) => SerieA(),
        '/Bundesliga': (context) => Bundesliga(),
        '/LigueOne': (context) => LigueOne(),
        '/LigaPortugal': (context) => LigaPortugal(),
        '/PlayerPositions': (context) => PlayerPositions(),
      },
    );
  }
}
