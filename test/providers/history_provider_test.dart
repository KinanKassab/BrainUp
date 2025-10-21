import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mastermath/providers/history_provider.dart';
import 'package:mastermath/models/quiz_history.dart';

void main() {
  group('HistoryNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be empty list', () {
      final state = container.read(historyNotifierProvider);
      expect(state, isEmpty);
    });

    test('addEntry should add entry to the beginning of the list', () async {
      // Arrange
      final notifier = container.read(historyNotifierProvider.notifier);
      final entry = QuizHistoryEntry(
        id: '1',
        score: 8,
        totalQuestions: 10,
        category: 'science',
        difficulty: 'easy',
        completedAt: DateTime.now(),
        timeSpent: 120,
      );

      // Act
      await notifier.addEntry(entry);

      // Assert
      final state = container.read(historyNotifierProvider);
      expect(state, hasLength(1));
      expect(state.first.id, equals('1'));
      expect(state.first.score, equals(8));
      expect(state.first.totalQuestions, equals(10));
    });

    test('addEntry should maintain chronological order (newest first)', () async {
      // Arrange
      final notifier = container.read(historyNotifierProvider.notifier);
      final entry1 = QuizHistoryEntry(
        id: '1',
        score: 8,
        totalQuestions: 10,
        category: 'science',
        difficulty: 'easy',
        completedAt: DateTime.now().subtract(const Duration(hours: 1)),
        timeSpent: 120,
      );
      final entry2 = QuizHistoryEntry(
        id: '2',
        score: 9,
        totalQuestions: 10,
        category: 'history',
        difficulty: 'medium',
        completedAt: DateTime.now(),
        timeSpent: 150,
      );

      // Act
      await notifier.addEntry(entry1);
      await notifier.addEntry(entry2);

      // Assert
      final state = container.read(historyNotifierProvider);
      expect(state, hasLength(2));
      expect(state.first.id, equals('2')); // Newest entry first
      expect(state.last.id, equals('1')); // Oldest entry last
    });

    test('addEntry should limit entries to 200', () async {
      // Arrange
      final notifier = container.read(historyNotifierProvider.notifier);
      
      // Act - Add 201 entries
      for (int i = 0; i < 201; i++) {
        final entry = QuizHistoryEntry(
          id: i.toString(),
          score: 5,
          totalQuestions: 10,
          category: 'general',
          difficulty: 'easy',
          completedAt: DateTime.now(),
          timeSpent: 60,
        );
        await notifier.addEntry(entry);
      }

      // Assert
      final state = container.read(historyNotifierProvider);
      expect(state, hasLength(200)); // Should be limited to 200
      expect(state.first.id, equals('200')); // Most recent entry should be first
    });

    test('clearAll should remove all entries', () async {
      // Arrange
      final notifier = container.read(historyNotifierProvider.notifier);
      final entry = QuizHistoryEntry(
        id: '1',
        score: 8,
        totalQuestions: 10,
        category: 'science',
        difficulty: 'easy',
        completedAt: DateTime.now(),
        timeSpent: 120,
      );
      await notifier.addEntry(entry);

      // Act
      await notifier.clearAll();

      // Assert
      final state = container.read(historyNotifierProvider);
      expect(state, isEmpty);
    });

    test('multiple operations should work correctly', () async {
      // Arrange
      final notifier = container.read(historyNotifierProvider.notifier);
      final entry1 = QuizHistoryEntry(
        id: '1',
        score: 8,
        totalQuestions: 10,
        category: 'science',
        difficulty: 'easy',
        completedAt: DateTime.now().subtract(const Duration(hours: 2)),
        timeSpent: 120,
      );
      final entry2 = QuizHistoryEntry(
        id: '2',
        score: 9,
        totalQuestions: 10,
        category: 'history',
        difficulty: 'medium',
        completedAt: DateTime.now().subtract(const Duration(hours: 1)),
        timeSpent: 150,
      );
      final entry3 = QuizHistoryEntry(
        id: '3',
        score: 7,
        totalQuestions: 10,
        category: 'geography',
        difficulty: 'hard',
        completedAt: DateTime.now(),
        timeSpent: 180,
      );

      // Act
      await notifier.addEntry(entry1);
      await notifier.addEntry(entry2);
      await notifier.addEntry(entry3);

      // Assert
      final state = container.read(historyNotifierProvider);
      expect(state, hasLength(3));
      expect(state[0].id, equals('3')); // Most recent
      expect(state[1].id, equals('2')); // Middle
      expect(state[2].id, equals('1')); // Oldest
    });
  });
}
