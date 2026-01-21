import 'package:flutter/material.dart';
import 'package:tekachigeojit/prep/prepHome.dart';

class TechnicalHome extends StatelessWidget {
  const TechnicalHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(  
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
        iconTheme: const IconThemeData(
          color: Color(0xFF8DD300),
        ),
        title: Text('Technical Training', style: TextStyle(color: const Color(0xFF8DD300),
                      fontFamily: "Trebuchet",
                      fontSize: 0.075 * screenWidth),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrepHome(),),
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
                _trainingMenuItem(context, "Object Oriented Programming"),
                _trainingMenuItem(context, "Data Structures"),
                _trainingMenuItem(context, "Database Management"),
                _trainingMenuItem(context, "Operating Systems")
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _trainingMenuItem(BuildContext context, String title) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth*0.015),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD9D9D9),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenWidth *  0.05),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth*0.05,
                fontFamily: "Trebuchet"
              ),
            ),
          ),
        ),
      ),
    );
  }
}


