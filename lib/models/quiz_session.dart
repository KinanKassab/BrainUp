import 'settings_model.dart';
import 'question.dart';

/// نموذج بيانات جلسة الاختبار
class QuizSession {
  final SettingsModel settings;
  final List<Question> questions;
  final int currentIndex;
  final int correctCount;
  final DateTime startedAt;
  final List<int> userAnswers; // إجابات المستخدم
  final bool isCompleted;

  const QuizSession({
    required this.settings,
    required this.questions,
    this.currentIndex = 0,
    this.correctCount = 0,
    required this.startedAt,
    this.userAnswers = const [],
    this.isCompleted = false,
  });

  /// إنشاء نسخة جديدة من الجلسة مع تعديلات
  QuizSession copyWith({
    SettingsModel? settings,
    List<Question>? questions,
    int? currentIndex,
    int? correctCount,
    DateTime? startedAt,
    List<int>? userAnswers,
    bool? isCompleted,
  }) {
    return QuizSession(
      settings: settings ?? this.settings,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      startedAt: startedAt ?? this.startedAt,
      userAnswers: userAnswers ?? this.userAnswers,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// الحصول على السؤال الحالي
  Question? get currentQuestion {
    if (currentIndex >= 0 && currentIndex < questions.length) {
      return questions[currentIndex];
    }
    return null;
  }

  /// التحقق من وجود سؤال تالي
  bool get hasNextQuestion => currentIndex < questions.length - 1;

  /// التحقق من وجود سؤال سابق
  bool get hasPreviousQuestion => currentIndex > 0;

  /// حساب النسبة المئوية للنتيجة
  double get scorePercentage {
    if (questions.isEmpty) return 0.0;
    return (correctCount / questions.length) * 100;
  }

  /// الحصول على إجمالي الوقت المستغرق
  Duration get totalTime => DateTime.now().difference(startedAt);

  /// إضافة إجابة المستخدم
  QuizSession addAnswer(int answerIndex) {
    final newAnswers = List<int>.from(userAnswers);
    
    // إذا كان المستخدم يجيب على السؤال الحالي لأول مرة
    if (currentIndex == userAnswers.length) {
      newAnswers.add(answerIndex);
      
      // التحقق من صحة الإجابة
      final question = currentQuestion;
      if (question != null && answerIndex == question.correctAnswerIndex) {
        return copyWith(
          userAnswers: newAnswers,
          correctCount: correctCount + 1,
        );
      }
    } else {
      // تعديل إجابة سابقة
      newAnswers[currentIndex] = answerIndex;
      
      // إعادة حساب النتيجة الصحيحة
      int newCorrectCount = 0;
      for (int i = 0; i < newAnswers.length; i++) {
        if (i < questions.length && 
            newAnswers[i] == questions[i].correctAnswerIndex) {
          newCorrectCount++;
        }
      }
      
      return copyWith(
        userAnswers: newAnswers,
        correctCount: newCorrectCount,
      );
    }
    
    return copyWith(userAnswers: newAnswers);
  }

  /// الانتقال للسؤال التالي
  QuizSession nextQuestion() {
    if (hasNextQuestion) {
      return copyWith(currentIndex: currentIndex + 1);
    }
    return this;
  }

  /// الانتقال للسؤال السابق
  QuizSession previousQuestion() {
    if (hasPreviousQuestion) {
      return copyWith(currentIndex: currentIndex - 1);
    }
    return this;
  }

  /// إنهاء الاختبار
  QuizSession complete() {
    return copyWith(isCompleted: true);
  }

  /// تحويل الجلسة إلى Map
  Map<String, dynamic> toJson() {
    return {
      'settings': settings.toJson(),
      'questions': questions.map((q) => q.toJson()).toList(),
      'currentIndex': currentIndex,
      'correctCount': correctCount,
      'startedAt': startedAt.toIso8601String(),
      'userAnswers': userAnswers,
      'isCompleted': isCompleted,
    };
  }

  /// إنشاء الجلسة من Map
  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      settings: SettingsModel.fromJson(json['settings']),
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
      currentIndex: json['currentIndex'] ?? 0,
      correctCount: json['correctCount'] ?? 0,
      startedAt: DateTime.parse(json['startedAt']),
      userAnswers: List<int>.from(json['userAnswers'] ?? []),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuizSession &&
        other.settings == settings &&
        other.questions.toString() == questions.toString() &&
        other.currentIndex == currentIndex &&
        other.correctCount == correctCount &&
        other.startedAt == startedAt &&
        other.userAnswers.toString() == userAnswers.toString() &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return Object.hash(
      settings,
      questions,
      currentIndex,
      correctCount,
      startedAt,
      userAnswers,
      isCompleted,
    );
  }
}
