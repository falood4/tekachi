import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tekachigeojit/models/QuestionModel.dart';
import 'package:tekachigeojit/models/AnswerSelection.dart';
import 'package:tekachigeojit/test/Aptitude%20Quiz/QuizResult.dart';
import 'package:tekachigeojit/services/QsnService.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int? _selectedOptionId;
  int totalScore = 0;
  int totalQsns = 0;
  List<int> indices = List.generate(40, (index) => index + 1);
  final List<AnswerSelection> _answers = <AnswerSelection>[];

  QuestionModel? currentQuestion;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRandomQuestion();
  }

  void _loadRandomQuestion() async {
    setState(() => isLoading = true);
    try {
      final rand = Random();
      final pickIndex = rand.nextInt(indices.length);
      final randomIndex = indices[pickIndex];
      indices.removeAt(pickIndex);

      final questionData = await QsnService().getQuestion(randomIndex);
      setState(() {
        currentQuestion = questionData;
        _selectedOptionId = null;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading question: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading question: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz',
          style: TextStyle(
            color: const Color(0xFF8DD300),
            fontFamily: "DelaGothicOne",
            fontSize: 0.08 * screenWidth,
          ),
        ),
      ),
      body: isLoading || currentQuestion == null
          ? SafeArea(
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8DD300)),
                ),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentQuestion!.questionText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentQuestion!.options.length,
                        itemBuilder: (context, optionIndex) {
                          final option = currentQuestion!.options[optionIndex];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: RadioListTile<int>(
                              value: option.id,
                              groupValue: _selectedOptionId,
                              onChanged: (val) {
                                final selected = currentQuestion!.options
                                    .firstWhere((element) => element.id == val);
                                debugPrint('Selected option id: $val');
                                debugPrint(
                                  'Selected option text: ${selected.text}',
                                );
                                setState(() {
                                  _selectedOptionId = val;
                                });
                              },
                              title: Text(
                                option.text,
                                style: const TextStyle(fontFamily: 'Trebuchet'),
                              ),
                              activeColor: const Color(0xFF8DD300),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: _selectedOptionId != null
                            ? () => _handleNext(currentQuestion!)
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
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _handleNext(QuestionModel question) {
    if (_selectedOptionId == null) {
      return;
    }

    final selectedOption = question.options.firstWhere(
      (option) => option.id == _selectedOptionId,
    );
    final correctOption = question.options.firstWhere(
      (option) => option.id == question.correctOptionId,
    );

    final bool isCorrect = selectedOption.id == question.correctOptionId;
    if (isCorrect) {
      totalScore++;
    }
    totalQsns++;

    _answers.add(
      AnswerSelection(
        questionId: question.questionId,
        questionText: question.questionText,
        selectedOptionId: selectedOption.id,
        selectedOptionText: selectedOption.text,
        correctOptionId: correctOption.id,
        correctOptionText: correctOption.text,
        isCorrect: isCorrect,
      ),
    );

    if (totalQsns < 15) {
      debugPrint('Score: $totalScore / 15');
      _loadRandomQuestion();
    } else {
      indices = List.generate(40, (index) => index + 1);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuizResult(score: totalScore, answers: _answers),
        ),
      );
    }
  }
}
