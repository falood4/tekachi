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
    final theme = Theme.of(context);

    dynamic black = theme.colorScheme.onPrimary;
    dynamic primary = theme.colorScheme.primary;
    dynamic secondary = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Quiz', style: theme.textTheme.headlineLarge),
        backgroundColor: Colors.white,
      ),
      body: isLoading || currentQuestion == null
          ? SafeArea(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(secondary),
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
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),

                    //Options
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
                                style: theme.textTheme.bodyMedium,
                              ),
                              activeColor: secondary,
                              fillColor: WidgetStateProperty.resolveWith((
                                states,
                              ) {
                                if (states.contains(WidgetState.selected)) {
                                  return secondary;
                                }
                                return black;
                              }),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    //Next Button
                    Container(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: _selectedOptionId != null
                            ? () => _handleNext(currentQuestion!)
                            : null,
                        style: theme.elevatedButtonTheme.style,
                        child: Text(
                          'Next',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: secondary,
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
