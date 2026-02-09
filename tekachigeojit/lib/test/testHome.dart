import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/test/Aptitude%20Quiz/AptitudeTest.dart';
import 'package:tekachigeojit/test/Aptitude%20Quiz/AptitudeTestHistory.dart';

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

              TestCard(
                title: 'Aptitude Test',
                icon: Icons.calculate_rounded,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AptitudeTestHistory()),
                  );
                },
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => AptitudeTest()));
                },
              ),

              TestCard(
                title: 'Tech Interview',
                icon: Icons.code_rounded,
                onPressed: () {
                  //Tech interview page to be implemented later
                },
                onTap: () {
                  // navigate to aptitude
                },
              ),

              TestCard(
                title: 'HR Interview',
                icon: Icons.groups_rounded,
                onPressed: () {
                  //HR interview page to be implemented later
                },
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
                        fontFamily: 'Rostex',
                        fontSize: screenWidth * 0.06,
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

class TestCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onPressed;

  const TestCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFD9D9D9),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: screenWidth * 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'RussoOne',
                      fontSize: screenWidth * 0.055,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    onPressed: onPressed,
                    icon: Icon(Icons.history),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
