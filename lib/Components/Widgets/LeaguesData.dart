import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:player_replacement/API%20Models/bestPerformers.dart';
import 'package:player_replacement/API%20Models/standingsModel.dart';
import 'package:player_replacement/API%20Models/teamGSvsGCStats.dart';
import 'package:player_replacement/API%20Models/teamTackleStats.dart';
import 'package:player_replacement/Components/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:player_replacement/Components/Widgets/TeamsDashboard.dart';

class BuildTeamData extends StatefulWidget {
  String league;
  BuildTeamData({
    super.key,
    required this.league,
  });

  @override
  State<BuildTeamData> createState() => _BuildTeamDataState();
}

class _BuildTeamDataState extends State<BuildTeamData> {
  bool isLoading = true;
  bool topScorersLoading = true;
  bool teamGSvsGCStatsLoading = true;
  bool tackleVsTacklesWonLoading = true;
  List<TeamStanding> standings = [];
  List<TeamGoalScoredConcededStats> teamGoalsStat = [];
  List<TeamTackleStats> teamTackleStat = [];
  List<TeamGoalScoredConcededStats> teamGSvsGCStats = [];
  List<TeamTackleStats> tackleVsTacklesWon = [];
  bool topPerformersLoading = true;
  PlayerStats playerStats = PlayerStats(
    assisterImage: "",
    assistsProvided: "",
    cleanSheets: "",
    cleanSheetsImage: "",
    goalsScored: "",
    mostCSTeam: "",
    mostCleanSheets: "",
    scorerImage: "",
    topAssister: "",
    topAssisterTeam: "",
    topScorer: "",
    topScorerTeam: "",
  );

  @override
  void initState() {
    super.initState();
    fetchStandings();
    fetchTopScorers();
    get_attack_vs_defence_charts_data();
    get_defensive_solidity_charts_data();
  }

