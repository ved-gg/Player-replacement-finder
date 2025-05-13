import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:player_replacement/API%20Models/playerDashboardModel.dart';
import 'package:player_replacement/API%20Models/formationAnalysis.dart';
import 'package:player_replacement/Components/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:syncfusion_flutter_charts/charts.dart';

class PlayersDashboard extends StatefulWidget {
  String playerName;
  String position;
  PlayersDashboard(
      {required this.playerName, required this.position, super.key});

  @override
  State<PlayersDashboard> createState() => _PlayersDashboardState();
}

class _PlayersDashboardState extends State<PlayersDashboard> {
  @override
  void initState() {
    super.initState();
    getFormationFitness(widget.playerName, widget.position);
    fetchPlayerDashboardData(widget.position, widget.playerName);
  }

  List<FormationResult> formationResults = [];
  PlayerDashboardModel? playerData;
  bool isPlayerDataLoading = true;
  bool formationResultsLoading = true;

  Future<void> fetchPlayerDashboardData(
      String position, String playerName) async {
    final url = Uri.parse(
        'http://127.0.0.1:5000/player_dashboard_data'); // Replace with your Flask server address

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'position': position,
          'player': playerName,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        playerData = PlayerDashboardModel.fromJson(data);
        print("Player Data: ${playerData!.stats}");
        setState(() {
          isPlayerDataLoading = false;
        });
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> getFormationFitness(String playerName, String position) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/fitness_score'),
        headers: {
          'player': playerName,
          'position': position,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final analysis = FormationAnalysis.fromJson(data);
        formationResults = analysis.results;
        print("Formation Analysis: $formationResults");
        setState(() {
          formationResultsLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching formation analysis: $e');
    }
  }

  Widget buildFormationResults(List<FormationResult> results) {
    return ListView.builder(
      itemCount: results.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final result = results[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧠 Formation and Style
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '[${result.formation}] - ${result.position}',
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label:
                          Text(result.style.replaceAll("_", " ").toUpperCase()),
                      backgroundColor: _getStyleColor(result.style),
                    )
                  ],
                ),
                const SizedBox(height: 8),

                // 📊 Score
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 12.0,
                        percent: (result.score / 10).clamp(0.0, 1.0),
                        progressColor: Colors.green,
                        backgroundColor: Colors.grey[300],
                        barRadius: const Radius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("${result.score.toStringAsFixed(1)}/10"),
                  ],
                ),
                const SizedBox(height: 10),

