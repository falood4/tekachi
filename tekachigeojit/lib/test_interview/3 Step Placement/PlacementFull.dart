import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/Widgets/NavBar.dart';
import 'package:tekachigeojit/test_interview/Aptitude%20Quiz/QuizPage.dart';

class PlacementFull extends StatelessWidget {
  const PlacementFull({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    final Color bg = theme.colorScheme.background;
    final Color lime = theme.colorScheme.secondary;

    return Scaffold(
      bottomNavigationBar: const NavBar(selectedPage: 0),
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        iconTheme: IconThemeData(color: lime),
        title: Text(
          '3 Step Placement Test',
          style: theme.textTheme.titleLarge?.copyWith(color: lime),
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
                  'This 3 step placement simulation will evaluate your aptitude, technical skills, and professional readiness to prepare you for real-world job placements. It includes an aptitude test, a technical interview, and an HR interview to comprehensively assess your abilities and readiness for the job market.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontFamily: "Trebuchet",
                    fontSize: 0.05 * screenWidth,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    width: screenWidth * 0.45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => QuizPage(is3step: true),
                          ),
                        );
                      },
                      style: theme.elevatedButtonTheme.style?.copyWith(
                        backgroundColor: WidgetStatePropertyAll(lime),
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
