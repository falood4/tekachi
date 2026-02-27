import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/Techincal%20Training/DBMS.dart';
import 'package:tekachigeojit/prep/Techincal%20Training/DStopics.dart';
import 'package:tekachigeojit/prep/Techincal%20Training/OOPtopics.dart';
import 'package:tekachigeojit/prep/Techincal%20Training/OStopics.dart';
import 'package:tekachigeojit/prep/prepHome.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class TechnicalHome extends StatelessWidget {
  const TechnicalHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);
    final blackbg = theme.colorScheme.background;
    final lime = theme.colorScheme.secondary;
    final surface = theme.colorScheme.surface;

    return Scaffold(
      backgroundColor: blackbg,
      bottomNavigationBar: NavBar(),
      appBar: AppBar(
        backgroundColor: blackbg,
        iconTheme: IconThemeData(color: lime),
        title: Text(
          'Technical Training',
          style: theme.textTheme.titleLarge?.copyWith(color: lime),
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
                  "Object Oriented Programming",
                  () => _loadOOP(context),
                ),
                _trainingMenuItem(
                  context,
                  "Data Structures",
                  () => _loadDS(context),
                ),
                _trainingMenuItem(
                  context,
                  "Database Management",
                  () => _loadDBMS(context),
                ),
                _trainingMenuItem(
                  context,
                  "Operating Systems",
                  () => _loadOS(context),
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
    Function()? onPressed,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;

    return Container(
      height: screenWidth * 0.25,
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
        ),
      ),
    );
  }

  void _loadDBMS(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => DBMS()));
  }

  void _loadDS(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => DStopics()));
  }

  void _loadOOP(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => OOPtopics()));
  }

  void _loadOS(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => OStopics()));
  }
}