                // 💬 Explanation
                Text(
                  result.explanation,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStyleColor(String style) {
    switch (style) {
      case 'defensive':
        return Colors.blueGrey.shade200;
      case 'attacking':
        return Colors.orangeAccent.shade100;
      case 'balanced':
        return Colors.greenAccent.shade100;
      case 'wingplay':
        return Colors.purpleAccent.shade100;
      case 'ultra_defensive':
        return Colors.blue.shade100;
      case 'possession':
        return Colors.amber.shade100;
      case 'counter':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    Widget fetchPlots(position, playerName) {
      if (position == "CB") {
        final radarData = [
          playerData!.stats['Won'] ?? 0,
          playerData!.stats['Blocks'] ?? 0,
          playerData!.stats['Clr'] ?? 0,
          playerData!.stats['Tkl'] ?? 0,
          playerData!.stats['Int'] ?? 0,
        ];
        final barData = [
          {
            'Aerial Duels Won':
                playerData!.stats['Aerial Duels Won Per 90'] ?? 0.0,
            'Aerial Duels': playerData!.stats['Aerial Duels Per 90'] ?? 0.0,
          }
        ];
        final radarPlotTitles = ['Won', 'Blocks', 'Clr', 'Tkl', 'Int'];
        final bubbleData = [
          {
            'PrgP Per 90': playerData!.stats['PrgP Per 90'],
            'CmpPer90': playerData!.stats['Cmp']! / playerData!.stats['90s']!,
            'Cmp.3': playerData!.stats['Cmp.3'],
          }
        ];

        return isPlayerDataLoading
            ? const CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Defensive Profile",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      Container(
                        height: h * 0.4,
                        width: w * 0.20,
                        color: Colors.transparent,
                        child: RadarChart(
                          RadarChartData(
                            radarShape: RadarShape.polygon,
                            dataSets: [
                              RadarDataSet(
                                dataEntries: radarData
                                    .map((e) => RadarEntry(value: e))
                                    .toList(),
                                fillColor: Colors.blue.withValues(
                                  alpha: 0.5,
                                  red: 0.5,
                                  green: 0.5,
                                  blue: 0.5,
                                ),
                                borderColor: kPrimaryColor,
                                entryRadius: 2,
                                borderWidth: 2,
                              ),
                            ],
                            getTitle: (index, angle) {
                              switch (index) {
                                case 0:
                                  return RadarChartTitle(
                                      text:
                                          "${radarPlotTitles[0]} : ${playerData!.stats[radarPlotTitles[0]]}",
                                      angle: angle);
                                case 1:
                                  return RadarChartTitle(
                                      text:
                                          "${radarPlotTitles[1]} : ${playerData!.stats[radarPlotTitles[1]]}",
                                      angle: angle);
                                case 2:
                                  return RadarChartTitle(
                                      text:
                                          "${radarPlotTitles[2]} : ${playerData!.stats[radarPlotTitles[2]]}",
                                      angle: angle);
                                case 3:
                                  return RadarChartTitle(
                                      text:
                                          "${radarPlotTitles[3]} : ${playerData!.stats[radarPlotTitles[3]]}",
                                      angle: angle);
                                case 4:
                                  return RadarChartTitle(
                                      text:
                                          "${radarPlotTitles[4]} : ${playerData!.stats[radarPlotTitles[4]]}",
                                      angle: angle);
                                default:
                                  return const RadarChartTitle(text: "Not Title");
                              }
                            },
                            radarBackgroundColor: Colors.transparent,
                            radarBorderData:
                                const BorderSide(color: Colors.transparent),
                            titleTextStyle: const TextStyle(
                                fontSize: 12, color: Colors.black),
                            tickCount: 5,
                            ticksTextStyle: const TextStyle(
                                color: Colors.grey, fontSize: 10),
                            tickBorderData:
                                const BorderSide(color: Colors.grey),
                            gridBorderData:
                                const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Progressive Passes",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      SizedBox(
                        height: h * 0.4,
                        width: w * 0.7,
                        child: SfCartesianChart(
                          primaryXAxis: const NumericAxis(
                            minimum: 0,
                            maximum: 10,
                            interval: 2,
                            plotBands: [
                              PlotBand(
                                isVisible: true,
                                start: 5,
                                end: 5,
                                borderColor: Colors.black,
                                borderWidth: 2,
                              )
                            ],
                            title: AxisTitle(text: 'Progressive Passes per 90'),
                          ),
                          primaryYAxis: const NumericAxis(
                            minimum: 0,
                            maximum: 100,
                            interval: 20,
                            plotBands: [
                              PlotBand(
                                isVisible: true,
                                start: 50,
                                end: 50,
                                borderColor: Colors.black,
                                borderWidth: 2,
                              )
                            ],
                            title: AxisTitle(text: 'Pass Completion %'),
                          ),
                          annotations: const <CartesianChartAnnotation>[
                            CartesianChartAnnotation(
                              widget: Text('Modern Ball-Playing CB',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              coordinateUnit: CoordinateUnit.point,
                              x: 9,
                              y: 95,
                            ),
                            CartesianChartAnnotation(
                              widget: Text('Secure Distributor',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              coordinateUnit: CoordinateUnit.point,
                              x: 1,
                              y: 95,
                            ),
                            CartesianChartAnnotation(
                              widget: Text('Defensive Stopper',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              coordinateUnit: CoordinateUnit.point,
                              x: 1,
                              y: 3,
                            ),
                            CartesianChartAnnotation(
                              widget: Text('Aggressive Playmaker',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              coordinateUnit: CoordinateUnit.point,
                              x: 9,
                              y: 3,
                            ),
                          ],
                          series: [
                            BubbleSeries(
                              dataSource: bubbleData,
                              xValueMapper: (datum, _) => datum['PrgP Per 90'],
                              yValueMapper: (datum, _) => datum['CmpPer90'],
                              sizeValueMapper: (datum, _) => datum['Cmp.3'],
                              color: Colors.tealAccent,
                              enableTooltip: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Aerial Dominance",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      SizedBox(
                        height: h * 0.4,
                        width: w * 0.7,
                        child: SfCartesianChart(
                          series: [
                            BarSeries(
                              dataSource: barData,
                              xValueMapper: (datum, index) =>
                                  datum['Aerial Duels Won'],
                              yValueMapper: (datum, index) =>
                                  datum['Aerial Duels'],
                              color: kPrimaryColor,
                              width: 0.1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              );
      } else if (position == "LB" || position == "RB") {
        final barData = [
          {
            'Tackles Won': playerData!.stats['TklW'] ?? 0,
            'Interceptions': playerData!.stats['Int'] ?? 0,
            'Blocks': playerData!.stats['Blocks'] ?? 0,
            'Clearances': playerData!.stats['Clr'] ?? 0,
            'Recoveries': playerData!.stats['Recov'] ?? 0,
          }
        ];
        final bubbleData = [
          {
            'Final Third Passes': playerData!.stats['Final Third'] ?? 0,
            'Key Passes': playerData!.stats['KP'] ?? 0,
            'Crosses': playerData!.stats['Crs'] ?? 0,
          }
        ];
        final barAndLine = [
          {
            'Def Penalty Touches': playerData!.stats['Def Pen'] ?? 0,
            'Def Third Touches': playerData!.stats['Def 3rd_possession'] ?? 0,
            'Mid Third Touches': playerData!.stats['Mid 3rd_possession'] ?? 0,
            'Att Third Touches': playerData!.stats['Att 3rd_possession'] ?? 0,
            'Att Penalty Touches': playerData!.stats['Att Pen'] ?? 0,
          }
        ];
        final dataMap = barAndLine[0];
        final categories = dataMap.keys.toList();
        final values = dataMap.values.toList();

        return isPlayerDataLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Defensive Profile",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      Container(
                          height: h * 0.4,
                          width: w * 0.4,
                          color: Colors.transparent,
                          child: SfCartesianChart(
                            primaryXAxis: const CategoryAxis(),
                            primaryYAxis:
                                const NumericAxis(title: AxisTitle(text: 'Count')),
                            series: [
                              ColumnSeries<String, String>(
                                dataSource:
                                    barData[0].keys.toList(), // X-axis labels
                                xValueMapper: (key, _) => key,
                                yValueMapper: (key, _) => barData[0][key],
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  angle: 0,
                                  textStyle: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: h * 0.02,
                                  ),
                                ),
                                color: Colors.teal,
                              )
                            ],
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Passing Performance",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      SizedBox(
                        height: h * 0.4,
                        width: w * 0.7,
                        child: SfCartesianChart(
                          primaryXAxis: const NumericAxis(
                            minimum: 0,
                            maximum: 7,
                            interval: 1,
                            plotBands: [
                              PlotBand(
                                isVisible: true,
                                start: 3.5,
                                end: 3.5,
                                borderColor: Colors.black,
                                borderWidth: 2,
                              )
                            ],
                            title: AxisTitle(text: 'Final Third Passes'),
                          ),
                          primaryYAxis: const NumericAxis(
                            minimum: 0,
                            maximum: 3,
                            interval: 0.1,
                            plotBands: [
                              PlotBand(
                                isVisible: true,
                                start: 1.5,
                                end: 1.5,
                                borderColor: Colors.black,
                                borderWidth: 2,
                              )
                            ],
                            title: AxisTitle(text: 'Key Passes'),
                          ),
                          annotations: const <CartesianChartAnnotation>[
                            CartesianChartAnnotation(
                              widget: Text('Attacking Playmaker FB',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              coordinateUnit: CoordinateUnit.point,
                              x: 6.5,
                              y: 2.8,
                            ),
                            CartesianChartAnnotation(
                              widget: Text('Final-Ball Specialist',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              coordinateUnit: CoordinateUnit.point,
                              x: 0.5,
                              y: 2.8,
                            ),
                            CartesianChartAnnotation(
                              widget: Text('Defensive Full-Back',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              coordinateUnit: CoordinateUnit.point,
                              x: 0.5,
                              y: 0.1,
                            ),
                            CartesianChartAnnotation(
                              widget: Text('Supporting Overlapper',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              coordinateUnit: CoordinateUnit.point,
                              x: 6.5,
                              y: 0.1,
                            ),
                          ],
                          series: [
                            BubbleSeries(
                              dataSource: bubbleData,
                              xValueMapper: (datum, _) =>
                                  datum['Final Third Passes'],
                              yValueMapper: (datum, _) => datum['Key Passes'],
                              sizeValueMapper: (datum, _) => datum['Crosses'],
                              color: Colors.tealAccent,
                              enableTooltip: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Possession Retention",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      SizedBox(
                        height: h * 0.4,
                        width: w * 0.7,
                        child: SfCartesianChart(
                          title: const ChartTitle(text: 'Touches in Different Zones'),
                          legend: const Legend(isVisible: true),
                          primaryXAxis: const CategoryAxis(),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: [
                            ColumnSeries<MapEntry<String, num>, String>(
                              name: 'Bar',
                              dataSource: barAndLine[0].entries.toList(),
                              xValueMapper: (MapEntry<String, num> entry, _) =>
                                  entry.key,
                              yValueMapper: (MapEntry<String, num> entry, _) =>
                                  entry.value,
                              color: Colors.teal,
                            ),
                            LineSeries<MapEntry<String, num>, String>(
                              name: 'Line',
                              dataSource: barAndLine[0].entries.toList(),
                              xValueMapper: (MapEntry<String, num> entry, _) =>
                                  entry.key,
                              yValueMapper: (MapEntry<String, num> entry, _) =>
                                  entry.value,
                              markerSettings: const MarkerSettings(isVisible: true),
                              color: Colors.orangeAccent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
      } else if (position == "CDM") {
        final radarData = [
          {
            'Tackles': playerData!.stats['Tkl'],
            'Interceptions': playerData!.stats["Int"],
            'Blocks': playerData!.stats["Blocks"],
            'Recoveries': playerData!.stats["Recov"],
          }
        ];
        final passingData = [
          {
            'Short Passes': playerData!.stats['Cmp.1'],
            'Medium Passes': playerData!.stats['Cmp.2'],
            'Long Passes': playerData!.stats['Cmp.3'],
            'Total Passes': playerData!.stats['Cmp'],
            'Progressive Passes': playerData!.stats['PrgP'],
            'Final Third': playerData!.stats['Final Third'],
          }
        ];
        return isPlayerDataLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Defensive Profile",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(
                        height: h * 0.4,
                        width: w * 0.5,
                        child: SfCartesianChart(
                          title: const ChartTitle(text: 'Defensive Metrics'),
                          primaryXAxis: const CategoryAxis(),
                          primaryYAxis: const NumericAxis(),
                          series: [
                            ColumnSeries<MapEntry<String, double>, String>(
                              dataSource: radarData[0]
                                  .entries
                                  .map((entry) =>
                                      MapEntry(entry.key, entry.value ?? 0.0))
                                  .toList(),
                              xValueMapper:
                                  (MapEntry<String, double> entry, _) =>
                                      entry.key,
                              yValueMapper:
                                  (MapEntry<String, double> entry, _) =>
                                      entry.value,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              color: Colors.teal,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Passing Range",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(height: h * 0.15),
                      SizedBox(
                        height: h * 0.4,
                        width: w * 0.5,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: passingData[0]['Short Passes']! /
                                    passingData[0]['Total Passes']! *
                                    100,
                                title: 'Short Passes',
                                color: Colors.blue,
                                radius: w * 0.15,
                                titleStyle: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: passingData[0]['Medium Passes']! /
                                    passingData[0]['Total Passes']! *
                                    100,
                                title: 'Medium Passes',
                                color: Colors.green,
                                radius: w * 0.15,
                                titleStyle: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: passingData[0]['Long Passes']! /
                                    passingData[0]['Total Passes']! *
                                    100,
                                title: 'Long Passes',
                                color: Colors.orange,
                                radius: w * 0.15,
                                titleStyle: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: passingData[0]['Progressive Passes']! /
                                    passingData[0]['Total Passes']! *
                                    100,
                                title: 'Progressive Passes',
                                color: Colors.purple,
                                radius: w * 0.15,
                                titleStyle: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: passingData[0]['Final Third']! /
                                    passingData[0]['Total Passes']! *
                                    100,
                                title: 'Final Third',
                                color: Colors.red,
                                radius: w * 0.15,
                                titleStyle: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            centerSpaceRadius: 0,
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
      } else if (position == "CM") {
        final radarData = [
          {
            'Tackles': playerData!.stats['Tkl'],
            'Progressive Passes': playerData!.stats['PrgP'],
            'Key Passes': playerData!.stats['KP'],
            'Interceptions': playerData!.stats['Int'],
            'SCA': playerData!.stats['SCA'],
            'Expected Assists': playerData!.stats['xA'],
          }
        ];
        final bubbleData = [
          {
            'Touches': playerData!.stats['Touches'],
            'SCA': playerData!.stats['SCA'],
            'Shots': playerData!.stats['Sh'],
          }
        ];
        return isPlayerDataLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Performance Profile",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(
                        height: h * 0.4,
                        width: w * 0.5,
                        child: SfCartesianChart(
                          title: const ChartTitle(text: 'Overall Performance'),
                          primaryXAxis: const CategoryAxis(),
                          primaryYAxis: const NumericAxis(),
                          series: [
                            ColumnSeries<MapEntry<String, double>, String>(
                              dataSource: radarData[0]
                                  .entries
                                  .map((entry) =>
                                      MapEntry(entry.key, entry.value ?? 0.0))
                                  .toList(),
                              xValueMapper:
                                  (MapEntry<String, double> entry, _) =>
                                      entry.key,
                              yValueMapper:
                                  (MapEntry<String, double> entry, _) =>
                                      entry.value,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              color: Colors.teal,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.01),
                  Column(
                    children: [
                      Text(
                        "Offensive Involvement",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      SizedBox(
                        height: h * 0.4,
                        width: w * 0.5,
                        child: SfCartesianChart(
                          title: const ChartTitle(text: 'CM Output vs Volume'),
                          primaryXAxis: NumericAxis(
                            title: const AxisTitle(text: 'Touches'),
                            minimum: 0,
                            maximum: bubbleData[0]['Touches']! * 1.5,
                            interval:
                                (bubbleData[0]['Touches']! / 5).ceilToDouble(),
                          ),
                          primaryYAxis: NumericAxis(
                            title: const AxisTitle(text: 'Shot Creating Actions'),
                            minimum: 0,
                            maximum: bubbleData[0]['SCA']! * 1.5,
                            interval:
                                (bubbleData[0]['SCA']! / 5).ceilToDouble(),
                          ),
                          series: <BubbleSeries<Map<String, dynamic>, num>>[
                            BubbleSeries<Map<String, dynamic>, num>(
                              dataSource: bubbleData,
                              xValueMapper: (data, _) => data['Touches'],
                              yValueMapper: (data, _) => data['SCA'],
                              sizeValueMapper: (data, _) => data['Shots'],
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
      } else if (position == "CAM") {
        final radarData = [
          {
            'G+A': playerData!.stats['G+A'],
            'Expected Assists': playerData!.stats['xA'],
            'Key Passes': playerData!.stats['KP'],
            'Shot Creating Actions': playerData!.stats['SCA'],
          }
        ];
        final lineData = [
          {
            'Shot Creating Actions': playerData!.stats['SCA'],
            'G+A': playerData!.stats['G+A'],
            '90s': playerData!.stats['90s'],
          }
        ];
        return isPlayerDataLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Goal Contribution and Creativity",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(
                        height: h * 0.4,
                        width: w * 0.5,
                        child: SfCartesianChart(
                          primaryXAxis: const CategoryAxis(),
                          primaryYAxis: const NumericAxis(),
                          series: [
                            ColumnSeries<MapEntry<String, double>, String>(
                              dataSource: radarData[0]
                                  .entries
                                  .map((entry) =>
                                      MapEntry(entry.key, entry.value ?? 0.0))
                                  .toList(),
                              xValueMapper:
                                  (MapEntry<String, double> entry, _) =>
                                      entry.key,
                              yValueMapper:
                                  (MapEntry<String, double> entry, _) =>
                                      entry.value,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              color: Colors.teal,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Column(
                    children: [
                      Text(
                        "Goal Contribution and Creativity",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(
                          height: h * 0.4,
                          width: w * 0.5,
                          child: BarChart(
                            BarChartData(
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: lineData[0]
                                              ['Shot Creating Actions'] ??
                                          0,
                                      color: Colors.green,
                                      width: 15,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: lineData[0]['G+A'] ?? 0,
                                      color: Colors.black,
                                      width: 15,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                      toY: lineData[0]['90s'] ?? 0,
                                      color: Colors.orange,
                                      width: 15,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                              ],
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text('SCA');
                                        case 1:
                                          return const Text('G+A');
                                        case 2:
                                          return const Text('90s');
                                        default:
                                          return const Text('');
                                      }
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: true),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: true),
                              barTouchData: BarTouchData(enabled: true),
                            ),
                          )),
                    ],
                  ),
                ],
              );
      } else if (position == "LW" || position == "RW") {
        final barData = [
          {
            'Key Passes': playerData!.stats['KP'],
            'Expected Assists': playerData!.stats['xA'],
            'SCA': playerData!.stats['SCA'],
            'PrgP': playerData!.stats['PrgP'],
            'G+A': playerData!.stats['G+A'],
            'SoT': playerData!.stats['SoT'],
          }
        ];
        final lineData = [
          {
            'PrgP': playerData!.stats['PrgP'],
            'PrgC': playerData!.stats['PrgC'],
            'Key Passes': playerData!.stats['KP'],
            'Expected Assists': playerData!.stats['xA'],
            'SCA': playerData!.stats['SCA'],
          }
        ];
        return isPlayerDataLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Playmaking v/s Scoring Impact",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      SizedBox(
                          height: h * 0.4,
                          width: w * 0.5,
                          child: SfCartesianChart(
                            primaryXAxis: const CategoryAxis(
                              title: AxisTitle(text: 'Metrics'),
                            ),
                            primaryYAxis: const NumericAxis(
                              title: AxisTitle(text: 'Value'),
                            ),
                            series: [
                              ColumnSeries<Map<String, dynamic>, String>(
                                dataSource: barData[0]
                                    .keys
                                    .map((key) => {
                                          'metric': key,
                                          'value': barData[0][key],
                                        })
                                    .toList(),
                                xValueMapper: (datum, _) =>
                                    datum['metric'] as String,
                                yValueMapper: (datum, _) =>
                                    datum['value'] as num,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
                                pointColorMapper: (datum, _) {
                                  final metric = datum['metric'];
                                  if ([
                                    'Key Passes',
                                    'Expected Assists',
                                    'SCA',
                                    'PrgP'
                                  ].contains(metric)) {
                                    return Colors.teal;
                                  } else {
                                    return Colors.orange;
                                  }
                                },
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: h * 0.01),
                  Column(
                    children: [
                      Text(
                        "Creation v/s Progression",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      SizedBox(
                          height: h * 0.4,
                          width: w * 0.5,
                          child: BarChart(
                            BarChartData(
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: lineData[0]['PrgP']!.toDouble(),
                                      color: kPrimaryColor,
                                      width: 8,
                                    ),
                                  ],
                                  showingTooltipIndicators: [0],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: lineData[0]['PrgC']!.toDouble(),
                                      color: Colors.green,
                                      width: 8,
                                    ),
                                  ],
                                  showingTooltipIndicators: [0],
                                ),
                              ],
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text('PrgP');
                                        case 1:
                                          return const Text('PrgC');
                                        default:
                                          return const Text('');
                                      }
                                    },
                                  ),
                                ),
                              ),
                              extraLinesData: const ExtraLinesData(
                                extraLinesOnTop: true,
                                horizontalLines: [],
                              ),
                              minY: 0,
                              maxY:
                                  10, // adjust based on your actual data range
                            ),
                          )),
                    ],
                  ),
                ],
              );
      } else if (position == "CF") {
        final passData = [
          {
            'PrgP': playerData!.stats['PrgP'],
            'Cmp': playerData!.stats['Cmp'],
            'SCA': playerData!.stats['SCA'],
            'Final Third': playerData!.stats['Final Third'],
            'KP': playerData!.stats['KP'],
          }
        ];
        final attData = [
          {
            'xG': playerData!.stats['xG'],
            'SoT': playerData!.stats['SoT'],
            'Gls': playerData!.stats['Gls'],
            'Won': playerData!.stats['Won'],
            'Att Pen': playerData!.stats['Att Pen'],
          }
        ];
        return isPlayerDataLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Creation v/s Progression",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      SizedBox(
                          height: h * 0.4,
                          width: w * 0.5,
                          child: SfCartesianChart(
                            title: const ChartTitle(text: 'Passing Profile'),
                            primaryXAxis: const CategoryAxis(),
                            primaryYAxis: const NumericAxis(
                              title: AxisTitle(text: 'Count'),
                              minimum: 0,
                            ),
                            series: [
                              ColumnSeries<Map<String, dynamic>, String>(
                                dataSource: passData[0].entries.map((entry) {
                                  final key = entry.key;
                                  final rawValue = entry.value;
                                  final value = (rawValue is num)
                                      ? rawValue
                                      : double.tryParse(rawValue.toString()) ??
                                          0;
                                  return {'label': key, 'value': value};
                                }).toList(),
                                xValueMapper: (datum, _) =>
                                    datum['label'] as String,
                                yValueMapper: (datum, _) =>
                                    datum['value'] as num,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
                                color: Colors.teal,
                              ),
                            ],
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Attacking Prowess",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nevis',
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      SizedBox(
                        height: h * 0.4,
                        width: w * 0.5,
                        child: SfCartesianChart(
                          title: const ChartTitle(text: 'Attacking Profile'),
                          primaryXAxis: const CategoryAxis(),
                          primaryYAxis: const NumericAxis(
                            title: AxisTitle(text: 'Value'),
                            minimum: 0,
                          ),
                          series: [
                            ColumnSeries<Map<String, dynamic>, String>(
                              dataSource: attData[0].entries.map((entry) {
                                final key = entry.key;
                                final rawValue = entry.value;
                                final value = (rawValue is num)
                                    ? rawValue
                                    : double.tryParse(rawValue.toString()) ?? 0;
                                return {'label': key, 'value': value};
                              }).toList(),
                              xValueMapper: (datum, _) =>
                                  datum['label'] as String,
                              yValueMapper: (datum, _) => datum['value'] as num,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              color: Colors.deepOrange,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
      } else {
        return const Center(
          child: Text("Error fetching dashboard plots"),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: h * 0.1,
        backgroundColor: kPrimaryColor,
        foregroundColor: kSecondaryColor,
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
      body: SingleChildScrollView(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  fetchPlots(widget.position, widget.playerName),
                ],
              ),
              SizedBox(
                width: w * 0.01,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: h * 1.5,
                    width: w * 0.2,
                    child: formationResultsLoading
                        ? const Center(child: CircularProgressIndicator())
                        : buildFormationResults(formationResults),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
