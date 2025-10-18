import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/quiz_session.dart';
import '../models/question.dart';
import '../models/settings_model.dart';
import '../services/api_service.dart';

part 'quiz_provider.g.dart';

@riverpod
class QuizNotifier extends _$QuizNotifier {
  @override
  AsyncValue<QuizSession?> build() {
    return const AsyncValue.data(null);
  }

  /// بدء اختبار جديد
  Future<void> startQuiz(SettingsModel settings) async {
    state = const AsyncValue.loading();
    
    try {
      List<Question> questions;
      
      if (settings.useApiQuestions) {
        // جلب الأسئلة من API
        questions = await ApiService.fetchQuestions(
          amount: settings.apiQuestionCount,
          category: settings.category,
          difficulty: settings.difficulty,
        );
      } else {
        // استخدام الأسئلة المحلية
        questions = _generateMockQuestions(settings);
      }
      
      final session = QuizSession(
        settings: settings,
        questions: questions,
        startedAt: DateTime.now(),
      );
      
      state = AsyncValue.data(session);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// إضافة إجابة المستخدم
  void answerQuestion(int answerIndex) {
    state.whenData((session) {
      if (session != null) {
        state = AsyncValue.data(session.addAnswer(answerIndex));
      }
    });
  }

  /// الانتقال للسؤال التالي
  void nextQuestion() {
    state.whenData((session) {
      if (session != null) {
        state = AsyncValue.data(session.nextQuestion());
      }
    });
  }

  /// الانتقال للسؤال السابق
  void previousQuestion() {
    state.whenData((session) {
      if (session != null) {
        state = AsyncValue.data(session.previousQuestion());
      }
    });
  }

  /// إنهاء الاختبار
  void completeQuiz() {
    state.whenData((session) {
      if (session != null) {
        state = AsyncValue.data(session.complete());
      }
    });
  }

  /// إعادة تعيين الجلسة
  void resetQuiz() {
    state = const AsyncValue.data(null);
  }

  /// إعادة تشغيل الاختبار بنفس الإعدادات
  Future<void> restartQuiz() async {
    state.whenData((session) {
      if (session != null) {
        startQuiz(session.settings);
      }
    });
  }

  /// إنشاء أسئلة وهمية للاختبار
  List<Question> _generateMockQuestions(SettingsModel settings) {
    final List<Question> allQuestions = [
      // أسئلة عامة
      Question(
        id: '1',
        text: 'What is the capital of France?',
        options: ['London', 'Berlin', 'Paris', 'Madrid'],
        correctAnswerIndex: 2,
        explanation: 'Paris is the capital and largest city of France.',
        category: 'general',
        difficulty: 'easy',
      ),
      Question(
        id: '2',
        text: 'Which planet is known as the Red Planet?',
        options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        correctAnswerIndex: 1,
        explanation: 'Mars is called the Red Planet due to iron oxide on its surface.',
        category: 'science',
        difficulty: 'easy',
      ),
      Question(
        id: '3',
        text: 'Who painted the Mona Lisa?',
        options: ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo'],
        correctAnswerIndex: 2,
        explanation: 'Leonardo da Vinci painted the Mona Lisa between 1503-1519.',
        category: 'history',
        difficulty: 'medium',
      ),
      Question(
        id: '4',
        text: 'What is the largest mammal in the world?',
        options: ['African Elephant', 'Blue Whale', 'Giraffe', 'Hippopotamus'],
        correctAnswerIndex: 1,
        explanation: 'The blue whale is the largest mammal and animal on Earth.',
        category: 'science',
        difficulty: 'easy',
      ),
      Question(
        id: '5',
        text: 'In which year did World War II end?',
        options: ['1944', '1945', '1946', '1947'],
        correctAnswerIndex: 1,
        explanation: 'World War II ended in 1945 with the surrender of Japan.',
        category: 'history',
        difficulty: 'medium',
      ),
      Question(
        id: '6',
        text: 'What is the chemical symbol for gold?',
        options: ['Go', 'Gd', 'Au', 'Ag'],
        correctAnswerIndex: 2,
        explanation: 'Au is the chemical symbol for gold, from the Latin word "aurum".',
        category: 'science',
        difficulty: 'medium',
      ),
      Question(
        id: '7',
        text: 'Which country is known as the Land of the Rising Sun?',
        options: ['China', 'Japan', 'South Korea', 'Thailand'],
        correctAnswerIndex: 1,
        explanation: 'Japan is known as the Land of the Rising Sun.',
        category: 'general',
        difficulty: 'easy',
      ),
      Question(
        id: '8',
        text: 'What is the speed of light in vacuum?',
        options: ['299,792,458 m/s', '300,000,000 m/s', '299,000,000 m/s', '301,000,000 m/s'],
        correctAnswerIndex: 0,
        explanation: 'The speed of light in vacuum is exactly 299,792,458 meters per second.',
        category: 'science',
        difficulty: 'hard',
      ),
      Question(
        id: '9',
        text: 'Who wrote "Romeo and Juliet"?',
        options: ['Charles Dickens', 'William Shakespeare', 'Mark Twain', 'Jane Austen'],
        correctAnswerIndex: 1,
        explanation: 'William Shakespeare wrote the famous play "Romeo and Juliet".',
        category: 'literature',
        difficulty: 'medium',
      ),
      Question(
        id: '10',
        text: 'What is the smallest country in the world?',
        options: ['Monaco', 'Vatican City', 'Liechtenstein', 'San Marino'],
        correctAnswerIndex: 1,
        explanation: 'Vatican City is the smallest country in the world by area.',
        category: 'general',
        difficulty: 'medium',
      ),
    ];

    // تصفية الأسئلة حسب الفئة والصعوبة
    List<Question> filteredQuestions = allQuestions.where((question) {
      bool categoryMatch = settings.category == 'general' || 
                          question.category == settings.category;
      bool difficultyMatch = question.difficulty == settings.difficulty;
      return categoryMatch && difficultyMatch;
    }).toList();

    // إذا لم توجد أسئلة مطابقة، استخدم جميع الأسئلة
    if (filteredQuestions.isEmpty) {
      filteredQuestions = allQuestions;
    }

    // خلط الأسئلة إذا كان مطلوباً
    if (settings.shuffle) {
      filteredQuestions.shuffle();
    }

    // تحديد عدد الأسئلة المطلوب
    final numQuestions = settings.numQuestions.clamp(5, filteredQuestions.length);
    return filteredQuestions.take(numQuestions).toList();
  }
}