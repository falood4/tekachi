import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/test/QuizPage.dart';

class AptitudeTest extends StatelessWidget {
  const AptitudeTest({super.key});

  static const Color _bg = Color.fromRGBO(20, 20, 20, 1.0);
  static const Color _accent = Color(0xFF8DD300);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: NavBar(),
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        iconTheme: const IconThemeData(color: _accent),
        title: Text(
          'Aptitude Test',
          style: TextStyle(
            color: _accent,
            fontFamily: "Trebuchet",
            fontSize: 0.075 * screenWidth,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.02,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'This aptitude test will measure and determine your abilities in problem-solving, logic, and reasoning in arithmetic and language',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontFamily: "Trebuchet",
                    fontSize: 0.05 * screenWidth,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    width: screenWidth * 0.45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => QuizPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 0.06 * screenWidth,
                          fontFamily: "DelaGothicOne",
                          color: Colors.black,
                        ),
                        padding: EdgeInsets.all(12),
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
      ),
    );
  }
}
