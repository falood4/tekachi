import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/prepHome.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class TestHome extends StatelessWidget {
  const TestHome({super.key});

  void onPressed() {}

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
            margin: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              children: [
                Expanded(
                  child: Text(
                    'Test',
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
                    title: 'Aptitude\nTest',
                    i: 2,
                    onTap: () {
                      // navigate to aptitude
                    },
                  ),
                ),

                Expanded(
                  child: TrainChoice(
                    title: 'Technical\nInterview',
                    i: 2,
                    onTap: () {
                      // navigate to aptitude
                    },
                  ),
                ),

                Expanded(
                  child: TrainChoice(
                    title: 'HR\nInterview',
                    i: 2,
                    onTap: () {
                      // navigate to aptitude
                    },
                  ),
                ),

                Container(
                  height: screenHeight * 0.15,
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '3 Step Placement',
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
                                backgroundColor: Colors.black,
                              ),
                              child: Text(
                                "Start",
                                style: TextStyle(color: Color(0xFF8DD300)),
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


