import 'package:flutter/material.dart';
import 'package:player_replacement/API%20Models/bestPerformers.dart';
import 'package:player_replacement/API%20Models/standingsModel.dart';
import 'package:player_replacement/API%20Models/teamGSvsGCStats.dart';
import 'package:player_replacement/API%20Models/teamTackleStats.dart';
import 'package:player_replacement/Components/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BuildTeamData extends StatelessWidget {
  bool isLoading;
  bool topScorersLoading;
  bool teamGSvsGCStatsLoading = true;
  bool tackleVsTacklesWonLoading = true;
  List<TeamStanding> standings;
  List<PlayerStat> playerStats;
  List<TeamGoalScoredConcededStats> teamGoalsStat = [];
  List<TeamTackleStats> teamTackleStat = [];
  BuildTeamData(
      {super.key,
      required this.isLoading,
      required this.topScorersLoading,
      required this.standings,
      required this.playerStats,
      required this.teamGoalsStat,
      required this.teamTackleStat,
      required this.teamGSvsGCStatsLoading,
      required this.tackleVsTacklesWonLoading});
  @override
  Widget build(BuildContext context) {
    topScorersLoading
        ? print("None")
        : print("IN LEAGUES DATA: ${playerStats[2].name}");
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
                            fontSize: h * 0.03,
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
                            DataCell(Text(team.team)),
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
                    child: topScorersLoading
                        ? Center(child: CircularProgressIndicator())
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
                                        playerStats[0].imageUrl,
                                      ),
                                      radius: w * 0.05,
                                    ),
                                    Text(
                                      playerStats[0].name,
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: h * 0.03,
                                        fontFamily: 'League Spartan',
                                      ),
                                    ),
                                    Text(
                                      "${playerStats[0].stat} GOALS",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Barcelona',
                                        fontSize: h * 0.025,
                                      ),
                                    ),
                                    Text(
                                      "${playerStats[0].team} ",
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
                                        playerStats[1].imageUrl,
                                      ),
                                      radius: w * 0.05,
                                    ),
                                    Text(
                                      playerStats[1].name,
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: h * 0.03,
                                        fontFamily: 'League Spartan',
                                      ),
                                    ),
                                    Text(
                                      "${playerStats[1].stat} ASSISTS",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Barcelona',
                                        fontSize: h * 0.025,
                                      ),
                                    ),
                                    Text(
                                      "${playerStats[1].team} ",
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
                                        playerStats[2].imageUrl,
                                      ),
                                      radius: w * 0.05,
                                    ),
                                    Text(
                                      playerStats[2].name,
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: h * 0.03,
                                        fontFamily: 'League Spartan',
                                      ),
                                    ),
                                    Text(
                                      "${playerStats[2].stat} CLEAN SHEETS",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Barcelona',
                                        fontSize: h * 0.025,
                                      ),
                                    ),
                                    Text(
                                      playerStats[2].team,
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
                            : Container(
                                height: h * 0.4,
                                width: w * 0.7,
                                child: SfCartesianChart(
                                  primaryXAxis: NumericAxis(
                                    title: AxisTitle(text: "Goals Per 90"),
                                    minimum: 0,
                                    maximum: 2.5,
                                    interval:
                                        0.1, // Ensures whole numbers on the axis
                                  ),
                                  primaryYAxis: NumericAxis(
                                    title:
                                        AxisTitle(text: "Goals Conceded Per 90"),
                                    minimum: 0,
                                    maximum: 2.5,
                                    interval:
                                        0.1, // Ensures whole numbers on the axis
                                  ),
                                  series: <ScatterSeries<
                                      TeamGoalScoredConcededStats, double>>[
                                    ScatterSeries<TeamGoalScoredConcededStats,
                                        double>(
                                      dataSource: teamGoalsStat,
                                      xValueMapper:
                                          (TeamGoalScoredConcededStats team, _) =>
                                              team.goalsPer90,
                                      yValueMapper:
                                          (TeamGoalScoredConcededStats team, _) =>
                                              team.goalsConcededPer90,
                                      markerSettings: MarkerSettings(
                                          isVisible:
                                              true), // Ensure marker visibility
                                      dataLabelMapper:
                                          (TeamGoalScoredConcededStats team, _) =>
                                              team.teamName,
                                      dataLabelSettings: DataLabelSettings(
                                        isVisible: true, // Hide labels initially
                                        labelIntersectAction:
                                            LabelIntersectAction.shift,
                                        connectorLineSettings:
                                            ConnectorLineSettings(
                                          // Leader lines
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
                            ? CircularProgressIndicator()
                            : Container(
                                height: h * 0.4,
                                width: w * 0.7,
                                child: Padding(
                                  padding:  EdgeInsets.only(right: w*0.05,),
                                  child: SfCartesianChart(
                                    primaryXAxis: NumericAxis(
                                      title: AxisTitle(text: "Tackles Per 90"),
                                      minimum: 12.5,
                                      maximum: 20,
                                      interval:
                                          0.5, // Ensures whole numbers on the axis
                                    ),
                                    primaryYAxis: NumericAxis(
                                      title: AxisTitle(text: "Tackles Won Per 90"),
                                      minimum: 5,
                                      maximum: 15,
                                      interval:
                                          1, // Ensures whole numbers on the axis
                                    ),
                                    series: <ScatterSeries<TeamTackleStats,
                                        double>>[
                                      ScatterSeries<TeamTackleStats, double>(
                                        dataSource: teamTackleStat,
                                        xValueMapper: (TeamTackleStats team, _) =>
                                            team.tacklesPer90,
                                        yValueMapper: (TeamTackleStats team, _) =>
                                            team.tacklesWonPer90,
                                        markerSettings: MarkerSettings(
                                            isVisible:
                                                true), // Ensure marker visibility
                                        dataLabelMapper:
                                            (TeamTackleStats team, _) =>
                                                team.teamName,
                                        dataLabelSettings: DataLabelSettings(
                                          isVisible: true, // Hide labels initially
                                          labelIntersectAction:
                                              LabelIntersectAction.shift,
                                          connectorLineSettings:
                                              ConnectorLineSettings(
                                            // Leader lines
                                            type: ConnectorType.line,
                                          ),
                                          labelAlignment:
                                              ChartDataLabelAlignment.bottom,
                                        ),
                                      ),
                                    ],
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
    );
  }
}
