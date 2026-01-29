import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class QuizResult extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const QuizResult({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: NavBar(),
      backgroundColor: Color.fromRGBO(20, 20, 20, 1.0),
    );
  }
}
