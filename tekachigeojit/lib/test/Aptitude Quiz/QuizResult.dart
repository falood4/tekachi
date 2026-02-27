import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';
import 'package:tekachigeojit/models/AnswerSelection.dart';
import 'package:tekachigeojit/services/HistoryService.dart';
import 'package:tekachigeojit/services/AuthService.dart';
import 'package:tekachigeojit/test/testHome.dart';

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

    final theme = Theme.of(context);
    final white = theme.colorScheme.primary;
    final lime = theme.colorScheme.secondary;
    final blackbg = theme.colorScheme.background;
    final surface = theme.colorScheme.surface;

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      backgroundColor: blackbg,
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
                    valueColor: AlwaysStoppedAnimation<Color>(lime),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '${widget.score}/15',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: white,
                    fontSize: screenWidth * 0.1,
                  ),
                ),
                scoreRemark(widget.score, screenWidth * 0.05),
                SizedBox(height: screenWidth * 0.05),
                ElevatedButton(
                  onPressed: () => startReview(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    backgroundColor: lime,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Review Answers',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: blackbg,
                      fontSize: screenWidth * 0.06,
                    ),
                  ),
                ),
                if (!_attemptSaved)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Saving result...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: surface,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                SizedBox(height: screenWidth * 0.03),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const TestHome()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    backgroundColor: surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Return to Tests',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: blackbg,
                      fontSize: screenWidth * 0.04,
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

  Widget _answerReviewCard(AnswerSelection answer, int index) {
    final theme = Theme.of(context);
    dynamic white = theme.colorScheme.primary;
    dynamic lime = theme.colorScheme.secondary;
    dynamic red = theme.colorScheme.error;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index + 1}. ${answer.questionText}",
            style: theme.textTheme.bodyMedium?.copyWith(color: white),
          ),
          const SizedBox(height: 5),
          Text(
            'Your Answer: ${answer.selectedOptionText}',
            style: theme.textTheme.bodySmall?.copyWith(color: red),
          ),
          const SizedBox(height: 5),
          Text(
            'Correct Answer: ${answer.correctOptionText}',
            style: theme.textTheme.bodySmall?.copyWith(color: lime),
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
      backgroundColor: Theme.of(context).colorScheme.background,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
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
                  return _answerReviewCard(wrongAnswers[index], index);
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
          color: Theme.of(context).colorScheme.primary,
          fontFamily: "DelaGothicOne",
          fontSize: fontSize,
        ),
      );
    } else if (score > 7) {
      return Text(
        "Good",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: "DelaGothicOne",
          fontSize: fontSize,
        ),
      );
    } else {
      return Text(
        "Needs Improvement",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: "DelaGothicOne",
          fontSize: fontSize,
        ),
      );
    }
  }
}
