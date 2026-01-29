import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tekachigeojit/models/QuestionModel.dart';
import 'package:tekachigeojit/test/QuizResult.dart';

Future<List<QuestionModel>> loadQuestions() async {
  final String jsonString = await rootBundle.loadString(
    'assets/AptitudeQsns.json',
  );

  final List<dynamic> jsonData = jsonDecode(jsonString);
  return jsonData.map((e) => QuestionModel.fromJson(e)).toList();
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int? _selectedOptionIndex;
  int totalScore = 0;
  int totalQsns = 0;
  late Future<List<QuestionModel>> questionsFuture;
  late List<QuestionModel> questions;
  late QuestionModel currentQuestion;

  @override
  void initState() {
    super.initState();
    questionsFuture = loadQuestions().then((loadedQuestions) {
      questions = loadedQuestions;
      _loadRandomQuestion();
      return loadedQuestions;
    });
  }

  void _loadRandomQuestion() {
    setState(() {
      int randomIndex = Random().nextInt(20);
      currentQuestion = questions[randomIndex];
      _selectedOptionIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: FutureBuilder<List<QuestionModel>>(
        future: questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentQuestion.questionText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion.options.length,
                    itemBuilder: (context, optionIndex) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: RadioListTile<int>(
                            value: optionIndex,
                            groupValue: _selectedOptionIndex,
                            onChanged: (val) {
                              debugPrint('Selected option index: $val');
                              debugPrint(
                                'Selected option text: ${currentQuestion.options[val!]}',
                              );
                              setState(() => _selectedOptionIndex = val);
                            },
                            title: Text(
                              currentQuestion.options[optionIndex],
                              style: const TextStyle(fontFamily: 'Trebuchet'),
                            ),
                            activeColor: const Color(0xFF8DD300),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _selectedOptionIndex != null
                      ? () => _handleNext(currentQuestion)
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: const Color(0xFF8DD300),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'DelaGothicOne',
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleNext(QuestionModel question) {
    if (_selectedOptionIndex == null) {
      return;
    }

    if (question.correctAnswerIndex == _selectedOptionIndex) {
      totalScore++;
    }
    totalQsns++;

    if (totalQsns <= 15) {
      debugPrint('Score: $totalScore / $totalQsns');
      _loadRandomQuestion();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuizResult(score: totalScore, totalQuestions: totalQsns),
        ),
      );
    }
  }
}
