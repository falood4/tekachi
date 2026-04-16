import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/services/FullTestService.dart';
import 'package:tekachigeojit/test/testHome.dart';

class PlacementResult extends StatelessWidget {
  const PlacementResult({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    final Color background = theme.colorScheme.background;
    final Color secondary = theme.colorScheme.secondary;
    final Color primary = theme.colorScheme.primary;

    final service = FullTestService();
    final int aptitudeScore = service.getAptitudeScore();
    final String technicalVerdict = service.getTechnicalVerdict();
    final String hrVerdict = service.getHRVerdict();

    final bool isPassed = technicalVerdict == 'HIRED' && hrVerdict == 'HIRED';

    return Scaffold(
      bottomNavigationBar: const NavBar(selectedPage: 0),
      backgroundColor: background,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(screenWidth * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text('Placement Results', style: theme.textTheme.headlineLarge),

              SizedBox(height: screenHeight * 0.04),

              Container(
                width: screenWidth * 0.35,
                height: screenWidth * 0.35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPassed
                      ? Colors.green.withOpacity(0.15)
                      : Colors.red.withOpacity(0.15),
                  border: Border.all(
                    color: isPassed ? Colors.green : Colors.red,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Icon(
                    isPassed ? Icons.check_circle : Icons.cancel,
                    size: screenWidth * 0.15,
                    color: isPassed ? Colors.green : Colors.red,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              Text(
                isPassed ? 'PLACED!' : 'NOT PLACED',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: isPassed ? Colors.green : Colors.red,
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RussoOne',
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              Container(
                height: screenHeight * 0.3,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: secondary, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Aptitude Score
                    _buildScoreRow(
                      'Aptitude Test',
                      '$aptitudeScore/15',
                      aptitudeScore >= 8 ? Colors.green : Colors.orange,
                      screenWidth,
                      primary,
                    ),
                    // Technical Interview
                    _buildScoreRow(
                      'Technical Interview',
                      technicalVerdict,
                      technicalVerdict == 'HIRED' ? Colors.green : Colors.red,
                      screenWidth,
                      primary,
                    ),
                    // HR Interview
                    _buildScoreRow(
                      'HR Interview',
                      hrVerdict,
                      hrVerdict == 'HIRED' ? Colors.green : Colors.red,
                      screenWidth,
                      primary,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  FullTestService().saveAttempt();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const TestHome()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.04,
                    horizontal: screenWidth * 0.15,
                  ),
                  backgroundColor: secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'Done',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.black,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRow(
    String title,
    String value,
    Color valueColor,
    double screenWidth,
    Color titleColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: screenWidth * 0.045,
              fontFamily: 'Trebuchet',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenWidth * 0.02,
          ),
          decoration: BoxDecoration(
            color: valueColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: valueColor.withOpacity(0.5), width: 1.5),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              fontFamily: 'RussoOne',
            ),
          ),
        ),
      ],
    );
  }
}
