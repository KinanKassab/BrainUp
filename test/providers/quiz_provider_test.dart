import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:brainup/providers/quiz_provider.dart';
import 'package:brainup/models/settings_model.dart';
import 'package:brainup/models/question.dart';
import 'package:brainup/services/api_service.dart';

import 'quiz_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('QuizNotifier', () {
    late ProviderContainer container;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      container = ProviderContainer(
        overrides: [
          // يمكن إضافة overrides هنا إذا لزم الأمر
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be null', () {
      final notifier = container.read(quizNotifierProvider.notifier);
      expect(notifier.state, isNull);
    });

    test('startQuiz should load questions from API when useApiQuestions is true', () async {
      // Arrange
      final settings = const SettingsModel(
        useApiQuestions: true,
        apiQuestionCount: 10,
        category: 'science',
        difficulty: 'easy',
      );
      
      final mockQuestions = [
        Question(
          id: '1',
          text: 'Test question',
          options: ['A', 'B', 'C', 'D'],
          correctAnswerIndex: 0,
          category: 'science',
          difficulty: 'easy',
        ),
      ];

      when(mockApiService.fetchQuestions(
        amount: 10,
        category: 'science',
        difficulty: 'easy',
      )).thenAnswer((_) async => mockQuestions);

      // Act
      await container.read(quizNotifierProvider.notifier).startQuiz(settings);

      // Assert
      final state = container.read(quizNotifierProvider);
      expect(state, isNotNull);
      expect(state!.questions, hasLength(1));
      expect(state.questions.first.text, equals('Test question'));
    });

    test('startQuiz should use local questions when useApiQuestions is false', () async {
      // Arrange
      final settings = const SettingsModel(
        useApiQuestions: false,
        numQuestions: 5,
        category: 'general',
        difficulty: 'easy',
      );

      // Act
      await container.read(quizNotifierProvider.notifier).startQuiz(settings);

      // Assert
      final state = container.read(quizNotifierProvider);
      expect(state, isNotNull);
      expect(state!.questions, isNotEmpty);
    });

    test('answerQuestion should update session with answer', () {
      // Arrange
      final settings = const SettingsModel();
      final notifier = container.read(quizNotifierProvider.notifier);
      
      // Act
      notifier.startQuiz(settings);
      notifier.answerQuestion(0);

      // Assert
      final state = container.read(quizNotifierProvider);
      expect(state, isNotNull);
      expect(state!.answers, hasLength(1));
      expect(state.answers.first, equals(0));
    });

    test('nextQuestion should move to next question', () {
      // Arrange
      final settings = const SettingsModel(numQuestions: 2);
      final notifier = container.read(quizNotifierProvider.notifier);
      
      // Act
      notifier.startQuiz(settings);
      final initialIndex = container.read(quizNotifierProvider)!.currentIndex;
      notifier.nextQuestion();

      // Assert
      final state = container.read(quizNotifierProvider);
      expect(state!.currentIndex, equals(initialIndex + 1));
    });

    test('previousQuestion should move to previous question', () {
      // Arrange
      final settings = const SettingsModel(numQuestions: 2);
      final notifier = container.read(quizNotifierProvider.notifier);
      
      // Act
      notifier.startQuiz(settings);
      notifier.nextQuestion();
      final afterNextIndex = container.read(quizNotifierProvider)!.currentIndex;
      notifier.previousQuestion();

      // Assert
      final state = container.read(quizNotifierProvider);
      expect(state!.currentIndex, equals(afterNextIndex - 1));
    });

    test('completeQuiz should mark session as completed', () {
      // Arrange
      final settings = const SettingsModel();
      final notifier = container.read(quizNotifierProvider.notifier);
      
      // Act
      notifier.startQuiz(settings);
      notifier.completeQuiz();

      // Assert
      final state = container.read(quizNotifierProvider);
      expect(state!.isCompleted, isTrue);
    });

    test('resetQuiz should clear session', () {
      // Arrange
      final settings = const SettingsModel();
      final notifier = container.read(quizNotifierProvider.notifier);
      
      // Act
      notifier.startQuiz(settings);
      notifier.resetQuiz();

      // Assert
      final state = container.read(quizNotifierProvider);
      expect(state, isNull);
    });
  });
}
