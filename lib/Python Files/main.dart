import 'package:flutter/material.dart';
import 'package:player_replacement/Home%20Page/homePage.dart';
import 'package:player_replacement/Player%20Positions/playerPositions.dart';
import 'package:player_replacement/Player%20Replacement/playerReplacement.dart';
import '../All Leagues/allLeagues.dart';

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
        '/': (context) => Homepage(),
        '/PlayerReplacement': (context) => PlayerReplacement(),
        '/AllTeams': (context) => AllLeagues(),
        '/PlayerPositions': (context) => PlayerPositions(),
      },
    );
  }
}
