import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
            Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.25,
                  horizontal: screenHeight * 0.05,
                ),
                child: const Column(
                  children: [
                    AppTitle(),
                    AppSubtitle(),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: screenWidth * 0.45,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 0.05 * screenWidth,
                        fontFamily: "DelaGothicOne",
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.all(16),
                      backgroundColor: Color(0xFF8DD300),
                    ),
                    child: Text("Log In", style: TextStyle(color: Colors.black)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: screenWidth * 0.45,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 0.05 * screenWidth,
                        fontFamily: "DelaGothicOne",
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.all(16),
                      backgroundColor: Color(0xFFD1D1D1),
                    ),
                    child: Text("Sign Up", style: TextStyle(color: Colors.black)),
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

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Text(
      "Tekachi",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'RussoOne',
        fontSize: 0.2 * screenWidth,
        color: Color(0xFF8DD300),
      ),
    );
  }
}

class AppSubtitle extends StatelessWidget {
  const AppSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Your cheatcode to acing placements",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white),
    );
  }
}