import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/common_widgets.dart' as common;
import '../widgets/timer_widget.dart';
import '../widgets/question_card.dart';
import '../widgets/option_item.dart';
import '../widgets/progress_indicator.dart';
import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import 'results_screen.dart';
import '../l10n/app_localizations.dart';

/// شاشة الأسئلة
class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  int _timeRemaining = 0;
  bool _hasAnswered = false;
  int? _selectedAnswer;
  late AnimationController _explanationController;
  late Animation<double> _explanationAnimation;

  @override
  void initState() {
    super.initState();
    _explanationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _explanationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _explanationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _explanationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    final sessionState = ref.read(quizNotifierProvider);
    final session = sessionState.value;
    if (session?.settings.timerEnabled == true) {
      _timeRemaining = session!.settings.timerSeconds;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeRemaining > 0) {
          setState(() {
            _timeRemaining--;
          });
        } else {
          _timer?.cancel();
          _autoAnswer();
        }
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _autoAnswer() {
    if (!_hasAnswered) {
      setState(() {
        _hasAnswered = true;
        _selectedAnswer = -1; // إجابة خاطئة تلقائياً
      });
      ref.read(quizNotifierProvider.notifier).answerQuestion(-1);
      _showExplanation();
    }
  }

  void _answerQuestion(int answerIndex) {
    if (_hasAnswered) return;

    setState(() {
      _hasAnswered = true;
      _selectedAnswer = answerIndex;
    });

    _stopTimer();
    ref.read(quizNotifierProvider.notifier).answerQuestion(answerIndex);
    _showExplanation();
  }

  void _showExplanation() {
    final sessionState = ref.read(quizNotifierProvider);
    final session = sessionState.value;
    if (session?.settings.showExplanations == true) {
      _explanationController.forward();
    }
  }

  void _nextQuestion() {
    final sessionState = ref.read(quizNotifierProvider);
    final session = sessionState.value;
    if (session == null) return;

    if (session.hasNextQuestion) {
      ref.read(quizNotifierProvider.notifier).nextQuestion();
      _resetQuestionState();
    } else {
      ref.read(quizNotifierProvider.notifier).completeQuiz();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 380),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ResultsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            final slideUp = Tween<Offset>(
              begin: const Offset(0.0, 0.08),
              end: Offset.zero,
            ).animate(curved);
            final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(curved);

            final fadeOutQuiz = Tween<double>(begin: 1.0, end: 0.0).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            );

            return Stack(
              children: [
                FadeTransition(opacity: fadeOutQuiz, child: child),
                SlideTransition(
                  position: slideUp,
                  child: FadeTransition(opacity: fadeIn, child: child),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  void _previousQuestion() {
    final sessionState = ref.read(quizNotifierProvider);
    final session = sessionState.value;
    if (session?.hasPreviousQuestion == true) {
      ref.read(quizNotifierProvider.notifier).previousQuestion();
      _resetQuestionState();
    }
  }

  void _resetQuestionState() {
    setState(() {
      _hasAnswered = false;
      _selectedAnswer = null;
      _timeRemaining = 0;
    });
    _explanationController.reset();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(quizNotifierProvider);
    final session = sessionState.value;
    final l10n = AppLocalizations.of(context)!;

    if (session == null) {
      return common.AppScaffold(
        body: Center(
          child: common.AppLoadingIndicator(message: l10n.loading),
        ),
      );
    }

    final question = session.currentQuestion;
    if (question == null) {
      return common.AppScaffold(
        body: Center(
          child: common.AppLoadingIndicator(message: l10n.failedToLoadQuestions),
        ),
      );
    }

    // بدء المؤقت عند تحميل السؤال
    if (!_hasAnswered && _timeRemaining == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startTimer();
      });
    }

    return common.AppScaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: Text(
            '${(session.currentIndex + 1).toString().padLeft(2, '0')}/${session.questions.length}',
            key: ValueKey(session.currentIndex),
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.textPrimaryDark 
                : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: common.AdaptiveBackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (session.settings.timerEnabled && _timeRemaining > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: CircularTimerWidget(
                totalSeconds: session.settings.timerSeconds,
                remainingSeconds: _timeRemaining,
                isActive: !_hasAnswered,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // مؤشر التقدم
            AppProgressIndicator(
              current: session.currentIndex + 1,
              total: session.questions.length,
            ),

            const SizedBox(height: 24),

            // بطاقة السؤال
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: QuestionCard(
                key: ValueKey(question.id),
                questionText: question.text,
                imageUrl: question.imageUrl,
                category: question.category,
                difficulty: question.difficulty,
              ),
            ),

            const SizedBox(height: 24),

            // الخيارات
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = _selectedAnswer == index;
              final isCorrect = index == question.correctAnswerIndex;
              final isWrong = isSelected && !isCorrect;

              return AnimatedSwitcher(
                key: ValueKey(
                  '${question.id}-$index-${_hasAnswered.toString()}',
                ),
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1.0,
                    child: child,
                  ),
                ),
                child: OptionItem(
                  key: ValueKey(
                    'opt-$index-$isSelected-$isWrong-${_hasAnswered.toString()}',
                  ),
                  index: index + 1,
                  text: option,
                  isSelected: isSelected,
                  isCorrect: _hasAnswered && isCorrect,
                  isWrong: isWrong,
                  isDisabled: _hasAnswered,
                  onTap: () => _answerQuestion(index),
                ),
              );
            }),

            // التفسير
            if (_hasAnswered && question.explanation != null)
              AnimatedBuilder(
                animation: _explanationAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _explanationAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_explanationAnimation),
                      child: common.AppCard(
                        backgroundColor: AppColors.surface,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: AppColors.scoreYellow,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.explanation,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark 
                                      ? AppColors.textPrimaryDark 
                                      : AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              question.explanation!,
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark 
                                  ? AppColors.textMutedDark 
                                  : AppColors.textMuted,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 32),

            // أزرار التنقل
            Row(
              children: [
                Expanded(
                  child: common.SecondaryButton(
                    text: l10n.previous,
                    onPressed: session.hasPreviousQuestion
                        ? _previousQuestion
                        : null,
                    icon: Icons.arrow_back,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: common.PrimaryButton(
                    text: session.hasNextQuestion ? l10n.next : l10n.finish,
                    onPressed: _hasAnswered ? _nextQuestion : null,
                    icon: session.hasNextQuestion
                        ? Icons.arrow_forward
                        : Icons.check,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
