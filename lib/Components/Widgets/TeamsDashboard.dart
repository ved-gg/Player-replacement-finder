import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:player_replacement/Components/constants.dart';

class TeamsDashboard extends StatefulWidget {
  String teamName;
  String leagueName;
  TeamsDashboard({required this.teamName, required this.leagueName, super.key});

  @override
  State<TeamsDashboard> createState() => _TeamsDashboardState();
}

class _TeamsDashboardState extends State<TeamsDashboard> {
  @override
  void initState() {
    super.initState();
    squad_playing_minutes();
  }

  Uint8List? minutesImage;
  Uint8List? possesionImage;
  Uint8List? xgImage;
  Uint8List? qualityImage;
  Uint8List? topPerformersImage;

  bool isMinutesLoading = true;
  bool isPossesionLoading = true;
  bool isXgLoading = true;
  bool isQualityLoading = true;
  bool isTopPerformersLoading = true;

  Future<void> squad_playing_minutes() async {
    try {
      final response = await http.get(
          Uri.parse(
              "https://player-replacement-finder.onrender.com/plot_squad_minutes"),
          headers: {
            'squad-name': widget.teamName,
            'league-name': widget.leagueName,
          });

      if (response.statusCode == 200) {
        setState(() {
          minutesImage = response.bodyBytes;
          isMinutesLoading = false;
        });
      } else {
        print("Failed to load image");
      }
    } catch (e) {
      print("Error fetching data");
      setState(() {
        isMinutesLoading = true;
      });
    }
  }

    Future<void> league_possesion() async {
    try {
      final response = await http.get(
          Uri.parse(
              "https://player-replacement-finder.onrender.com/plot_league_possesion"),
          headers: {
            'squad-name': widget.teamName,
            'league-name': widget.leagueName,
          });

      if (response.statusCode == 200) {
        setState(() {
          possessionImage = response.bodyBytes;
          isPossesionLoading = false;
        });
      } else {
        print("Failed to load image");
      }
    } catch (e) {
      print("Error fetching data");
      setState(() {
        isPosessionLoading = true;
      });
    }
  }

    Future<void> squad_xg() async {
    try {
      final response = await http.get(
          Uri.parse(
              "https://player-replacement-finder.onrender.com/plot_league_xg_comparison"),
          headers: {
            'squad-name': widget.teamName,
            'league-name': widget.leagueName,
          });

      if (response.statusCode == 200) {
        setState(() {
          xgImage = response.bodyBytes;
          isXgLoading = false;
        });
      } else {
        print("Failed to load image");
      }
    } catch (e) {
      print("Error fetching data");
      setState(() {
        isXgLoading = true;
      });
    }
  }

    Future<void> squad_quality_volume() async {
    try {
      final response = await http.get(
          Uri.parse(
              "https://player-replacement-finder.onrender.com/plot_quality_volume_scatter"),
          headers: {
            'squad-name': widget.teamName,
            'league-name': widget.leagueName,
          });

      if (response.statusCode == 200) {
        setState(() {
          qualityImage = response.bodyBytes;
          isQualityLoading = false;
        });
      } else {
        print("Failed to load image");
      }
    } catch (e) {
      print("Error fetching data");
      setState(() {
        isQualityLoading = true;
      });
    }
  }

