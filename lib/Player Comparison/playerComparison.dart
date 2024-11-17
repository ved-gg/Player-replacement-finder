import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:player_replacement/API%20Models/playerModel.dart';

class PlayerComparison extends StatefulWidget {
  String player1;
  String player2;
  PlayerComparison({super.key, required this.player1, required this.player2});

  @override
  State<PlayerComparison> createState() => _PlayerComparisonState();
}

class _PlayerComparisonState extends State<PlayerComparison> {
  PlayerClass? firstPlayer; // Nullable
  PlayerClass? secondPlayer; // Nullable
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayers();
  }

  Future<void> _initializePlayers() async {
    try {
      await Future.wait([
        scrapePlayerOne(),
        scrapePlayerTwo(),
      ]);
    } catch (e) {
      print("Error initializing players: $e");
    } finally {
      setState(() {
        _isLoading = false; // Mark initialization as complete
      });
    }
  }

  Future<void> scrapePlayerOne() async {
    final Map<String, String> body = {
      "player_name": widget.player1,
    };
    final response = await http.post(
      Uri.parse("http://127.0.0.1:5000/scrape"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body)['data'];
      firstPlayer = PlayerClass.fromJson(jsonData);
    } else {
      throw Exception(
          "Failed to scrape player one. Status code: ${response.statusCode}");
    }
  }

  Future<void> scrapePlayerTwo() async {
    final Map<String, String> body = {
      "player_name": widget.player2,
    };
    final response = await http.post(
      Uri.parse("http://127.0.0.1:5000/scrape"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body)['data'];
      secondPlayer = PlayerClass.fromJson(jsonData);
    } else {
      throw Exception(
          "Failed to scrape player two. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final h = mediaQuery.size.height;
    final w = mediaQuery.size.width;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Player Comparison'),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Handle null checks for firstPlayer and secondPlayer
    if (firstPlayer == null || secondPlayer == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Player Comparison'),
        ),
        body: Center(
          child: Text(
            'Player data not available',
            style: TextStyle(color: Colors.red, fontSize: h * 0.02),
          ),
        ),
      );
    }

    // Extract player data
    String clubOne = firstPlayer!.personalInfo['Club']!.replaceAll(' ', '');
    String clubImagePathOne = 'images/Clubs/$clubOne.png';
    String clubTwo = secondPlayer!.personalInfo['Club']!.replaceAll(' ', '');
    String clubImagePathTwo = 'images/Clubs/$clubTwo.png';
    String nationOne =
        firstPlayer!.personalInfo['National Team']!.split(' ')[0];
    String nationTwo =
        secondPlayer!.personalInfo['National Team']!.split(' ')[0];
    String nationImageOne = 'images/Nations/$nationOne.png';
    String nationImageTwo = 'images/Nations/$nationTwo.png';
    String nameOneWithoutSpace = widget.player1.replaceAll(' ', '');
    String nameTwoWithoutSpace = widget.player2.replaceAll(' ', '');
    String playerImageOne = 'images/Players/$nameOneWithoutSpace.png';
    String playerImageTwo = 'images/Players/$nameTwoWithoutSpace.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('Player Comparison'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: h * 0.7,
          width: w * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(h * 0.02),
            color: Colors.black,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: h * 0.05),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            playerImageOne,
                            width: w * 0.05,
                            height: h * 0.08,
                            errorBuilder: (context, object, stacktrace) {
                              return Text(
                                widget.player1,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.015,
                                ),
                              );
                            },
                          ),
                          Image.asset(
                            nationImageOne,
                            width: w * 0.02,
                            height: h * 0.02,
                            errorBuilder: (context, object, stacktrace) {
                              return Text(
                                '${firstPlayer!.personalInfo['National Team']}\n',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.015,
                                ),
                              );
                            },
                          ),
                          Image.asset(
                            clubImagePathOne,
                            height: h * 0.03,
                            width: w * 0.03,
                            errorBuilder: (context, object, stacktrace) {
                              return Text(
                                '${firstPlayer!.personalInfo['Club']}\n',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.015,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            clubImagePathTwo,
                            height: h * 0.03,
                            width: w * 0.03,
                            errorBuilder: (context, object, stacktrace) {
                              return Text(
                                '${firstPlayer!.personalInfo['Club']}\n',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.015,
                                ),
                              );
                            },
                          ),
                          Image.asset(
                            nationImageTwo,
                            width: w * 0.02,
                            height: h * 0.02,
                            errorBuilder: (context, object, stacktrace) {
                              return Text(
                                '${firstPlayer!.personalInfo['National Team']}\n',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.015,
                                ),
                              );
                            },
                          ),
                          Image.asset(
                            playerImageTwo,
                            width: w * 0.05,
                            height: h * 0.08,
                            errorBuilder: (context, object, stacktrace) {
                              return Text(
                                widget.player2,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.015,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: w * 0.001 / 3,
                    endIndent: h * 0.06,
                    indent: h * 0.06,
                    height: 0,
                  ),
                  SizedBox(
                    height: h * 0.02,
                    width: double.infinity,
                  ),
                  Center(
                    child: Text(
                      'Per 90 Stats',
                      style: TextStyle(
                        fontSize: h * 0.03,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.03,
                      vertical: h * 0.03,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: firstPlayer!.per90.map<Widget>((value) {
                            return Padding(
                              padding: EdgeInsets.only(top: h * 0.01),
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: h * 0.02,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Column(
                          children: firstPlayer!.statistic.map<Widget>((value) {
                            return Padding(
                              padding: EdgeInsets.only(top: h * 0.01),
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: h * 0.02,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Column(
                          children: secondPlayer!.per90.map<Widget>((value) {
                            return Padding(
                              padding: EdgeInsets.only(top: h * 0.01),
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: h * 0.02,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
