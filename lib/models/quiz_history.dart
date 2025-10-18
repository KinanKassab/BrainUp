/// نموذج محفوظات نتائج الاختبارات
class QuizHistoryEntry {
  final DateTime completedAt;
  final String category;
  final String difficulty;
  final int score;
  final int total;
  final double percentage;
  final int durationSeconds;

  const QuizHistoryEntry({
    required this.completedAt,
    required this.category,
    required this.difficulty,
    required this.score,
    required this.total,
    required this.percentage,
    required this.durationSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'completedAt': completedAt.toIso8601String(),
      'category': category,
      'difficulty': difficulty,
      'score': score,
      'total': total,
      'percentage': percentage,
      'durationSeconds': durationSeconds,
    };
  }

  factory QuizHistoryEntry.fromJson(Map<String, dynamic> json) {
    return QuizHistoryEntry(
      completedAt: DateTime.parse(json['completedAt'] as String),
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      score: json['score'] as int,
      total: json['total'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      durationSeconds: json['durationSeconds'] as int,
    );
  }
}
