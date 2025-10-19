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
      // Super Mind - Level 0 (Basic Logic)
      Question(
        id: 'sm_0_1',
        text: 'What comes next in the sequence: 2, 4, 6, 8, ?',
        options: ['10', '9', '12', '7'],
        correctAnswerIndex: 0,
        explanation: 'This is an arithmetic sequence where each number increases by 2.',
        category: 'super_mind',
        difficulty: '0',
      ),
      Question(
        id: 'sm_0_2',
        text: 'If all roses are flowers and some flowers are red, which statement is true?',
        options: ['All roses are red', 'Some roses are red', 'No roses are red', 'Cannot be determined'],
        correctAnswerIndex: 3,
        explanation: 'We cannot determine if roses are red from the given information.',
        category: 'super_mind',
        difficulty: '0',
      ),
      Question(
        id: 'sm_0_3',
        text: 'What is the missing number: 1, 1, 2, 3, 5, ?',
        options: ['6', '7', '8', '9'],
        correctAnswerIndex: 2,
        explanation: 'This is the Fibonacci sequence where each number is the sum of the two preceding ones.',
        category: 'super_mind',
        difficulty: '0',
      ),

      // Super Mind - Level 1 (Pattern Recognition)
      Question(
        id: 'sm_1_1',
        text: 'What is the next shape in the pattern: Circle, Square, Triangle, Circle, ?',
        options: ['Square', 'Triangle', 'Circle', 'Rectangle'],
        correctAnswerIndex: 0,
        explanation: 'The pattern repeats every 3 shapes: Circle, Square, Triangle.',
        category: 'super_mind',
        difficulty: '1',
      ),
      Question(
        id: 'sm_1_2',
        text: 'If A=1, B=2, C=3, what is the value of CAT?',
        options: ['24', '25', '26', '27'],
        correctAnswerIndex: 0,
        explanation: 'C=3, A=1, T=20, so CAT = 3+1+20 = 24.',
        category: 'super_mind',
        difficulty: '1',
      ),

      // Super Mind - Level 2 (Advanced Logic)
      Question(
        id: 'sm_2_1',
        text: 'In a room with 3 light switches, only one controls a light bulb in another room. You can only check the bulb once. How do you determine which switch controls the bulb?',
        options: ['Turn on all switches', 'Turn on first switch for 5 minutes, then second', 'Turn on second switch only', 'Cannot be determined'],
        correctAnswerIndex: 1,
        explanation: 'Turn on the first switch for 5 minutes, then turn it off and turn on the second. The warm bulb indicates the first switch.',
        category: 'super_mind',
        difficulty: '2',
      ),

      // Amazing Fingers - Level 1 (Basic Arithmetic)
      Question(
        id: 'af_1_1',
        text: 'What is 7 + 8?',
        options: ['14', '15', '16', '13'],
        correctAnswerIndex: 1,
        explanation: '7 + 8 = 15',
        category: 'amazing_fingers',
        difficulty: '1',
      ),
      Question(
        id: 'af_1_2',
        text: 'What is 12 - 5?',
        options: ['6', '7', '8', '9'],
        correctAnswerIndex: 1,
        explanation: '12 - 5 = 7',
        category: 'amazing_fingers',
        difficulty: '1',
      ),
      Question(
        id: 'af_1_3',
        text: 'What is 3 × 4?',
        options: ['10', '11', '12', '13'],
        correctAnswerIndex: 2,
        explanation: '3 × 4 = 12',
        category: 'amazing_fingers',
        difficulty: '1',
      ),

      // Amazing Fingers - Level 2 (Intermediate Arithmetic)
      Question(
        id: 'af_2_1',
        text: 'What is 15 + 23?',
        options: ['37', '38', '39', '40'],
        correctAnswerIndex: 1,
        explanation: '15 + 23 = 38',
        category: 'amazing_fingers',
        difficulty: '2',
      ),
      Question(
        id: 'af_2_2',
        text: 'What is 48 ÷ 6?',
        options: ['7', '8', '9', '10'],
        correctAnswerIndex: 1,
        explanation: '48 ÷ 6 = 8',
        category: 'amazing_fingers',
        difficulty: '2',
      ),

      // Amazing Fingers - Level 3 (Advanced Arithmetic)
      Question(
        id: 'af_3_1',
        text: 'What is 127 + 89?',
        options: ['215', '216', '217', '218'],
        correctAnswerIndex: 1,
        explanation: '127 + 89 = 216',
        category: 'amazing_fingers',
        difficulty: '3',
      ),
      Question(
        id: 'af_3_2',
        text: 'What is 156 ÷ 12?',
        options: ['12', '13', '14', '15'],
        correctAnswerIndex: 1,
        explanation: '156 ÷ 12 = 13',
        category: 'amazing_fingers',
        difficulty: '3',
      ),

      // Mental Calculation - Level 0 (Basic Mental Math)
      Question(
        id: 'mc_0_1',
        text: 'What is 5 + 3 + 2?',
        options: ['9', '10', '11', '12'],
        correctAnswerIndex: 1,
        explanation: '5 + 3 + 2 = 10',
        category: 'mental_calculation',
        difficulty: '0',
      ),
      Question(
        id: 'mc_0_2',
        text: 'What is 20 - 7?',
        options: ['12', '13', '14', '15'],
        correctAnswerIndex: 1,
        explanation: '20 - 7 = 13',
        category: 'mental_calculation',
        difficulty: '0',
      ),

      // Mental Calculation - Level 1 (Simple Mental Math)
      Question(
        id: 'mc_1_1',
        text: 'What is 7 × 8?',
        options: ['54', '55', '56', '57'],
        correctAnswerIndex: 2,
        explanation: '7 × 8 = 56',
        category: 'mental_calculation',
        difficulty: '1',
      ),
      Question(
        id: 'mc_1_2',
        text: 'What is 63 ÷ 9?',
        options: ['6', '7', '8', '9'],
        correctAnswerIndex: 1,
        explanation: '63 ÷ 9 = 7',
        category: 'mental_calculation',
        difficulty: '1',
      ),

      // Mental Calculation - Level 2 (Intermediate Mental Math)
      Question(
        id: 'mc_2_1',
        text: 'What is 15 × 12?',
        options: ['170', '175', '180', '185'],
        correctAnswerIndex: 2,
        explanation: '15 × 12 = 180',
        category: 'mental_calculation',
        difficulty: '2',
      ),
      Question(
        id: 'mc_2_2',
        text: 'What is 144 ÷ 12?',
        options: ['11', '12', '13', '14'],
        correctAnswerIndex: 1,
        explanation: '144 ÷ 12 = 12',
        category: 'mental_calculation',
        difficulty: '2',
      ),

      // Mental Calculation - Level 3 (Advanced Mental Math)
      Question(
        id: 'mc_3_1',
        text: 'What is 25 × 16?',
        options: ['390', '400', '410', '420'],
        correctAnswerIndex: 1,
        explanation: '25 × 16 = 400',
        category: 'mental_calculation',
        difficulty: '3',
      ),
      Question(
        id: 'mc_3_2',
        text: 'What is 225 ÷ 15?',
        options: ['14', '15', '16', '17'],
        correctAnswerIndex: 1,
        explanation: '225 ÷ 15 = 15',
        category: 'mental_calculation',
        difficulty: '3',
      ),

      // Mental Calculation - Level 4 (Expert Mental Math)
      Question(
        id: 'mc_4_1',
        text: 'What is 17 × 23?',
        options: ['389', '390', '391', '392'],
        correctAnswerIndex: 2,
        explanation: '17 × 23 = 391',
        category: 'mental_calculation',
        difficulty: '4',
      ),
      Question(
        id: 'mc_4_2',
        text: 'What is 289 ÷ 17?',
        options: ['16', '17', '18', '19'],
        correctAnswerIndex: 1,
        explanation: '289 ÷ 17 = 17',
        category: 'mental_calculation',
        difficulty: '4',
      ),

      // Mental Calculation - Level 5 (Master Mental Math)
      Question(
        id: 'mc_5_1',
        text: 'What is 37 × 43?',
        options: ['1590', '1591', '1592', '1593'],
        correctAnswerIndex: 1,
        explanation: '37 × 43 = 1591',
        category: 'mental_calculation',
        difficulty: '5',
      ),
      Question(
        id: 'mc_5_2',
        text: 'What is 1369 ÷ 37?',
        options: ['36', '37', '38', '39'],
        correctAnswerIndex: 1,
        explanation: '1369 ÷ 37 = 37',
        category: 'mental_calculation',
        difficulty: '5',
      ),

      // Mental Calculation - Level 6 (Expert Mental Math)
      Question(
        id: 'mc_6_1',
        text: 'What is 47 × 53?',
        options: ['2490', '2491', '2492', '2493'],
        correctAnswerIndex: 1,
        explanation: '47 × 53 = 2491',
        category: 'mental_calculation',
        difficulty: '6',
      ),
      Question(
        id: 'mc_6_2',
        text: 'What is 2209 ÷ 47?',
        options: ['46', '47', '48', '49'],
        correctAnswerIndex: 1,
        explanation: '2209 ÷ 47 = 47',
        category: 'mental_calculation',
        difficulty: '6',
      ),
    ];

    // تصفية الأسئلة حسب الفئة والمستوى
    List<Question> filteredQuestions = allQuestions.where((question) {
      bool categoryMatch = question.category == settings.category;
      bool levelMatch = question.difficulty == settings.level;
      return categoryMatch && levelMatch;
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