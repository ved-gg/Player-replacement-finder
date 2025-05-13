import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:player_replacement/Components/Widgets/PlayersDashboard.dart';
import 'package:player_replacement/Components/constants.dart';

class PlayerComparison extends StatefulWidget {
  final String positionSF;
  final String position;
  const PlayerComparison({
    super.key,
    required this.positionSF,
    required this.position,
  });

  @override
  _PlayerComparisonState createState() => _PlayerComparisonState();
}

class _PlayerComparisonState extends State<PlayerComparison> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> players = [];
  List<Map<String, dynamic>> filteredPlayers = [];
  Map<String, Map<String, double>> selectedPlayers =
      {}; // Player name -> {attribute: value}

  final List<Color> chartColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple
  ];

  List<String> radarAttributes = []; // Stores dynamically fetched attributes

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> getPlayerAttributes(String position, String playerName) async {
    try {
      final response = await http.get(
        Uri.parse('https://player-replacement-finder.onrender.com/player_attributes'),
        headers: {
          'position': position,
          'player': playerName,
        },
      );
firebase
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("Fetched Data: $data");

        // Convert API response into a map of {attribute: value}
        Map<String, double> playerData = {};
        for (var key in data.keys) {
          playerData[key] = (data[key] as num).toDouble();
        }

        setState(() {
          if (selectedPlayers.length < 5) {
            selectedPlayers[playerName] = playerData;
          }

          // Store the attribute names from the first player added
          if (radarAttributes.isEmpty) {
            radarAttributes = playerData.keys.toList();
          }
        });
      } else {
        
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching player attributes: $e');
    }
  }

  void loadCSV() async {
    try {
      final rawData = await rootBundle
          .loadString('data/playerdata/${widget.positionSF}.csv');
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(rawData, eol: '\n');

      List<String> headers = List<String>.from(csvTable[0]);
      int nameIndex = headers.indexOf('name');

      if (nameIndex != -1) {
        players = csvTable.skip(1).map((row) {
          Map<String, dynamic> playerData = {};
          for (int i = 0; i < headers.length; i++) {
            playerData[headers[i]] = row[i].toString();
          }
          return playerData;
        }).toList();
      } else {
        print("Error: 'name' column not found in CSV");
      }

      setState(() {});
    } catch (e) {
      print("Error loading CSV: $e");
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredPlayers = query.isEmpty
          ? []
          : players.where((player) {
              return player['name'].toLowerCase().contains(query.toLowerCase());
            }).toList();
    });
  }

  void addPlayerToRadarChart(String playerName) {
    if (!selectedPlayers.containsKey(playerName) &&
        selectedPlayers.length < 5) {
      getPlayerAttributes(widget.positionSF, playerName);
    }
  }

  void removePlayer(String playerName) {
    setState(() {
      selectedPlayers.remove(playerName);
      if (selectedPlayers.isEmpty) {
        radarAttributes.clear();
      }
    });
  }

  Map<String, String> attributeExplanations = {
    "Aerial Duels":
        "Measures a player's effectiveness in winning aerial challenges.",
    "Defensive Actions":
        "Tracks a player's tackles, interceptions, and clearances.",
    "Defensive Awareness":
        "Evaluates a player's positioning and anticipation in defense.",
    "Discipline":
        "Indicates a player's ability to avoid fouls and maintain composure.",
    "Passing and Build-Up Play":
        "Measures accuracy and effectiveness in passing and build-up phases.",
    "Defensive Duties":
        "Measures a player's ability to perform defensive actions effectively.",
    "Offensive Contributions":
        "Evaluates a player's impact in attacking plays, including passing and positioning.",
    "Final Third Play":
        "Assesses a player's efficiency and decision-making in the attacking third.",
    "Possession Play":
        "Indicates a player's ability to retain and distribute possession under pressure.",
    "Dribbling":
        "Reflects a player's skill in carrying the ball past opponents.",
    "Defensive Contributions":
        "Tracks a player's overall defensive efforts, including pressing and tracking back.",
    "Passing Ability":
        "Evaluates the precision and range of a player's passing.",
    "Build-Up Play":
        "Measures a player’s role in progressing the ball from deeper areas.",
    "Ball Recovery":
        "Indicates how effectively a player regains possession for their team.",
    "Line Breaking Passes":
        "Tracks a player's ability to pass through defensive lines.",
    "Passing":
        "General measure of a player's passing accuracy and contribution.",
    "Ball Carrying":
        "Assesses how well a player moves the ball forward with their feet.",
    "Defensive Work":
        "Evaluates a player's defensive positioning, pressing, and tackling.",
    "Chance Creation":
        "Measures a player’s ability to generate goal-scoring opportunities.",
    "Possession Retention":
        "Indicates how well a player holds onto the ball under pressure.",
    "Playmaking":
        "Evaluates a player’s ability to dictate play and create attacking moves.",
    "Ball Progression":
        "Tracks a player's forward ball movement through passing or dribbling.",
    "Final Third Impact":
        "Measures a player's effectiveness in influencing play near the opposition goal.",
    "Goal Threat":
        "Evaluates how often a player gets into scoring positions and takes shots.",
    "Final Ball Efficiency":
        "Assesses a player's accuracy in delivering key passes or crosses.",
    "Crosses":
        "Measures the accuracy and effectiveness of a player's crossing ability.",
    "Chance Conversion":
        "Indicates how efficiently a player turns chances into goals.",
    "Link-Up Play":
        "Evaluates a player's combination play and ability to connect with teammates.",
    "Shooting Accuracy": "Measures the percentage of shots on target.",
    "Penalty Box Presence":
        "Tracks how frequently a player gets into goal-scoring positions inside the box.",
    "Shot Stopping":
        "Evaluates a goalkeeper’s ability to make saves and prevent goals.",
    "Expected Goals Prevented":
        "Measures how many goals a goalkeeper has saved compared to expected metrics.",
    "Cross and Aerial Control":
        "Assesses a goalkeeper's command over high balls and crosses.",
    "Sweeper Keeper Activity":
        "Tracks a goalkeeper's involvement outside the penalty area in build-up play."
  };

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'COMPARE ${widget.position}S',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: h * 0.07,
                fontFamily: 'Barcelona',
              ),
            ),
            SizedBox(
              width: w * 0.3,
              child: TextField(
                controller: searchController,
                onChanged: filterSearchResults,
                decoration: const InputDecoration(
                  labelText: "Search Player",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 5),
            if (filteredPlayers.isNotEmpty)
              Container(
                height: h * 0.2,
                width: w * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: filteredPlayers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredPlayers[index]['name']),
                      onTap: () {
                        if (index < filteredPlayers.length) {
                          searchController.text =
                              filteredPlayers[index]['name'];
                          addPlayerToRadarChart(filteredPlayers[index]['name']);
                        }
                        setState(() {
                          filteredPlayers = [];
                        });
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: selectedPlayers.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: h * 0.5,
                          width: w * 0.3,
                          child: RadarChart(
                            RadarChartData(
                              radarShape: RadarShape.polygon,
                              dataSets: selectedPlayers.entries.map((entry) {
                                int index = selectedPlayers.keys
                                    .toList()
                                    .indexOf(entry.key);
                                Map<String, double> attributes = entry.value;
                                return RadarDataSet(
                                  dataEntries: attributes.values
                                      .map((val) => RadarEntry(value: val))
                                      .toList(),
                                  fillColor:
                                      // ignore: deprecated_member_use
                                      chartColors[index].withOpacity(0.2),
                                  borderColor: chartColors[index],
                                  entryRadius: 2.0,
                                  borderWidth: 2.0,
                                );
                              }).toList(),
                              borderData: FlBorderData(show: false),
                              radarBackgroundColor: Colors.transparent,
                              tickCount: 5,
                              titlePositionPercentageOffset: 0.15,
                              titleTextStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              getTitle: (index, angle) {
                                if (index < radarAttributes.length) {
                                  return RadarChartTitle(
                                    text: radarAttributes[index],
                                    angle: angle,
                                  );
                                }
                                return RadarChartTitle(
                                  text: '',
                                  angle: angle,
                                );
                              },
                            ),
                          ),
                        ),
                        DataTable(
                          columnSpacing: w * 0.01,
                          columns: [
                            const DataColumn(label: Text('Player')),
                            ...radarAttributes.map((attr) => DataColumn(
                                  label: Tooltip(
                                    message: attributeExplanations[attr] ??
                                        "No description available",
                                    child: Text(
                                      attr,
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                )),
                            const DataColumn(label: Text('Actions')),
                          ],
                          rows: selectedPlayers.entries.map((entry) {
                            int index = selectedPlayers.keys
                                .toList()
                                .indexOf(entry.key);
                            Map<String, double> attributes = entry.value;
                            return DataRow(
                              cells: [
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PlayersDashboard(
                                            playerName: entry.key,
                                            position: widget.positionSF,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      entry.key,
                                      style: TextStyle(
                                        color: chartColors[index],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                ...attributes.entries.map(
                                  (attr) => DataCell(
                                    Text(
                                      attr.value.toStringAsFixed(1),
                                    ), // Only 1 decimal place
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(
                                        () {
                                          selectedPlayers.remove(entry.key);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : const Center(child: Text("Select players to compare")),
            ),
          ],
        ),
      ),
    );
  }
}
