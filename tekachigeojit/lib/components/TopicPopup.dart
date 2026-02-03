import 'dart:ui';
import 'package:flutter/material.dart';

class TopicPopup extends StatelessWidget {
  final String topicTitle;
  final Map<String, String> topicContents;

  const TopicPopup({
    super.key,
    required this.topicTitle,
    required this.topicContents,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.8,
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                topicTitle,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.06,
                  fontFamily: "DelaGothicOne",
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Text(
                      topicContents[topicTitle] ?? 'Content not available',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: "Trebuchet",
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8DD300),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.02,
                  ),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.04,
                    fontFamily: "DelaGothicOne",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