  Future<void> get_attack_vs_defence_charts_data() async {
    try {
      final response = await http.get(
          Uri.parse("http://127.0.0.1:5000/attack_vs_defence_charts_data"),
          headers: {
            'league': widget.league,
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
        'league': widget.league,
      });
      if (response.statusCode == 200) {
        // print({response.body});
        tackleVsTacklesWon = parseTeamTackleStats(response.body);
        setState(() {
          // print(tackleVsTacklesWon.length);
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
          'league': widget.league,
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
          'league': widget.league,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data == null) {
          throw Exception("Invalid API response format");
        }
        playerStats = PlayerStats.fromJson(data);
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
    final w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Text('STANDINGS',
                          style: TextStyle(
                            fontSize: h * 0.06,
                            color: kPrimaryColor,
                            fontFamily: 'Barcelona',
                          )),
                      DataTable(
                        dataRowMinHeight: h * 0.03,
                        dataRowMaxHeight: h * 0.06,
                        columnSpacing: w * 0.03 / 2,
                        columns: const [
                          DataColumn(label: Text("Rank")),
                          DataColumn(label: Text("Team")),
                          DataColumn(label: Text("W")),
                          DataColumn(label: Text("D")),
                          DataColumn(label: Text("L")),
                          DataColumn(label: Text("GF")),
                          DataColumn(label: Text("GA")),
                          DataColumn(label: Text("GD")),
                          DataColumn(label: Text("Points")),
                        ],
                        rows: standings.map((team) {
                          return DataRow(cells: [
                            DataCell(Text(team.rank.toString())),
                            DataCell(
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeamsDashboard(
                                        teamName: team.team,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  team.team,
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: h * 0.02,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(team.wins.toString())),
                            DataCell(Text(team.draws.toString())),
                            DataCell(Text(team.losses.toString())),
                            DataCell(Text(team.gf.toString())),
                            DataCell(Text(team.ga.toString())),
                            DataCell(Text(team.gd.toString())),
                            DataCell(Text(team.points.toString())),
                          ]);
                        }).toList(),
                      ),
                    ],
                  ),
            Container(
              height: h * 1.5,
              width: w * 0.68,
              child: Stack(
                children: [
                  Positioned(
                    top: h * 0.02,
                    left: w * 0.01 / 2,
                    child: topPerformersLoading
                        ? Center(
                            child: Container(
                              height: h * 0.5,
                              width: w * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Loading Top Peformers',
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: h * 0.03,
                                        fontFamily: 'League Spartan'),
                                  ),
                                  CircularProgressIndicator(),
                                ],
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                ),
                                height: h * 0.5,
                                width: w * 0.2,
                                child: Column(
                                  children: [
                                    Text(
                                      "TOP SCORER",
                                      style: TextStyle(
                                        fontSize: h * 0.05,
                                        color: kPrimaryColor,
                                        fontFamily: 'Barcelona',
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      foregroundImage: NetworkImage(
                                        playerStats.scorerImage,
                                      ),
                                      radius: w * 0.05,
                                    ),
                                    Text(
                                      playerStats.topScorer,
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: h * 0.03,
                                        fontFamily: 'League Spartan',
                                      ),
                                    ),
                                    Text(
                                      "${playerStats.goalsScored} GOALS",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Barcelona',
                                        fontSize: h * 0.025,
                                      ),
                                    ),
                                    Text(
                                      "${playerStats.topScorerTeam} ",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'League Spartan',
                                        fontSize: h * 0.015,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                ),
                                height: h * 0.5,
                                width: w * 0.2,
                                child: Column(
                                  children: [
                                    Text(
                                      "TOP ASSISTER",
                                      style: TextStyle(
                                        fontSize: h * 0.05,
                                        color: kPrimaryColor,
                                        fontFamily: 'Barcelona',
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      foregroundImage: NetworkImage(
                                        playerStats.assisterImage,
                                      ),
                                      radius: w * 0.05,
                                    ),
                                    Text(
                                      playerStats.topAssister,
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: h * 0.03,
                                        fontFamily: 'League Spartan',
                                      ),
                                    ),
                                    Text(
                                      "${playerStats.assistsProvided} ASSISTS",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Barcelona',
                                        fontSize: h * 0.025,
                                      ),
                                    ),
                                    Text(
                                      "${playerStats.topAssisterTeam} ",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'League Spartan',
                                        fontSize: h * 0.015,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                ),
                                height: h * 0.5,
                                width: w * 0.2,
                                child: Column(
                                  children: [
                                    Text(
                                      "MOST CLEAN SHEETS",
                                      style: TextStyle(
                                        fontSize: h * 0.05,
                                        color: kPrimaryColor,
                                        fontFamily: 'Barcelona',
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      foregroundImage: NetworkImage(
                                        playerStats.cleanSheetsImage,
                                      ),
                                      radius: w * 0.05,
                                    ),
                                    Text(
                                      playerStats.mostCleanSheets,
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: h * 0.03,
                                        fontFamily: 'League Spartan',
                                      ),
                                    ),
                                    Text(
                                      "${playerStats.cleanSheets} CLEAN SHEETS",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Barcelona',
                                        fontSize: h * 0.025,
                                      ),
                                    ),
                                    Text(
                                      playerStats.mostCSTeam,
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'League Spartan',
                                        fontSize: h * 0.015,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                  Positioned(
                    top: h * 0.55,
                    left: w * 0.01 / 2,
                    child: Column(
                      children: [
                        teamGSvsGCStatsLoading
                            ? CircularProgressIndicator()
                            : teamGSvsGCStatsLoading
                                ? CircularProgressIndicator()
                                : Container(
                                    height: h * 0.4,
                                    width: w * 0.7,
                                    child: SfCartesianChart(
                                      title:
                                          ChartTitle(text: 'Attack vs Defence'),
                                      primaryXAxis: NumericAxis(
                                        title: AxisTitle(text: "Goals Per 90"),
                                        minimum: 0,
                                        maximum: 2.8,
                                        interval: 0.2,
                                      ),
                                      primaryYAxis: NumericAxis(
                                        title: AxisTitle(
                                            text: "Goals Conceded Per 90"),
                                        minimum: 0,
                                        maximum: 2.8,
                                        interval: 0.2,
                                      ),
                                      series: <ScatterSeries<
                                          TeamGoalScoredConcededStats, double>>[
                                        ScatterSeries<
                                            TeamGoalScoredConcededStats,
                                            double>(
                                          dataSource:
                                              teamGSvsGCStats, // 🔁 This is the correct list
                                          xValueMapper:
                                              (TeamGoalScoredConcededStats team,
                                                      _) =>
                                                  team.goalsPer90,
                                          yValueMapper:
                                              (TeamGoalScoredConcededStats team,
                                                      _) =>
                                                  team.goalsConcededPer90,
                                          markerSettings: MarkerSettings(
                                            isVisible: true,
                                            width: 12,
                                            height: 12,
                                          ),
                                          dataLabelMapper:
                                              (TeamGoalScoredConcededStats team,
                                                      _) =>
                                                  team.teamName,
                                          dataLabelSettings: DataLabelSettings(
                                            isVisible: true,
                                            labelIntersectAction:
                                                LabelIntersectAction.shift,
                                            connectorLineSettings:
                                                ConnectorLineSettings(
                                              type: ConnectorType.line,
                                            ),
                                            labelAlignment:
                                                ChartDataLabelAlignment.bottom,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                        tackleVsTacklesWonLoading
                            ? const CircularProgressIndicator()
                            : Container(
                                height: h * 0.4,
                                width: w * 0.7,
                                padding: EdgeInsets.only(right: w * 0.05),
                                child: SfCartesianChart(
                                  title: ChartTitle(
                                      text: 'Tackles vs Tackles Won'),
                                  primaryXAxis: NumericAxis(
                                    title: AxisTitle(text: "Tackles Per 90"),
                                    minimum: 12,
                                    maximum: 20,
                                    interval: 0.5,
                                  ),
                                  primaryYAxis: NumericAxis(
                                    title:
                                        AxisTitle(text: "Tackles Won Per 90"),
                                    minimum: 5,
                                    maximum: 15,
                                    interval: 1,
                                  ),
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  series: <ScatterSeries<TeamTackleStats,
                                      double>>[
                                    ScatterSeries<TeamTackleStats, double>(
                                      dataSource: tackleVsTacklesWon,
                                      xValueMapper: (TeamTackleStats team, _) =>
                                          team.tacklesPer90,
                                      yValueMapper: (TeamTackleStats team, _) =>
                                          team.tacklesWonPer90,
                                      markerSettings: const MarkerSettings(
                                        isVisible: true,
                                        height: 10,
                                        width: 10,
                                        shape: DataMarkerType.circle,
                                        color: Colors.blue,
                                      ),
                                      dataLabelMapper:
                                          (TeamTackleStats team, _) =>
                                              team.teamName,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                        isVisible: true,
                                        labelIntersectAction:
                                            LabelIntersectAction.shift,
                                        connectorLineSettings:
                                            ConnectorLineSettings(
                                          type: ConnectorType.line,
                                        ),
                                        labelAlignment:
                                            ChartDataLabelAlignment.bottom,
                                        textStyle: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
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
