import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:player_replacement/API%20Models/bestPerformers.dart';
import 'package:player_replacement/API%20Models/standingsModel.dart';
import 'package:player_replacement/API%20Models/teamGSvsGCStats.dart';
import 'package:player_replacement/API%20Models/teamTackleStats.dart';
import 'package:player_replacement/API%20Models/topScorersModel.dart';
import 'package:player_replacement/Components/Widgets/LeaguesData.dart';
import 'package:player_replacement/Components/constants.dart';

class Bundesliga extends StatefulWidget {
  @override
  _BundesligaState createState() => _BundesligaState();
}

class _BundesligaState extends State<Bundesliga> {
  List<TeamStanding> standings = [];
  List<TopScorer> topScorers = [];
  bool isLoading = true;
  bool topPerformersLoading = true;
  bool teamGSvsGCStatsLoading = true;
  bool tackleVsTacklesWonLoading = true;
  List<PlayerStat> playerStats = [];
  List<TeamGoalScoredConcededStats> teamGSvsGCStats = [];
  List<TeamTackleStats> tackleVsTacklesWon = [];

  @override
  void initState() {
    super.initState();
    get_attack_vs_defence_charts_data();
    get_defensive_solidity_charts_data();
    fetchStandings();
    fetchTopScorers();
  }

  Future<void> get_attack_vs_defence_charts_data() async {
    try {
      final response = await http.get(
          Uri.parse("http://127.0.0.1:5000/attack_vs_defence_charts_data"),
          headers: {
            'league': 'Bundesliga',
          });
      if (response.statusCode == 200) {
        print({response.body});
        teamGSvsGCStats = parseTeamStats(response.body);
        setState(() {
          print(teamGSvsGCStats.length);
          teamGSvsGCStatsLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data");
    }
  }

  Future<void> get_defensive_solidity_charts_data() async {
    try {
      final response = await http
          .get(Uri.parse("http://127.0.0.1:5000/defensive_solidity"), headers: {
        'league': 'Bundesliga',
      });
      if (response.statusCode == 200) {
        print({response.body});
        tackleVsTacklesWon = parseTeamTackleStats(response.body);
        setState(() {
          print(tackleVsTacklesWon.length);
          tackleVsTacklesWonLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data $e");
    }
  }

  Future<void> fetchStandings() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/standings'),
        headers: {
          'X-Auth-Token': '157ed7af01e24ef496771bf1338cf2c6',
          'league': 'Bundesliga',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        standings = List.generate(
          data["Rank"].length,
          (index) => TeamStanding.fromJson(data, index),
        );
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load standings');
      }
    } catch (e) {
      print('Error fetching standings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchTopScorers() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/top_performers'),
        headers: {
          'X-Auth-Token': '157ed7af01e24ef496771bf1338cf2c6',
          'league': 'Bundesliga',
        },
      );

      print("Raw Response: ${response.body}"); // Debugging Step 1

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Decoded JSON. data is here: $data"); // Debugging Step 2

        if (data == null) {
          throw Exception("Invalid API response format");
        }
        BestPerformers bestPerformers = BestPerformers.fromJson(data);
        playerStats = [
          bestPerformers.topScorer,
          bestPerformers.topAssister,
          bestPerformers.cleanSheets
        ];
        print(playerStats);
        print("Extracted Data: $playerStats");
        setState(() {
          topPerformersLoading = false;
        });
      } else {
        throw Exception(
            "Failed to fetch scorers. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error fetching top scorers: $e');
      setState(() {
        topPerformersLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: h * 0.1,
        backgroundColor: kPrimaryColor,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: h * 0.03),
          child: Column(
            children: [
              Text(
                'DataFC',
                style: TextStyle(
                  color: kSecondaryColor,
                  fontFamily: 'Nevis',
                  fontSize: h * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The ultimate football data club',
                style: TextStyle(
                  color: kSecondaryColor,
                  fontFamily: 'Nevis',
                  fontSize: h * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: BuildTeamData(
        isLoading: isLoading,
        topScorersLoading: topPerformersLoading,
        standings: standings,
        playerStats: playerStats,
        tackleVsTacklesWonLoading: tackleVsTacklesWonLoading,
        teamGoalsStat: teamGSvsGCStats,
        teamTackleStat: tackleVsTacklesWon,
        teamGSvsGCStatsLoading: teamGSvsGCStatsLoading,
      ),
    );
  }
}
