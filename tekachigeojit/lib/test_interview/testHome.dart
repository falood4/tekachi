import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/Widgets/NavBar.dart';
import 'package:tekachigeojit/test_interview/3%20Step%20Placement/PlacementHistory.dart';
import 'package:tekachigeojit/test_interview/Aptitude%20Quiz/AptitudeTest.dart';
import 'package:tekachigeojit/test_interview/HrInterviewIntro.dart';
import 'package:tekachigeojit/test_interview/3%20Step%20Placement/PlacementFull.dart';
import 'package:tekachigeojit/test_interview/TechInterviewIntro.dart';

class TestHome extends StatelessWidget {
  const TestHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    final primary = Colors.white;
    final accent = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: const NavBar(selectedPage: 2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Test',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: screenWidth * 0.125,
                  fontFamily: 'ElmsSansBold',
                  fontWeight: FontWeight.w100,
                  color: accent,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TestCard(
                    title: 'Aptitude\nTest',
                    icon: Icons.calculate_rounded,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => AptitudeTest()));
                    },
                  ),
                  TestCard(
                    title: 'Tech Interview',
                    icon: Icons.code_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => Techinterviewintro()),
                      );
                    },
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TestCard(
                    title: 'HR\nInterview',
                    icon: Icons.groups_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => HRinterviewIntro()),
                      );
                    },
                  ),

                  TestCard(
                    title: '3 Step Archive',
                    icon: Icons.archive_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => PlacementHistory()),
                      );
                    },
                  ),
                ],
              ),

              Container(
                height: screenHeight * 0.25,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Color(0xFF0047AB), width: 5.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mock Placement',
                      style: TextStyle(
                        fontFamily: 'DelaGothicOne',
                        fontSize: 32,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Comprehensive Mock Placement Process',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PlacementFull()),
                        );
                      },
                      style: theme.elevatedButtonTheme.style?.copyWith(
                        backgroundColor: WidgetStatePropertyAll(
                          Color(0xFF0047AB),
                        ),
                      ),
                      child: Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'DelaGothicOne',
                          color: Colors.white,
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

  const TestCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final accent = theme.colorScheme.secondary;
    final cardColor = theme.colorScheme.tertiary;

    return Container(
      height: screenWidth * 0.4,
      width: screenWidth * 0.4,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: screenWidth * 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 56, color: accent),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontFamily: 'ElmsSansBold'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
