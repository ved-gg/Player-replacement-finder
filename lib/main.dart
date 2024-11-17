import 'package:flutter/material.dart';
import 'package:player_replacement/Player%20Replacement/playerReplacement.dart';
import 'package:player_replacement/Player%20Comparison/playerSelection.dart';

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
        '/': (context) => SelectPlayer(),
        '/PlayerReplacement': (context) => PlayerReplacement(),
        '/PlayerSelection': (context) => SelectPlayer(),
      },
    );
  }
}
