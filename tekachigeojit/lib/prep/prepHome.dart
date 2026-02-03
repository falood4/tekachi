import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/HR%20Training/HRQuestions.dart';
import 'package:tekachigeojit/prep/Techincal%20Training/TechnicalHome.dart';
import './Aptitude Training/AptitudeHome.dart';
import 'package:tekachigeojit/components/NavBar.dart';

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
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Prepare',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8DD300),
                  fontFamily: 'DelaGothicOne',
                  fontSize: screenWidth * 0.13,
                ),
              ),
              const SizedBox(height: 20),

              TrainingCard(
                title: 'Aptitude Training',
                icon: Icons.calculate_rounded,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AptitudeHome()),
                ),
              ),
              TrainingCard(
                title: 'Technical Training',
                icon: Icons.code_rounded,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TechnicalHome()),
                ),
              ),
              TrainingCard(
                title: 'HR Training',
                icon: Icons.groups_rounded,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HrTrainingScreen()),
                ),
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
                      'AI Mentor',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Rostex',
                        fontSize: screenWidth * 0.07,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Personalized interview practice',
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
                          color: Color(0xFF8DD300),
                          fontFamily: "DelaGothicOne",
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

class TrainingCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const TrainingCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
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
                const Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
