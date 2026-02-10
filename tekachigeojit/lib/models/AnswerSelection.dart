class AnswerSelection {
  final int questionId;
  final String questionText;
  final int selectedOptionId;
  final String selectedOptionText;
  final int correctOptionId;
  final String correctOptionText;
  final bool isCorrect;

  AnswerSelection({
    required this.questionId,
    required this.questionText,
    required this.selectedOptionId,
    required this.selectedOptionText,
    required this.correctOptionId,
    required this.correctOptionText,
    required this.isCorrect,
  });
}