    Future<void> squad_top_performers() async {
    try {
      final response = await http.get(
          Uri.parse(
              "https://player-replacement-finder.onrender.com/plot_squad_top_performers"),
          headers: {
            'squad-name': widget.teamName,
            'league-name': widget.leagueName,
            'metric_col' : 'xG.1',
            'metric_label' : 'xG per 90',
          });

      if (response.statusCode == 200) {
        setState(() {
          topPerformersImage = response.bodyBytes;
          isTopPerformersLoading = false;
        });
      } else {
        print("Failed to load image");
      }
    } catch (e) {
      print("Error fetching data");
      setState(() {
        isTopPerformersLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: h * 0.1,
        backgroundColor: kPrimaryColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: kSecondaryColor,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: h * 0.03),
          child: Column(
            children: [
              Text(
                'DataFC',
                style: TextStyle(
                  color: kSecondaryColor,
                  fontFamily: 'Nevis',
                  fontSize: SizeConfig.isMobile
                      ? h * 0.03
                      : SizeConfig.isTablet
                          ? h * 0.04
                          : h * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The ultimate football data club',
                style: TextStyle(
                  color: kSecondaryColor,
                  fontFamily: 'Nevis',
                  fontSize: SizeConfig.isMobile
                      ? h * 0.01
                      : SizeConfig.isTablet
                          ? h * 0.015
                          : h * 0.02,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.teamName,
                style: TextStyle(
                  fontSize: SizeConfig.isMobile
                      ? h * 0.03
                      : SizeConfig.isTablet
                          ? h * 0.04
                          : h * 0.07,
                  fontFamily: 'Barcelona',
                ),
              ),
              isMinutesLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: SizeConfig.isMobile
                          ? h * 0.3
                          : SizeConfig.isTablet
                              ? h * 0.4
                              : h * 0.9,
                      width: SizeConfig.isMobile
                          ? w * 0.3
                          : SizeConfig.isTablet
                              ? w * 0.4
                              : w * 0.8,
                      child: imageBytes == null
                          ? Text(
                              'Data could not be fetched',
                              style: TextStyle(
                                fontSize: SizeConfig.isMobile
                                    ? h * 0.02
                                    : SizeConfig.isTablet
                                        ? h * 0.03
                                        : h * 0.03,
                              ),
                            )
                          : Image.memory(imageBytes!),
                    ),
              isPossesionLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: SizeConfig.isMobile
                          ? h * 0.3
                          : SizeConfig.isTablet
                              ? h * 0.4
                              : h * 0.9,
                      width: SizeConfig.isMobile
                          ? w * 0.3
                          : SizeConfig.isTablet
                              ? w * 0.4
                              : w * 0.8,
                      child: possessionImage == null
                          ? Text(
                              'Data could not be fetched',
                              style: TextStyle(
                                fontSize: SizeConfig.isMobile
                                    ? h * 0.02
                                    : SizeConfig.isTablet
                                        ? h * 0.03
                                        : h * 0.03,
                              ),
                            )
                          : Image.memory(possessionImage!),
                    ),
              isXgLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: SizeConfig.isMobile
                          ? h * 0.3
                          : SizeConfig.isTablet
                              ? h * 0.4
                              : h * 0.9,
                      width: SizeConfig.isMobile
                          ? w * 0.3
                          : SizeConfig.isTablet
                              ? w * 0.4
                              : w * 0.8,
                      child: xgImage == null
                          ? Text(
                              'Data could not be fetched',
                              style: TextStyle(
                                fontSize: SizeConfig.isMobile
                                    ? h * 0.02
                                    : SizeConfig.isTablet
                                        ? h * 0.03
                                        : h * 0.03,
                              ),
                            )
                          : Image.memory(xgImage!),
                    ),
              isQualityLoading  
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: SizeConfig.isMobile
                          ? h * 0.3
                          : SizeConfig.isTablet
                              ? h * 0.4
                              : h * 0.9,
                      width: SizeConfig.isMobile
                          ? w * 0.3
                          : SizeConfig.isTablet
                              ? w * 0.4
                              : w * 0.8,
                      child: qualityImage == null
                          ? Text(
                              'Data could not be fetched',
                              style: TextStyle(
                                fontSize: SizeConfig.isMobile
                                    ? h * 0.02
                                    : SizeConfig.isTablet
                                        ? h * 0.03
                                        : h * 0.03,
                              ),
                            )
                          : Image.memory(qualityImage!),
                    ),  


              isTopPerformersLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: SizeConfig.isMobile
                          ? h * 0.3
                          : SizeConfig.isTablet
                              ? h * 0.4
                              : h * 0.9,
                      width: SizeConfig.isMobile
                          ? w * 0.3
                          : SizeConfig.isTablet
                              ? w * 0.4
                              : w * 0.8,
                      child: topPerformersImage == null
                          ? Text(
                              'Data could not be fetched',
                              style: TextStyle(
                                fontSize: SizeConfig.isMobile
                                    ? h * 0.02
                                    : SizeConfig.isTablet
                                        ? h * 0.03
                                        : h * 0.03,
                              ),
                            )
                          : Image.memory(topPerformersImage!),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
