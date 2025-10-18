import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../widgets/common_widgets.dart';
import '../widgets/quiz_widgets.dart';
import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/history_provider.dart';
import '../models/quiz_history.dart';
import 'settings_screen.dart';
import 'detailed_results_screen.dart';
import 'quiz_screen.dart';

/// شاشة النتائج
class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _tryAgain() {
    ref.read(quizProvider.notifier).restartQuiz();
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const QuizScreen()));
  }

  void _backToSettings() {
    ref.read(quizProvider.notifier).resetQuiz();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const TestSettingsScreen()),
      (route) => false,
    );
  }

  void _viewDetailedResults() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DetailedResultsScreen()),
    );
  }

  void _shareResults() {
    final session = ref.read(quizProvider);
    if (session == null) return;

    final score = session.correctCount;
    final total = session.questions.length;
    final percentage = session.scorePercentage;

    final shareText =
        '''
🎯 Quiz Results - Quizzles

Score: $score/$total (${percentage.toStringAsFixed(1)}%)

Time: ${_formatDuration(session.totalTime)}

Category: ${session.settings.category.toUpperCase()}
Difficulty: ${session.settings.difficulty.toUpperCase()}

Great job! 🎉
''';

    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Results copied to clipboard!'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getScoreMessage(double percentage) {
    if (percentage >= 90) return 'Outstanding! 🌟';
    if (percentage >= 80) return 'Excellent! 🎉';
    if (percentage >= 70) return 'Great job! 👍';
    if (percentage >= 60) return 'Good work! 😊';
    if (percentage >= 50) return 'Not bad! 💪';
    return 'Keep practicing! 📚';
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(quizProvider);

    if (session == null) {
      return const AppScaffold(
        body: Center(child: AppLoadingIndicator(message: 'Loading results...')),
      );
    }

    final score = session.correctCount;
    final total = session.questions.length;
    final percentage = session.scorePercentage;

    // حفظ السجل عند العرض لأول مرة إذا لم يتم الحفظ
    // نعتمد على isCompleted للإشارة لإتمام الاختبار
    if (session.isCompleted) {
      // نبني الإدخال من الجلسة
      final entry = QuizHistoryEntry(
        completedAt: DateTime.now(),
        category: session.settings.category,
        difficulty: session.settings.difficulty,
        score: score,
        total: total,
        percentage: percentage,
        durationSeconds: session.totalTime.inSeconds,
      );
      // إضافة دون انتظار UI
      // تجاهل: unawaited_futures
      ref.read(historyProvider.notifier).addEntry(entry);
    }

    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Results',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _shareResults,
            icon: const Icon(Icons.share, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // رسالة النتيجة
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const Text(
                        'Your final score is',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getScoreMessage(percentage),
                        style: TextStyle(
                          fontSize: 18,
                          color: _getScoreColor(percentage),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // دائرة النتيجة
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ResultCircle(
                      score: score.toDouble(),
                      maxScore: total.toDouble(),
                      size: 140,
                      label: 'out of $total',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // تفاصيل النتيجة
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: AppCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total correct answers',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '$score out of $total Questions',
                                style: const TextStyle(
                                  color: AppColors.primaryAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Accuracy',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: _getScoreColor(percentage),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Time taken',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _formatDuration(session.totalTime),
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Category',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                session.settings.category.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Difficulty',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                session.settings.difficulty.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // الأزرار
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // زر المحاولة مرة أخرى
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            text: 'Try Again',
                            onPressed: _tryAgain,
                            icon: Icons.refresh,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // زر العودة للإعدادات
                        SizedBox(
                          width: double.infinity,
                          child: SecondaryButton(
                            text: 'Back to Settings',
                            onPressed: _backToSettings,
                            icon: Icons.settings,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // زر النتائج التفصيلية
                        SizedBox(
                          width: double.infinity,
                          child: SecondaryButton(
                            text: 'View Detailed Results',
                            onPressed: _viewDetailedResults,
                            icon: Icons.analytics,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
