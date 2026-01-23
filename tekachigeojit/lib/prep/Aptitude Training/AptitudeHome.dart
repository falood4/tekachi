import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/Aptitude%20Training/DataInterpretation.dart';
import 'package:tekachigeojit/prep/Aptitude%20Training/LogicalReasoning.dart';
import 'package:tekachigeojit/prep/Aptitude%20Training/VerbalReasoning.dart';
import 'package:tekachigeojit/prep/prepHome.dart';
import 'ArithmeticAptitude.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class AptitudeHome extends StatelessWidget {
  const AptitudeHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      bottomNavigationBar: NavBar(),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
        iconTheme: const IconThemeData(color: Color(0xFF8DD300)),
        title: Text(
          'Aptitude Training',
          style: TextStyle(
            color: const Color(0xFF8DD300),
            fontFamily: "Trebuchet",
            fontSize: 0.075 * screenWidth,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrepHome()),
            );
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
                _trainingMenuItem(context, "Arithmetic Aptitude", () => _loadArithmetic(context)),
                _trainingMenuItem(context, "Data Interpretation", () => _loadDataInterpretation(context)),
                _trainingMenuItem(context, "Verbal Reasoning", () => _loadVerbalReasoning(context)),
                _trainingMenuItem(context, "Logical Reasoning", () => _loadLogicalReasoning(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _trainingMenuItem(BuildContext context, String title, Function()? onPressed) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD9D9D9),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.05,
                fontFamily: "Trebuchet",
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loadArithmetic(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => ArithmeticAptitude()));
  }

  void _loadDataInterpretation(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => DataInterpretation()));
  }

  void _loadVerbalReasoning(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => VerbalReasoning()));
  }
  
  void _loadLogicalReasoning(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => LogicalReasoning()));
  }


}
