import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:player_replacement/Components/constants.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Color _playerContainerColor = kSecondaryColor;
  Color _playerContainerColorText = kPrimaryColor;
  Color _teamContainerColor = kSecondaryColor;
  Color _teamContainerColorText = kPrimaryColor;
  bool isHovered = false;
  bool isHovered2 = false;
  bool isHovered3 = false;
  bool isHovered4 = false;
  bool isHovered5 = false;
  bool isHovered6 = false;
  bool isHovered7 = false;
  bool isHovered8 = false;
  List facts = [
    'Steaua Bucharest went 104 games unbeaten in domestic competitions between 1986 and 1989, making it the longest undefeated streak in top-flight football history. (Verified by FIFA & UEFA)',
    'In 2000, English player Lee Todd was sent off after 2 seconds for swearing when the referee blew the whistle too loudly. (Confirmed by Guinness World Records)',
    'Brazilian goalkeeper Rogério Ceni scored 131 goals in his career—mostly from free-kicks and penalties. (Verified by FIFA & IFHHS - International Federation of Football History & Statistics)',
    'Tommy Ross of Ross County scored a hat-trick in 90 seconds (1964), which remains the fastest ever recorded.(Guinness World Records)',
    'In a Brazilian league match, a referee accidentally deflected a shot into the goal. Since the ball was still in play, the goal stood! (Rare but confirmed incident in South American football.)',
    'In 2011, a match between Claypole and Victoriano Arenas (Argentina) saw 36 red cards issued—players, substitutes, and coaches were all sent off! (Verified by FIFA.)',
    "Lev Yashin (1963) remains the only goalkeeper ever to win the Ballon d'or, despite legendary goalkeepers like Buffon and Neuer coming close. (FIFA & Ballon d'Or records.)",
    "The Jules Rimet Trophy was stolen before the 1966 World Cup but was found in a London garden by a dog named Pickles! (Historical fact, widely reported.)",
    "AS Adema 149-0 SO l’Emyrne (2002) remains the biggest victory in football history. SO l'Emyrne deliberately scored own goals in protest of refereeing decisions. (Guinness World Records.)",
    "Hakan Şükür (Turkey) scored after just 11 seconds against South Korea in the 2002 FIFA World Cup, the fastest goal ever in World Cup history. (FIFA Official Records.)",
    "The first official international football match was between Scotland and England on November 30, 1872, and ended 0-0. (FIFA & British FA records.)",
    "The longest match lasted 3 days (over 100 hours!) in the UK, organized for charity in 2016. (Guinness World Records.)",
    "Bert Patenaude (USA, 1930) scored the first World Cup hat-trick in history against Paraguay. (Confirmed by FIFA.)",
    "Pelé remains the only player in history to win 3 FIFA World Cups (1958, 1962, 1970). (FIFA World Cup records.)",
    "The longest professional football match lasted 3 hours and 23 minutes! between Stockport and Doncaster Rovers in 1946 and went to 203 minutes because the referee forgot to stop the game.(Source: BBC Sport)",
  ];

  Random random = Random();
  int randomNumber = 0; // Declare the variable

  @override
  void initState() {
    super.initState();
    randomNumber = random.nextInt(14) + 1; // Initialize the variable
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: h * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MouseRegion(
                    opaque: false,
                    onEnter: (event) => setState(() {
                      _playerContainerColor = kPrimaryColor;
                      _playerContainerColorText = kSecondaryColor;
                    }),
                    onExit: (event) => setState(() {
                      _playerContainerColor = kSecondaryColor;
                      _playerContainerColorText = kPrimaryColor;
                    }),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/PlayerPositions');
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        height: h * 0.4,
                        width: w * 0.2,
                        decoration: BoxDecoration(
                          color: _playerContainerColor,
                          borderRadius: BorderRadius.circular(
                            w * 0.01,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryColor,
                              spreadRadius: h * 0.002,
                              blurRadius: w * 0.02,
                              offset: Offset(h * 0.02, h * 0.02),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              '/images/Players/RandomPlayer.png',
                              height: h * 0.2,
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Text(
                              'PLAYERS',
                              style: TextStyle(
                                fontSize: h * 0.03,
                                color: _playerContainerColorText,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'League Spartan',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: w * 0.05,
                    height: h * 0.05,
                  ),
                  MouseRegion(
                    onEnter: (event) => setState(() {
                      _teamContainerColor = kPrimaryColor;
                      _teamContainerColorText = kSecondaryColor;
                    }),
                    onExit: (event) => setState(() {
                      _teamContainerColor = kSecondaryColor;
                      _teamContainerColorText = kPrimaryColor;
                    }),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/AllTeams');
                      },
                      child: Container(
                        height: h * 0.4,
                        width: w * 0.2,
                        decoration: BoxDecoration(
                          color: _teamContainerColor,
                          borderRadius: BorderRadius.circular(
                            w * 0.01,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryColor,
                              spreadRadius: h * 0.002,
                              blurRadius: w * 0.02,
                              offset: Offset(h * 0.02, h * 0.02),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              '/images/Players/TeamPhoto.png',
                              height: h * 0.2,
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Text(
                              'TEAMS',
                              style: TextStyle(
                                fontSize: h * 0.03,
                                color: _teamContainerColorText,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'League Spartan',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: h * 0.07,
              ),
              Column(
                children: [
                  Text(
                    'Legends & Lore',
                    style: TextStyle(
                      fontSize: h * 0.03,
                      fontFamily: 'Nevis',
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  Text(
                    facts[randomNumber],
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: h * 0.02,
                      fontFamily: 'League Spartan',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: h * 0.07,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: kPrimaryColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.08),
                      child: Text(
                        'Top teams around the world',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: h * 0.03,
                          fontFamily: 'Nevis',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: h * 0.07,
              ),
              // Fc Barcelona
              MouseRegion(
                onEnter: (event) => setState(() => isHovered = true),
                onExit: (event) => setState(() => isHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: h * 0.2,
                  width: w,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'images/Clubs/Backgrounds/FCBarcelonaStripes.png',
                          width: w,
                          height: h * 0.4,
                          fit: BoxFit.cover,
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered ? w * 0.43 : w * 0.45,
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            'images/Clubs/Barcelona.png',
                            height: h * 0.15,
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered ? w * 0.52 : w * 0.48,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isHovered ? 1.0 : 0.0,
                            child: Text(
                              'FC BARCELONA',
                              style: TextStyle(
                                fontSize: h * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Barcelona',
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered ? w * 0.24 : w * 0.20,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered ? 1.0 : 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Founded in',
                                  style: TextStyle(
                                    fontSize: h * 0.03,
                                    color: Colors.white,
                                    fontFamily: 'Nevis',
                                  ),
                                ),
                                Text(
                                  '1899',
                                  style: TextStyle(
                                    fontSize: h * 0.06,
                                    color: Colors.white,
                                    fontFamily: 'Barcelona',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered ? w * 0.70 : w * 0.65,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered ? 1.0 : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/UCL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'UCL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x5',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/LaLiga.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'LA LIGA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x15',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/CopaDelRey.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'COPA DEL REY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x31',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Real Madrid
              MouseRegion(
                onEnter: (event) => setState(() => isHovered2 = true),
                onExit: (event) => setState(() => isHovered2 = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: h * 0.2,
                  width: w,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          color: kSecondaryColor,
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered2 ? w * 0.43 : w * 0.45,
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            'images/Clubs/RealMadrid.png',
                            height: h * 0.15,
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered2 ? w * 0.52 : w * 0.48,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isHovered2 ? 1.0 : 0.0,
                            child: Text(
                              'REAL MADRID',
                              style: TextStyle(
                                fontSize: h * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Barcelona',
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered ? w * 0.24 : w * 0.20,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered ? 1.0 : 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Founded in',
                                  style: TextStyle(
                                    fontSize: h * 0.03,
                                    color: Colors.white,
                                    fontFamily: 'Nevis',
                                  ),
                                ),
                                Text(
                                  '1899',
                                  style: TextStyle(
                                    fontSize: h * 0.06,
                                    color: Colors.white,
                                    fontFamily: 'Barcelona',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered ? w * 0.70 : w * 0.65,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered ? 1.0 : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/UCL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'UCL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x5',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/LaLiga.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'LA LIGA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x15',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/CopaDelRey.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'COPA DEL REY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x31',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered2 ? w * 0.24 : w * 0.20,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered2 ? 1.0 : 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Founded in',
                                  style: TextStyle(
                                    fontSize: h * 0.03,
                                    color: Colors.black,
                                    fontFamily: 'Nevis',
                                  ),
                                ),
                                Text(
                                  '1902',
                                  style: TextStyle(
                                    fontSize: h * 0.06,
                                    color: Colors.black,
                                    fontFamily: 'Barcelona',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered2 ? w * 0.70 : w * 0.65,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered2 ? 1.0 : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/UCL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      'UCL',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x15',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/LaLiga.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      'LA LIGA',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x36',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/CopaDelRey.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      'COPA DEL REY',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x20',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Liverpool
              MouseRegion(
                onEnter: (event) => setState(() => isHovered3 = true),
                onExit: (event) => setState(() => isHovered3 = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: h * 0.2,
                  width: w,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'images/Clubs/Backgrounds/Liverpoolback.png',
                          width: w,
                          height: h * 0.4,
                          fit: BoxFit.cover,
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered3 ? w * 0.40 : w * 0.42,
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            'images/Clubs/Liverpool.png',
                            height: h * 0.15,
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered3 ? w * 0.5 : w * 0.45,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isHovered3 ? 1.0 : 0.0,
                            child: Text(
                              'LIVERPOOL',
                              style: TextStyle(
                                fontSize: h * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Barcelona',
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered3 ? w * 0.24 : w * 0.20,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered3 ? 1.0 : 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Founded in',
                                  style: TextStyle(
                                    fontSize: h * 0.03,
                                    color: Colors.white,
                                    fontFamily: 'Nevis',
                                  ),
                                ),
                                Text(
                                  '1892',
                                  style: TextStyle(
                                    fontSize: h * 0.06,
                                    color: Colors.white,
                                    fontFamily: 'Barcelona',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered3 ? w * 0.70 : w * 0.65,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered3 ? 1.0 : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/UCL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'UCL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x6',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/PL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'PREMIER LEAGUE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x1',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/FACup.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'FA CUP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x8',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //MAN CITY
              MouseRegion(
                onEnter: (event) => setState(() => isHovered4 = true),
                onExit: (event) => setState(() => isHovered4 = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: h * 0.2,
                  width: w,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'images/Clubs/Backgrounds/Mancityback.png',
                          width: w,
                          height: h * 0.4,
                          fit: BoxFit.cover,
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered4 ? w * 0.40 : w * 0.42,
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            'images/Clubs/ManCity.png',
                            height: h * 0.15,
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered4 ? w * 0.52 : w * 0.46,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isHovered4 ? 1.0 : 0.0,
                            child: Text(
                              'MANCHESTER CITY',
                              style: TextStyle(
                                fontSize: h * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Barcelona',
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered4 ? w * 0.24 : w * 0.20,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered4 ? 1.0 : 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Founded in',
                                  style: TextStyle(
                                    fontSize: h * 0.03,
                                    color: Colors.white,
                                    fontFamily: 'Nevis',
                                  ),
                                ),
                                Text(
                                  '1880',
                                  style: TextStyle(
                                    fontSize: h * 0.06,
                                    color: Colors.white,
                                    fontFamily: 'Barcelona',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered4 ? w * 0.70 : w * 0.65,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered4 ? 1.0 : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/UCL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'UCL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x1',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/PL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'PREMIER LEAGUE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x10',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/FACup.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'FA CUP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x7',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Borussia Dortmund
              MouseRegion(
                onEnter: (event) => setState(() => isHovered5 = true),
                onExit: (event) => setState(() => isHovered5 = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: h * 0.2,
                  width: w,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'images/Clubs/Backgrounds/Dortmundback.png',
                          width: w,
                          height: h * 0.4,
                          fit: BoxFit.cover,
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered5 ? w * 0.42 : w * 0.435,
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            'images/Clubs/BorussiaDortmund.png',
                            height: h * 0.15,
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered5 ? w * 0.54 : w * 0.47,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isHovered5 ? 1.0 : 0.0,
                            child: Text(
                              'BORUSSIA DORTMUND',
                              style: TextStyle(
                                fontSize: h * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow,
                                fontFamily: 'Barcelona',
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered5 ? w * 0.24 : w * 0.20,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered5 ? 1.0 : 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Founded in',
                                  style: TextStyle(
                                    fontSize: h * 0.03,
                                    color: Colors.yellow,
                                    fontFamily: 'Nevis',
                                  ),
                                ),
                                Text(
                                  '1909',
                                  style: TextStyle(
                                    fontSize: h * 0.06,
                                    color: Colors.yellow,
                                    fontFamily: 'Barcelona',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered5 ? w * 0.70 : w * 0.65,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered5 ? 1.0 : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/UCL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.yellow,
                                    ),
                                    Text(
                                      'UCL',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x1',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/Bundesliga.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.yellow,
                                    ),
                                    Text(
                                      'BUNDESLIGA',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x8',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: w * 0.01 / 2,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/DFBPokal.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.yellow,
                                    ),
                                    Text(
                                      'DFB POKAL',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x5',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Bayern Munich
              MouseRegion(
                onEnter: (event) => setState(() => isHovered6 = true),
                onExit: (event) => setState(() => isHovered6 = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: h * 0.2,
                  width: w,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'images/Clubs/Backgrounds/Bayernback.png',
                          width: w,
                          height: h * 0.4,
                          fit: BoxFit.cover,
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered6 ? w * 0.40 : w * 0.427,
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            'images/Clubs/BayernMunich.png',
                            height: h * 0.15,
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered6 ? w * 0.52 : w * 0.46,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isHovered6 ? 1.0 : 0.0,
                            child: Text(
                              'BAYERN MUNICH',
                              style: TextStyle(
                                fontSize: h * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Barcelona',
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered6 ? w * 0.24 : w * 0.20,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered6 ? 1.0 : 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Founded in',
                                  style: TextStyle(
                                    fontSize: h * 0.03,
                                    color: Colors.white,
                                    fontFamily: 'Nevis',
                                  ),
                                ),
                                Text(
                                  '1900',
                                  style: TextStyle(
                                    fontSize: h * 0.06,
                                    color: Colors.white,
                                    fontFamily: 'Barcelona',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered6 ? w * 0.70 : w * 0.65,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered6 ? 1.0 : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/UCL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'UCL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x6',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/Bundesliga.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'BUNDESLIGA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x33',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: w * 0.01 / 2,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/DFBPokal.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'DFB POKAL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x20',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //Chelsea
              MouseRegion(
                onEnter: (event) => setState(() => isHovered7 = true),
                onExit: (event) => setState(() => isHovered7 = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: h * 0.2,
                  width: w,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'images/Clubs/Backgrounds/Chelseaback.png',
                          width: w,
                          height: h * 0.4,
                          fit: BoxFit.cover,
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered7 ? w * 0.42 : w * 0.45,
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            'images/Clubs/Chelsea.png',
                            height: h * 0.15,
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered7 ? w * 0.52 : w * 0.48,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isHovered7 ? 1.0 : 0.0,
                            child: Text(
                              'CHELSEA',
                              style: TextStyle(
                                fontSize: h * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Barcelona',
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered7 ? w * 0.24 : w * 0.20,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered7 ? 1.0 : 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Founded in',
                                  style: TextStyle(
                                    fontSize: h * 0.03,
                                    color: Colors.white,
                                    fontFamily: 'Nevis',
                                  ),
                                ),
                                Text(
                                  '1905',
                                  style: TextStyle(
                                    fontSize: h * 0.06,
                                    color: Colors.white,
                                    fontFamily: 'Barcelona',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered7 ? w * 0.70 : w * 0.65,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered7 ? 1.0 : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/UCL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'UCL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x5',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/PL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'PREMIER LEAGUE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x6',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: w * 0.01 / 2,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/FACup.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'FA Cup',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x5',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //Athletico Madrid
              MouseRegion(
                onEnter: (event) => setState(() => isHovered8 = true),
                onExit: (event) => setState(() => isHovered8 = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: h * 0.2,
                  width: w,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'images/Clubs/Backgrounds/Athleticoback.png',
                          width: w,
                          height: h * 0.4,
                          fit: BoxFit.cover,
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered8 ? w * 0.42 : w * 0.45,
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            'images/Clubs/Athletico.png',
                            height: h * 0.15,
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isHovered8 ? w * 0.50 : w * 0.45,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isHovered8 ? 1.0 : 0.0,
                            child: Text(
                              'ATLETICO MADRID',
                              style: TextStyle(
                                fontSize: h * 0.04,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                                fontFamily: 'Barcelona',
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered8 ? w * 0.24 : w * 0.20,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered8 ? 1.0 : 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Founded in',
                                  style: TextStyle(
                                    fontSize: h * 0.03,
                                    color: kPrimaryColor,
                                    fontFamily: 'Nevis',
                                  ),
                                ),
                                Text(
                                  '1903',
                                  style: TextStyle(
                                    fontSize: h * 0.06,
                                    color: kPrimaryColor,
                                    fontFamily: 'Barcelona',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(microseconds: 500),
                          left: isHovered8 ? w * 0.70 : w * 0.65,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: isHovered8 ? 1.0 : 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/UEL.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: kPrimaryColor,
                                    ),
                                    Text(
                                      'UEL',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x3',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/LaLiga.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: kPrimaryColor,
                                    ),
                                    Text(
                                      'LA LIGA',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x11',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: w * 0.01 / 2,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/Trophies/CopaDelRey.png',
                                      height: h * 0.1,
                                      width: w * 0.05,
                                      color: kPrimaryColor,
                                    ),
                                    Text(
                                      'COPA DEL REY',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                    Text(
                                      'x10',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Nevis',
                                        fontSize: h * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
