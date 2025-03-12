// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:player_replacement/Components/constants.dart';

class AllLeagues extends StatefulWidget {
  const AllLeagues({super.key});

  @override
  State<AllLeagues> createState() => _AllLeaguesState();
}

class _AllLeaguesState extends State<AllLeagues> {
  Color premColor = const Color(0xFF3d195b);
  Color laLigaColor = const Color(0xFFFF4B44);
  Color bundesligaColor = const Color(0xFFD10214);
  Color serieAColor = const Color(0xFF0578FF);
  Color erediviseColor = const Color(0xFF002F63);
  Color portugalColor = const Color(0xFF00235A);
  Color scottishPLColor = const Color(0xFF27305D);
  Color ligueOneColor = Colors.black;
  Color superLigColor = Colors.black;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: h * 0.05),
          child: Column(
            children: [
              Text(
                'Insights into the best leagues around the world, right here, right now!',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: h * 0.03,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'League Spartan',
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: h * 0.05,
                  horizontal: w * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LeagueContainers(
                      containerColor: premColor,
                      leagueName: 'Premier League',
                      logoPath: 'images/Leagues/Prem.png',
                      textColor: premColor,
                      routeName: '/PremierLeague',
                    ),
                    LeagueContainers(
                      containerColor: laLigaColor,
                      leagueName: 'La Liga',
                      logoPath: 'images/Leagues/LaLiga.png',
                      textColor: laLigaColor,
                      routeName: '/LaLiga',
                    ),
                    LeagueContainers(
                      containerColor: portugalColor,
                      leagueName: 'Liga Portgual',
                      logoPath: 'images/Leagues/LigaPortugal.png',
                      textColor: portugalColor,
                      routeName: '/LigaPortugal',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: h * 0.03,
                  horizontal: w * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LeagueContainers(
                      containerColor: bundesligaColor,
                      leagueName: 'Bundesliga',
                      logoPath: 'images/Leagues/Bundesliga.png',
                      textColor: bundesligaColor,
                      routeName: '/Bundesliga',
                    ),
                    LeagueContainers(
                      containerColor: erediviseColor,
                      leagueName: 'Eredivise',
                      logoPath: 'images/Leagues/Eredivise.png',
                      textColor: erediviseColor,
                      routeName: '/Eredivise',
                    ),
                    LeagueContainers(
                      containerColor: serieAColor,
                      leagueName: 'Serie A',
                      logoPath: 'images/Leagues/SerieA.png',
                      textColor: serieAColor,
                      routeName: '/SerieA',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: h * 0.03,
                  horizontal: w * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LeagueContainers(
                      containerColor: ligueOneColor,
                      leagueName: 'Ligue One',
                      logoPath: 'images/Leagues/Ligue1.png',
                      textColor: ligueOneColor,
                      routeName: '/LigueOne',
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

class LeagueContainers extends StatelessWidget {
  Color containerColor;
  String leagueName;
  String logoPath;
  Color textColor;
  String routeName;

  LeagueContainers({
    super.key,
    required this.containerColor,
    required this.leagueName,
    required this.logoPath,
    required this.textColor,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        height: h * 0.2,
        width: w * 0.3,
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: containerColor,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logoPath,
              height: h * 0.1,
            ),
            SizedBox(width: w * 0.01),
            Text(
              leagueName,
              style: TextStyle(
                color: containerColor,
                fontSize: h * 0.03,
                fontWeight: FontWeight.bold,
                fontFamily: 'League Spartan',
                letterSpacing: w * 0.001,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
