import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/services/ChatService.dart';
import 'package:tekachigeojit/components/ChatInterview.dart';

class Techinterviewintro extends StatelessWidget {
  const Techinterviewintro({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    final Color bg = theme.colorScheme.background;
    final Color primary = theme.colorScheme.primary;
    final Color secondary = theme.colorScheme.secondary;

    return Scaffold(
      bottomNavigationBar: NavBar(),
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        iconTheme: IconThemeData(color: secondary),
        title: Text(
          'Technical Interview',
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
                  'Hello. I’m a Tech Lead, and I’ll be conducting your technical interview today. \n\n My goal is to explore your technical foundation and see how you approach complex problems. We’ll dive into some core computer science concepts—specifically DSA, DBMS, and Operating Systems—and then move into a live coding exercise to see your logic in action.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: primary,
                    fontSize: 18,
                  ),
                ),

                Image(
                  image: Image.asset('assets/interview_avatar/tech.png').image,
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
                              content: Text(
                                'Loading interview...',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Color(0xFF8DD300),
                                ),
                              ),
                              duration: const Duration(seconds: 4),
                            ),
                          );
                          final String reply = await Chatservice()
                              .startConversation(2);
                          if (!context.mounted) {
                            return;
                          }
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => ChatInterview(
                                initialMessage: reply,
                                personaId: 2,
                              ),
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xFF141414),
                              content: Text(
                                'Failed to start interview',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Color(0xFF8DD300),
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
