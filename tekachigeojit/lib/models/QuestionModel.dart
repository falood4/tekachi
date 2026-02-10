class OptionModel {
  final int id;
  final String text;

  OptionModel({required this.id, required this.text});

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(id: json['opId'] as int, text: json['op'] as String);
  }
}

class QuestionModel {
  final int questionId;
  final String questionText;
  final List<OptionModel> options;
  final int correctOptionId;

  QuestionModel({
    required this.questionId,
    required this.questionText,
    required this.options,
    required this.correctOptionId,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionId: json['qId'] as int,
      questionText: json['questionText'] as String,
      options: (json['options'] as List<dynamic>)
          .map((opt) => OptionModel.fromJson(opt as Map<String, dynamic>))
          .toList(),
      correctOptionId: json['correctOptionId'] as int,
    );
  }
}
