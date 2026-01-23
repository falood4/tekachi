import 'package:flutter/material.dart';
import '../test/testHome.dart';
import '../userSettings/userSettings.dart';
import './Aptitude Training/AptitudeHome.dart';

class PrepHome extends StatelessWidget {
  const PrepHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(screenWidth*0.05),
            child: Column(
              children: [
                Expanded(
                  child: Text(
                    'Prepare',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF8DD300),
                      fontFamily: "DelaGothicOne",
                      fontSize: 0.15 * screenWidth,
                    ),
                  ),
                ),

                Expanded(
                  child: TrainChoice(
                    title: 'Aptitude\nTraining',
                    i: 2,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => AptitudeHome()),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: TrainChoice(
                    title: 'Technical\nTraining',
                    i: 2,
                    onTap: () {
                      // navigate to aptitude
                    },
                  ),
                ),
                Expanded(
                  child: TrainChoice(
                    title: 'HR\nTraining',
                    i: 2,
                    onTap: () {
                      // navigate to aptitude
                    },
                  ),
                ),

                Container(
                  height: screenHeight * 0.15,
                  margin: EdgeInsets.only(top:3),
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'AI Mentor',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "DelaGothicOne",
                            fontSize: 0.075 * screenWidth,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: SizedBox(
                            width: 150,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "DelaGothicOne",
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(16),
                                backgroundColor: Color(0xFF8DD300),
                              ),
                              child: Text(
                                "Start",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
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
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.08,
      alignment: Alignment.bottomCenter,
      color: const Color(0xFF8DD300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: ImageIcon(
              AssetImage('assets/nav_icons/prepNav.png'),
              color: Colors.black,
              size: screenHeight * 0.1,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const PrepHome()),
              );
            },
          ),
          IconButton(
            icon: ImageIcon(
              AssetImage('assets/nav_icons/testNav.png'),
              color: Colors.black,
              size: screenHeight * 0.1,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TestHome()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black, size: screenHeight * 0.045,),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserSettings()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TrainChoice extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final int i;

  void onPressed() {}

  const TrainChoice({
    super.key,
    required this.title,
    required this.onTap,
    required this.i,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: i == 4 ? 0 : 3),
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title, textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "DelaGothicOne",
                  fontSize: 0.075 * screenWidth,
                ),
              ),
              IconButton(
                onPressed: onTap,
                icon: Icon(
                  Icons.play_circle_fill_rounded,
                  size: 0.1 * screenWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
