import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/Widgets/NavBar.dart';
import 'package:tekachigeojit/test_interview/3%20Step%20Placement/PlacementHistory.dart';
import 'package:tekachigeojit/test_interview/Aptitude%20Quiz/AptitudeTest.dart';
import 'package:tekachigeojit/test_interview/Aptitude%20Quiz/AptitudeTestHistory.dart';
import 'package:tekachigeojit/test_interview/HrInterviewIntro.dart';
import 'package:tekachigeojit/components/ChatPages/InterviewHistory.dart';
import 'package:tekachigeojit/test_interview/3%20Step%20Placement/PlacementFull.dart';
import 'package:tekachigeojit/test_interview/TechInterviewIntro.dart';

class TestHome extends StatelessWidget {
  const TestHome({super.key});

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

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
                  fontFamily: 'RussoOne',
                  fontWeight: FontWeight.w100,
                  color: theme.colorScheme.secondary,
                ),
              ),

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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          InterviewHistory(personaId: 2, title: "Tech"),
                    ),
                  );
                },
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Techinterviewintro()),
                  );
                },
              ),

              TestCard(
                title: 'HR Interview',
                icon: Icons.groups_rounded,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          InterviewHistory(personaId: 3, title: "HR"),
                    ),
                  );
                },
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => HRinterviewIntro()));
                },
              ),

              const SizedBox(height: 20),

              Container(
                height: screenHeight * 0.24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: accent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '3 Step Interview',
                      style: TextStyle(
                        fontFamily: 'Rostex',
                        fontSize: screenWidth * 0.06,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Comprehensive Mock Interview',
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PlacementFull()),
                        );
                      },
                      style: theme.elevatedButtonTheme.style,
                      child: Text(
                        'Start',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 22,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PlacementHistory()),
                        );
                      },
                      style: theme.elevatedButtonTheme.style?.copyWith(
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Color(0xFFEAEAEA),
                        ),
                      ),
                      child: Text(
                        'Archive',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: Colors.black87,
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
    final theme = Theme.of(context);
    final accent = theme.colorScheme.secondary;
    final cardColor = theme.colorScheme.surfaceDim;

    return Padding(
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
            child: Row(
              children: [
                Icon(icon, size: 36, color: accent),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: 'Trebuchet',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    onPressed: onPressed,
                    icon: Icon(Icons.history, color: accent),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
