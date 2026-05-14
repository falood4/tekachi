import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/Widgets/NavBar.dart';
import 'package:tekachigeojit/services/ChatService.dart';
import 'package:tekachigeojit/components/ChatPages/ChatInterview.dart';
import 'package:tekachigeojit/components/ChatPages/InterviewHistory.dart';

class HRinterviewIntro extends StatelessWidget {
  const HRinterviewIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    final Color bg = theme.colorScheme.background;
    final Color primary = theme.colorScheme.primary;
    final Color secondary = theme.colorScheme.secondary;

    return Scaffold(
      bottomNavigationBar: const NavBar(selectedPage: 0),
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        iconTheme: IconThemeData(color: secondary),
        title: Text(
          'HR Interview',
          style: theme.textTheme.titleLarge?.copyWith(color: secondary),
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
                  'An HR interview aims to understand your professional background, soft skills, and cultural fit within an organization. Discuss your experience, career goals, and how you handle workplace challenges. This is a two-way conversation where you can also learn about our company and the role.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: primary,
                    fontSize: 18,
                  ),
                ),

                Image(
                  image: Image.asset('assets/interview_avatar/hr.png').image,
                ),

                SizedBox(height: screenHeight * 0.02),

                ElevatedButton(
                  onPressed: () async {
                    try {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFFEAEAEA),
                          content: Text(
                            'Loading interview...',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Color(0xFF0047AB),
                            ),
                          ),
                          duration: const Duration(seconds: 4),
                        ),
                      );
                      final String reply = await Chatservice()
                          .startConversation(3);
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => ChatInterview(
                            initialMessage: reply,
                            personaId: 3,
                            is3step: false,
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
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
                  style: theme.elevatedButtonTheme.style,
                  child: Text(
                    "Start",
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: 8),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            InterviewHistory(personaId: 3, title: "HR"),
                      ),
                    );
                  },
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                      theme.colorScheme.surfaceDim,
                    ),
                  ),
                  child: Text(
                    "Archive",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: secondary,
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
