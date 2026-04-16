import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/test/3%20Step%20Placement/PlacementHistory.dart';
import 'package:tekachigeojit/test/Aptitude%20Quiz/AptitudeTest.dart';
import 'package:tekachigeojit/test/Aptitude%20Quiz/AptitudeTestHistory.dart';
import 'package:tekachigeojit/test/HrInterviewIntro.dart';
import 'package:tekachigeojit/components/InterviewHistory.dart';
import 'package:tekachigeojit/test/3%20Step%20Placement/PlacementFull.dart';
import 'package:tekachigeojit/test/TechInterviewIntro.dart';

class TestHome extends StatelessWidget {
  const TestHome({super.key});

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    dynamic lime = theme.colorScheme.secondary;
    dynamic black = theme.colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      bottomNavigationBar: const NavBar(selectedPage: 2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Test',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: screenWidth * 0.15,
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
                  color: lime,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '3 Step Interview',
                      style: TextStyle(
                        color: black,
                        fontFamily: 'Rostex',
                        fontSize: screenWidth * 0.06,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Comprehensive Mock Interview',
                      style: TextStyle(color: black),
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

                    SizedBox(height: 5),

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
                          theme.colorScheme.surface,
                        ),
                      ),
                      child: Text(
                        'Archive',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 16,
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
    dynamic black = theme.colorScheme.onPrimary;
    dynamic lightGrey = theme.colorScheme.surface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: lightGrey,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: screenWidth * 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, size: 36, color: black),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    onPressed: onPressed,
                    icon: Icon(Icons.history, color: black),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
