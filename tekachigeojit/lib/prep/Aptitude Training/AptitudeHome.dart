import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/Aptitude%20Training/DataInterpretation.dart';
import 'package:tekachigeojit/prep/Aptitude%20Training/LogicalReasoning.dart';
import 'package:tekachigeojit/prep/Aptitude%20Training/VerbalReasoning.dart';
import 'package:tekachigeojit/prep/prepHome.dart';
import 'ArithmeticAptitude.dart';
import 'package:tekachigeojit/components/Widgets/NavBar.dart';

class AptitudeHome extends StatelessWidget {
  const AptitudeHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: NavBar(),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        iconTheme: IconThemeData(color: theme.colorScheme.secondary),
        title: Text(
          'Aptitude Training',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PrepHome()),
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenWidth * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _trainingMenuItem(
                  context,
                  "Arithmetic Aptitude",
                  Icons.calculate_rounded,
                  () => _loadArithmetic(context),
                ),
                _trainingMenuItem(
                  context,
                  "Data Interpretation",
                  Icons.bar_chart_rounded,
                  () => _loadDataInterpretation(context),
                ),
                _trainingMenuItem(
                  context,
                  "Verbal Reasoning",
                  Icons.chat_bubble_outline_rounded,
                  () => _loadVerbalReasoning(context),
                ),
                _trainingMenuItem(
                  context,
                  "Logical Reasoning",
                  Icons.psychology_alt_rounded,
                  () => _loadLogicalReasoning(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _trainingMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    Function()? onPressed,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Container(
      height: screenWidth * 0.25,
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surfaceDim,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadArithmetic(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ArithmeticAptitude()));
  }

  void _loadDataInterpretation(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => DataInterpretation()));
  }

  void _loadVerbalReasoning(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => VerbalReasoning()));
  }

  void _loadLogicalReasoning(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => LogicalReasoning()));
  }
}
