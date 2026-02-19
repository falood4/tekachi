import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/models/AnswerSelection.dart';
import 'package:tekachigeojit/services/HistoryService.dart';
import 'package:tekachigeojit/services/AuthService.dart';

class QuizResult extends StatefulWidget {
  final int score;
  final List<AnswerSelection> answers;

  const QuizResult({super.key, required this.score, required this.answers});

  @override
  State<QuizResult> createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResult> {
  bool _attemptSaved = false;

  @override
  void initState() {
    super.initState();
    _persistAttemptAndAnswers();
  }

  Future<void> _persistAttemptAndAnswers() async {
    final userId = AuthService().shareUserId();
    if (userId == null) {
      debugPrint('No user id available, skipping save.');
      return;
    }

    try {
      final response = await HistoryService().saveAttempt(userId, widget.score);
      if (response.statusCode != 201) {
        debugPrint(
          'Attempt save failed ${response.statusCode}: ${response.body}',
        );
        return;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final int attemptId = decoded['attempt_id'] as int;

      for (final answer in widget.answers) {
        await HistoryService().saveAnswer(
          attemptId: attemptId,
          questionId: answer.questionId,
          selectedOptionId: answer.selectedOptionId,
        );
      }

      setState(() => _attemptSaved = true);
      debugPrint(
        'Attempt $attemptId saved with ${widget.answers.length} answers',
      );
    } catch (e) {
      debugPrint('Failed to persist attempt/answers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                    value: widget.score / 15,
                    strokeWidth: screenWidth * 0.075,
                    backgroundColor: const Color.fromARGB(255, 51, 51, 51),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF8DD300),
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '${widget.score}/15',
                  style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontFamily: "DelaGothicOne",
                    color: Colors.white,
                  ),
                ),
                scoreRemark(widget.score, screenWidth * 0.05),
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
                if (!_attemptSaved)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Saving result...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: "Trebuchet",
                        fontSize: screenWidth * 0.035,
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

  int index = 1;
  Widget _answerReviewCard(AnswerSelection answer) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            answer.questionText,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Trebuchet",
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Your Answer: ${answer.selectedOptionText}',
            style: const TextStyle(
              color: Color.fromARGB(255, 248, 108, 98),
              fontFamily: "Trebuchet",
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Correct Answer: ${answer.correctOptionText}',
            style: const TextStyle(
              color: Color(0xFF8DD300),
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

    final wrongAnswers = widget.answers
        .where((element) => !element.isCorrect)
        .toList();

    if (wrongAnswers.isEmpty) {
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
                itemCount: wrongAnswers.length,
                itemBuilder: (context, index) {
                  return _answerReviewCard(wrongAnswers[index]);
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
