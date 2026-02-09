import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/services/HistoryService.dart';
import 'package:tekachigeojit/services/AuthService.dart';

class QuizResult extends StatelessWidget {
  final int score;
  final Map<String, (String, String)> reviewAnswers;

  const QuizResult({
    super.key,
    required this.score,
    required this.reviewAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    int? user_id = AuthService().shareUserId();
    HistoryService().saveAttempt(user_id!, score);

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(screenWidth * 0.1),
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.075),
                  width: screenWidth * 0.6,
                  height: screenWidth * 0.6,
                  child: CircularProgressIndicator(
                    value: score / 15,
                    strokeWidth: screenWidth * 0.075,
                    backgroundColor: const Color.fromARGB(255, 51, 51, 51),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF8DD300),
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '$score/15',
                  style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontFamily: "DelaGothicOne",
                    color: Colors.white,
                  ),
                ),
                scoreRemark(score, screenWidth * 0.05),
                SizedBox(height: screenWidth * 0.05),
                ElevatedButton(
                  onPressed: () => startReview(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    backgroundColor: const Color(0xFF8DD300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Review Answers',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.05,
                      fontFamily: "DelaGothicOne",
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

  Widget _answerReviewCard(String questionText, (String, String) answers) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionText,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Trebuchet",
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Your Answer: ${answers.$1}',
            style: TextStyle(
              color: const Color.fromARGB(255, 248, 108, 98),
              fontFamily: "Trebuchet",
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Correct Answer: ${answers.$2}',
            style: TextStyle(
              color: const Color.fromARGB(255, 113, 254, 118),
              fontFamily: "Trebuchet",
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void startReview(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (reviewAnswers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No answers to review.')));
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF8DD300),
              width: screenWidth * 0.01,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(screenWidth * 0.1),
              topRight: Radius.circular(screenWidth * 0.1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: screenHeight * 0.8,
              child: ListView.builder(
                itemCount: reviewAnswers.length,
                itemBuilder: (context, index) {
                  final entry = reviewAnswers.entries.elementAt(index);
                  return _answerReviewCard(entry.key, entry.value);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Text scoreRemark(int score, double fontSize) {
    if (score > 12) {
      return Text(
        'Excellent',
        style: TextStyle(
          color: Colors.white,
          fontFamily: "DelaGothicOne",
          fontSize: fontSize,
        ),
      );
    } else if (score > 7) {
      return Text(
        "Good",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "DelaGothicOne",
          fontSize: fontSize,
        ),
      );
    } else {
      return Text(
        "Needs Improvement",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "DelaGothicOne",
          fontSize: fontSize,
        ),
      );
    }
  }
}
