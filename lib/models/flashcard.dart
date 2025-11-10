class Flashcard {
  int? id;
  String question;
  List<String> options;
  int correctAnswerIndex;
  String explanation;

  Flashcard({
    this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options.join('|||'),
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      question: map['question'],
      options: (map['options'] as String).split('|||'),
      correctAnswerIndex: map['correctAnswerIndex'],
      explanation: map['explanation'],
    );
  }
}