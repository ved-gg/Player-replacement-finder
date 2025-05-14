import 'package:flutter/material.dart';
import 'package:player_replacement/Components/constants.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flip_carousel/flip_carousel.dart';
import 'package:player_replacement/PlayerComparison/playerComparison.dart';

class PlayerPositions extends StatelessWidget {
  const PlayerPositions({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SoccerFieldScreen(),
    );
  }
}

class SoccerFieldScreen extends StatefulWidget {
  const SoccerFieldScreen({super.key});

  @override
  SoccerFieldScreenState createState() => SoccerFieldScreenState();
}

class SoccerFieldScreenState extends State<SoccerFieldScreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.isMobile
                ? h * 0.03
                : SizeConfig.isTablet
                    ? h * 0.05
                    : h * 0.07,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Compare Players',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: SizeConfig.isMobile
                      ? h * 0.03
                      : SizeConfig.isTablet
                          ? h * 0.04
                          : h * 0.06,
                  fontFamily: 'Barcelona',
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: h * 0.04),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PositionsCard(
                      position: 'LEFT BACK',
                      positionSF: 'LB',
                    ),
                    PositionsCard(
                      position: 'CENTER BACK',
                      positionSF: 'CB',
                    ),
                    PositionsCard(
                      position: 'RIGHT BACK',
                      positionSF: 'RB',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: h * 0.04),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PositionsCard(
                        position: 'CENTER MIDFIELD',
                        positionSF: 'CM',
                      ),
                      PositionsCard(
                        position: 'DEFENSIVE MIDFIELD',
                        positionSF: 'CDM',
                      ),
                      PositionsCard(
                        position: 'ATTACKING MIDFIELD',
                        positionSF: 'CAM',
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: h * 0.04,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PositionsCard(
                      position: 'LEFT WINGER',
                      positionSF: 'LW',
                    ),
                    PositionsCard(
                      position: 'CENTER FORWARD',
                      positionSF: 'CF',
                    ),
                    PositionsCard(
                      position: 'RIGHT WINGER',
                      positionSF: 'RW',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PositionsCard extends StatelessWidget {
  final String positionSF;
  final String position;

  const PositionsCard({
    super.key,
    required this.positionSF,
    required this.position,
  });

  List decideImagesList() {
    List imagesList = [];
    for (var i = 0; i < 5; i++) {
      String path = 'images/Cards/$positionSF/$i.png';
      imagesList.add(path);
    }
    return imagesList;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      height: SizeConfig.isMobile
          ? h * 0.3
          : SizeConfig.isTablet
              ? h * 0.4
              : h * 0.6,
      width: SizeConfig.isMobile
          ? w * 0.3
          : SizeConfig.isTablet
              ? w * 0.3
              : w * 0.2,
      decoration: BoxDecoration(
        color: kSecondaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: h * 0.001 / 4,
            blurRadius: w * 0.01 / 4,
          ),
        ],
      ),
      child: Padding(
        padding: SizeConfig.isMobile
            ? EdgeInsets.all(h * 0)
            : SizeConfig.isTablet
                ? EdgeInsets.symmetric(
                    vertical: h * 0.020, horizontal: w * 0.01)
                : EdgeInsets.symmetric(
                    vertical: h * 0.025,
                    horizontal: w * 0.02,
                  ),
        child: GestureFlipCard(
          animationDuration: const Duration(milliseconds: 300),
          axis: FlipAxis.vertical,
          frontWidget: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerComparison(
                        positionSF: positionSF,
                        position: position,
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  'images/Positions/$positionSF.png',
                  height: SizeConfig.isMobile
                      ? h * 0.2
                      : SizeConfig.isTablet
                          ? h * 0.3
                          : h * 0.4,
                  width: SizeConfig.isMobile
                      ? w * 0.2
                      : SizeConfig.isTablet
                          ? w * 0.3
                          : w * 0.5,
                ),
              ),
              SizedBox(
                height: h * 0.01,
              ),
              Text(
                position,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: 'Barcelona',
                  fontSize: SizeConfig.isMobile
                      ? h * 0.020
                      : SizeConfig.isTablet
                          ? h * 0.030
                          : h * 0.045,
                ),
              )
            ],
          ),
          backWidget: Column(
            children: [
              FlipCarousel(
                arrowControllersVisibility: false,
                items: decideImagesList(),
                isAssetImage: true,
                height: SizeConfig.isMobile
                    ? h * 0.2
                    : SizeConfig.isTablet
                        ? h * 0.3
                        : h * 0.45,
                width: SizeConfig.isMobile
                    ? w * 0.2
                    : SizeConfig.isTablet
                        ? w * 0.3
                        : w * 0.5,
              ),
              SizedBox(
                height: h * 0.01,
              ),
              Text(
                'NOTABLE PLAYERS',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: 'Barcelona',
                  fontSize: SizeConfig.isMobile
                      ? h * 0.02
                      : SizeConfig.isTablet
                          ? h * 0.03
                          : h * 0.05,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
