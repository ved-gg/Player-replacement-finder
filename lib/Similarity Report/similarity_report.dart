import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:player_replacement/API%20Models/playerModel.dart';
import 'package:player_replacement/API%20Models/summaryModel.dart';
import 'package:player_replacement/Components/constants.dart';
import 'package:http/http.dart' as http;

class SimilarityReport extends StatefulWidget {
  String player1;
  String player2;
  SimilarityReport({super.key, required this.player1, required this.player2});

  @override
  State<SimilarityReport> createState() => _SimilarityReportState();
}

class _SimilarityReportState extends State<SimilarityReport> {
  PlayerClass? firstPlayer;
  PlayerClass? secondPlayer;
  bool _isLoading = true;
  String summary = '';

  @override
  void initState() {
    super.initState();
    _generateReport();
  }

  Future<void> _generateReport() async {
    try {
      await Future.wait([
        giveReport(),
      ]);
    } catch (e) {
      print("Error initializing players: $e");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> giveReport() async {
    final Map<String, String> body = {
      "player1": widget.player1,
      "player2": widget.player2,
    };
    final response = await http.post(
      Uri.parse("https://impulseee.pythonanywhere.com/report"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final jsonResponse = Map<String, dynamic>.from(jsonDecode(response.body));
      PlayerComparisonReport reportModel =
          PlayerComparisonReport.fromJson(jsonResponse);
      print(reportModel.report);
      summary = reportModel.report;
    } else {
      throw Exception(
          "Failed to generate summary of players. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final h = mediaQuery.size.height;
    final w = mediaQuery.size.width;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(
            'Similarity Report',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Handle null checks for firstPlayer and secondPlayer
    if (widget.player1.isEmpty || widget.player2.isEmpty) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.black,
          title: Text(
            'Similarity Report',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'Error 404',
            style: TextStyle(color: Colors.red, fontSize: h * 0.02),
          ),
        ),
      );
    }
    // widget.player1 = 'Lamine Yamal';
    // widget.player2 = 'Lionel Messi';

    //TODO: GRAPHS TO SHOW SIMILARITY USING PERCENTILE METRIC

    widget.player1 = widget.player1.replaceAll('\n', '').trim();
    widget.player2 = widget.player2.replaceAll('\n', '').trim();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Similarity Report',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
            filterQuality: FilterQuality.high,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.03,
            vertical: h * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: h * 0.08,
                width: w * 0.8,
                decoration: BoxDecoration(
                  color: kDarkGrey,
                  border: Border.all(
                    width: h * 0.004 / 2,
                    color: kGreen,
                  ),
                  borderRadius: BorderRadius.circular(h * 0.01),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: h * 0.01,
                    left: w * 0.02,
                  ),
                  child: Text(
                    textAlign: TextAlign.justify,
                    'Similarity report of ${widget.player1} and ${widget.player2}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: h * 0.03,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.03,
                width: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  color: kDarkGrey,
                  borderRadius: BorderRadius.circular(h * 0.02),
                ),
                height: h * 0.6,
                width: w * 0.8,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.02, vertical: h * 0.01),
                  child: Text(
                    summary,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: h * 0.03,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
