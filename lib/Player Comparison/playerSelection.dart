import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:player_replacement/Player%20Comparison/playerComparison.dart';

class SelectPlayer extends StatefulWidget {
  const SelectPlayer({super.key});

  @override
  State<SelectPlayer> createState() => _SelectPlayerState();
}

class _SelectPlayerState extends State<SelectPlayer> {
  final player1 = TextEditingController();
  final player2 = TextEditingController();
  bool isOneAvailable = true;
  bool isTwoAvailable = true;
  bool validateOne = false;
  bool validateTwo = false;
  @override
  void dispose() {
    player1.dispose();
    player2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final h = mediaQuery.size.height;
    final w = mediaQuery.size.width;

    return Scaffold(
      body: Center(
        child: Container(
          height: h * 0.7,
          width: w * 0.3,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(h * 0.03),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select players to compare',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: h * 0.02,
                ),
              ),
              SizedBox(
                height: h * 0.04,
              ),
              SizedBox(
                height: h * 0.05,
                width: w * 0.15,
                child: TextField(
                  controller: player1,
                  decoration: InputDecoration(
                    hintText: "Player Name 1",
                    hintStyle: TextStyle(
                      fontSize: h * 0.02,
                    ),
                    errorText: validateOne ? "Value Can't Be Empty" : null,
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: h * 0.02,
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              SizedBox(
                height: h * 0.05,
                width: w * 0.15,
                child: TextField(
                  controller: player2,
                  decoration: InputDecoration(
                    hintText: "Player Name 2",
                    hintStyle: TextStyle(
                      fontSize: h * 0.02,
                    ),
                    errorText: validateTwo ? "Value Can't Be Empty" : null,
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: h * 0.02,
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.03,
                width: w * 0.04,
              ),
              TextButton(
                child: Text('Compare Players'),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    player1.text.isEmpty
                        ? validateOne = true
                        : validateOne = false;
                    player2.text.isEmpty
                        ? validateTwo = true
                        : validateTwo = false;
                  });
                  if (player1.text.isNotEmpty && player2.text.isNotEmpty) {
                    if (isOneAvailable == false || isTwoAvailable == false) {
                      if (isOneAvailable == false) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Player 1 not found'),
                            content:
                                Text('No player named ${player1.text} found'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                      if (isTwoAvailable == false) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Player 2 not found'),
                            content:
                                Text('No player named ${player2.text} found'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerComparison(
                            player1: player1.text,
                            player2: player2.text,
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
