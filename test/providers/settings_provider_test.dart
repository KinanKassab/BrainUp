import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brainup/providers/settings_provider.dart';
import 'package:brainup/models/settings_model.dart';

void main() {
  group('SettingsNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should have default values', () {
      final state = container.read(settingsNotifierProvider);
      expect(state.numQuestions, equals(10));
      expect(state.difficulty, equals('medium'));
      expect(state.category, equals('general'));
      expect(state.timerEnabled, equals(false));
      expect(state.timerSeconds, equals(30));
      expect(state.shuffle, equals(true));
      expect(state.showExplanations, equals(true));
      expect(state.soundOn, equals(false));
      expect(state.language, equals('en'));
      expect(state.highContrastMode, equals(false));
      expect(state.useApiQuestions, equals(true));
      expect(state.apiQuestionCount, equals(10));
    });

    test('updateNumQuestions should update numQuestions', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateNumQuestions(15);

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.numQuestions, equals(15));
    });

    test('updateDifficulty should update difficulty', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateDifficulty('hard');

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.difficulty, equals('hard'));
    });

    test('updateCategory should update category', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateCategory('science');

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.category, equals('science'));
    });

    test('updateTimerEnabled should update timerEnabled', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateTimerEnabled(true);

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.timerEnabled, equals(true));
    });

    test('updateTimerSeconds should update timerSeconds', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateTimerSeconds(60);

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.timerSeconds, equals(60));
    });

    test('updateShuffle should update shuffle', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateShuffle(false);

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.shuffle, equals(false));
    });

    test('updateShowExplanations should update showExplanations', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateShowExplanations(false);

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.showExplanations, equals(false));
    });

    test('updateSoundOn should update soundOn', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateSoundOn(true);

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.soundOn, equals(true));
    });

    test('updateLanguage should update language', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateLanguage('ar');

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.language, equals('ar'));
    });

    test('updateHighContrastMode should update highContrastMode', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateHighContrastMode(true);

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.highContrastMode, equals(true));
    });

    test('updateUseApiQuestions should update useApiQuestions', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateUseApiQuestions(false);

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.useApiQuestions, equals(false));
    });

    test('updateApiQuestionCount should update apiQuestionCount', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);

      // Act
      notifier.updateApiQuestionCount(20);

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.apiQuestionCount, equals(20));
    });

    test('resetToDefaults should reset all settings to default values', () {
      // Arrange
      final notifier = container.read(settingsNotifierProvider.notifier);
      notifier.updateNumQuestions(20);
      notifier.updateDifficulty('hard');
      notifier.updateCategory('science');

      // Act
      notifier.resetToDefaults();

      // Assert
      final state = container.read(settingsNotifierProvider);
      expect(state.numQuestions, equals(10));
      expect(state.difficulty, equals('medium'));
      expect(state.category, equals('general'));
    });
  });
}
