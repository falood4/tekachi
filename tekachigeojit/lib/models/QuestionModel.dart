class QuestionModel {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final int correctOptionId;

  QuestionModel({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.correctOptionId,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      correctOptionId: json['correctOptionId'],
    );
  }
}
