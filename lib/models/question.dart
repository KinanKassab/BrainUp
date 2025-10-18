/// نموذج بيانات السؤال
class Question {
  final String id;
  final String text;
  final String? imageUrl;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final String category;
  final String difficulty;

  const Question({
    required this.id,
    required this.text,
    this.imageUrl,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    required this.category,
    required this.difficulty,
  });

  /// تحويل السؤال إلى Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'category': category,
      'difficulty': difficulty,
    };
  }

  /// إنشاء السؤال من Map
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
      category: json['category'],
      difficulty: json['difficulty'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Question &&
        other.id == id &&
        other.text == text &&
        other.imageUrl == imageUrl &&
        other.options.toString() == options.toString() &&
        other.correctAnswerIndex == correctAnswerIndex &&
        other.explanation == explanation &&
        other.category == category &&
        other.difficulty == difficulty;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      text,
      imageUrl,
      options,
      correctAnswerIndex,
      explanation,
      category,
      difficulty,
    );
  }
}
