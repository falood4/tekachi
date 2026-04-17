import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/services/ChatService.dart';
import 'package:tekachigeojit/components/ChatInterview.dart';

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
                  'Hello. I’m an HR Manager, and I’ll be conducting your HR interview today. \n\n My goal is to understand your professional background, soft skills, and cultural fit with our organization. We’ll discuss your experience, career goals, and how you handle workplace challenges. This is a two-way conversation where you can also learn about our company and the role.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: primary,
                    fontSize: 18,
                  ),
                ),

                Image(
                  image: Image.asset('assets/interview_avatar/hr.png').image,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 18),
                    width: screenWidth * 0.45,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF8DD300),
                              content: Text(
                                'Loading interview...',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.black,
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
                              backgroundColor: const Color(0xFF8DD300),
                              content: Text(
                                'Could not start the interview. Please try again.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      style: theme.elevatedButtonTheme.style?.copyWith(
                        backgroundColor: WidgetStatePropertyAll(secondary),
                      ),
                      child: Text(
                        "Start",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: Colors.black,
                        ),
                      ),
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
