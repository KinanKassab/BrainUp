import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/common_widgets.dart' as common;
import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';

/// شاشة النتائج التفصيلية
class DetailedResultsScreen extends ConsumerWidget {
  const DetailedResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(quizNotifierProvider);
    final session = sessionState.value;

    if (session == null) {
      return common.AppScaffold(
        body: const Center(child: common.AppLoadingIndicator(message: 'Loading results...')),
      );
    }

    return common.AppScaffold(
      appBar: AppBar(
        title: Text(
          'Detailed Results',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.textPrimaryDark 
              : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: common.AdaptiveBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ملخص النتائج
            common.AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quiz Summary',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                        ? AppColors.textPrimaryDark 
                        : AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Questions:',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${session.questions.length}',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.textPrimaryDark 
                            : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Correct Answers:',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${session.correctCount}',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Accuracy:',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${session.scorePercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: _getScoreColor(session.scorePercentage),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Time Taken:',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _formatDuration(session.totalTime),
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.textPrimaryDark 
                            : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // قائمة الأسئلة
            Text(
              'Question Details',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.textPrimaryDark 
                  : AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ...session.questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              final userAnswer = session.userAnswers[index];
              final isCorrect = userAnswer == question.correctAnswerIndex;
              // Note: questionTimes is not available in the current model, using a placeholder
              final timeTaken = 30; // Placeholder - would need to be added to QuizSession model

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: common.AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // رقم السؤال والنتيجة
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isCorrect ? AppColors.success : AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Question ${index + 1}',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark 
                                  ? AppColors.textPrimaryDark 
                                  : AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: isCorrect ? AppColors.success : AppColors.error,
                            size: 24,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // نص السؤال
                      Text(
                        question.text,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.textPrimaryDark 
                            : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // الإجابات
                      ...question.options.asMap().entries.map((optionEntry) {
                        final optionIndex = optionEntry.key;
                        final option = optionEntry.value;
                        final isUserAnswer = userAnswer == optionIndex;
                        final isCorrectAnswer = question.correctAnswerIndex == optionIndex;

                        Color backgroundColor = Colors.transparent;
                        Color textColor = Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.textMutedDark 
                          : AppColors.textMuted;
                        IconData? icon;

                        if (isCorrectAnswer) {
                          backgroundColor = AppColors.success.withValues(alpha: 0.1);
                          textColor = AppColors.success;
                          icon = Icons.check_circle;
                        } else if (isUserAnswer && !isCorrectAnswer) {
                          backgroundColor = AppColors.error.withValues(alpha: 0.1);
                          textColor = AppColors.error;
                          icon = Icons.cancel;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCorrectAnswer || isUserAnswer
                                  ? textColor
                                  : AppColors.outline,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              if (icon != null) ...[
                                Icon(
                                  icon,
                                  color: textColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                    fontWeight: isCorrectAnswer || isUserAnswer
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 12),

                      // الوقت المستغرق
                      Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            color: AppColors.textMuted,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Time: ${_formatDuration(Duration(seconds: timeTaken))}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return AppColors.warning;
    return AppColors.error;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
