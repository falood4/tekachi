import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/HRQuestions.dart';
import 'package:tekachigeojit/prep/Techincal%20Training/TechnicalHome.dart';
import './Aptitude Training/AptitudeHome.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class PrepHome extends StatelessWidget {
  const PrepHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    dynamic black = theme.colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
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
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: screenWidth * 0.15,
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
                height: screenHeight * 0.2,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: theme.colorScheme.secondary,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'AI Mentor',
                      style: TextStyle(
                        color: black,
                        fontFamily: 'Rostex',
                        fontSize: screenWidth * 0.09,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Personalized interview practice',
                      style: TextStyle(color: black),
                    ),

                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: theme.elevatedButtonTheme.style,
                      child: Text(
                        'Start',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 22,
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
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: screenWidth * 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
