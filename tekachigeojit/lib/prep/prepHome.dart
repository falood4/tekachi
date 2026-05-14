import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/ChatPages/InterviewHistory.dart';
import 'package:tekachigeojit/prep/HRQuestions.dart';
import 'package:tekachigeojit/prep/Techincal%20Training/TechnicalHome.dart';
import 'package:tekachigeojit/services/ChatService.dart';
import 'package:tekachigeojit/components/ChatPages/ChatInterview.dart';
import './Aptitude Training/AptitudeHome.dart';
import 'package:tekachigeojit/components/Widgets/NavBar.dart';

class PrepHome extends StatelessWidget {
  const PrepHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: const NavBar(selectedPage: 1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Prepare',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: screenWidth * 0.125,
                  fontFamily: 'ElmsSansBold',
                  fontWeight: FontWeight.w100,
                  color: theme.colorScheme.secondary,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TrainingCard(
                    title: 'HR Training',
                    icon: Icons.groups_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HrTrainingScreen()),
                    ),
                  ),
                  TrainingCard(
                    title: 'Mentor Archive',
                    icon: Icons.history_rounded,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            InterviewHistory(personaId: 1, title: "Mentor"),
                      ),
                    ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: theme.colorScheme.secondary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI Mentor',
                          style: TextStyle(
                            fontFamily: 'DelaGothicOne',
                            fontSize: 32,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Try out AI powered mentor\nto resolve any doubts',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Loading chat...',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Color(0xFF0047AB),
                              ),
                            ),
                            backgroundColor: const Color(0xFFEAEAEA),
                            duration: Duration(seconds: 10),
                          ),
                        );
                        try {
                          final String reply = await Chatservice()
                              .startConversation(1);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatInterview(
                                initialMessage: reply,
                                personaId: 1,
                                is3step: false,
                              ),
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFFEAEAEA),
                              content: Text(
                                'Could not start the interview. Please try again.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Color(0xFF0047AB),
                                ),
                              ),
                            ),
                          );
                        }
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

    return Container(
      height: screenWidth * 0.4,
      width: screenWidth * 0.4,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.tertiary,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: screenWidth * 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 56,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'ElmsSansBold',
                    color: Colors.black87,
                  ),
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
