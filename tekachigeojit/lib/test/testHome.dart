import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/prepHome.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/test/AptitudeTest.dart';

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
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Test',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8DD300),
                  fontFamily: "DelaGothicOne",
                  fontSize: 0.15 * screenWidth,
                ),
              ),
              const SizedBox(height: 10),

              TrainingCard(
                title: 'Aptitude Test',
                icon: Icons.calculate_rounded,
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => AptitudeTest()));
                },
              ),

              TrainingCard(
                title: 'Tech Interview',
                icon: Icons.code_rounded,
                onTap: () {
                  // navigate to aptitude
                },
              ),

              TrainingCard(
                title: 'HR Interview',
                icon: Icons.groups_rounded,
                onTap: () {
                  // navigate to aptitude
                },
              ),

              const SizedBox(height: 20),

              Container(
                height: screenHeight * 0.18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Color(0xFF8DD300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '3 Step Interview',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'DelaGothicOne',
                        fontSize: screenWidth * 0.07,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Comprehensive Mock Interview',
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          fontFamily: "DelaGothicOne",
                          color: Color(0xFF8DD300),
                        ),
                      ),
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
