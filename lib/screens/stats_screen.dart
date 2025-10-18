import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/common_widgets.dart' as common;
import 'package:fl_chart/fl_chart.dart';
import '../providers/theme_provider.dart';
import '../providers/history_provider.dart';

/// شاشة الإحصائيات البسيطة
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyNotifierProvider);

    final totalQuizzes = history.length;
    final avgPercentage = history.isEmpty
        ? 0.0
        : history.map((e) => e.percentage).reduce((a, b) => a + b) /
              history.length;

    return common.AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Stats',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // بطاقات ملخص
            Row(
              children: [
                Expanded(
                  child: common.AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Quizzes',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$totalQuizzes',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: common.AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Average Score',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${avgPercentage.toStringAsFixed(1)}% ',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // مخطط خطي للنتائج الأخيرة
            if (history.isNotEmpty) ...[
              common.AppCard(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: AppColors.primaryAccent,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.15,
                            ),
                          ),
                          spots: List.generate(history.length, (i) {
                            final e = history[history.length - 1 - i];
                            // x: الأحدث على اليمين
                            return FlSpot(i.toDouble(), e.percentage);
                          }).reversed.toList(),
                        ),
                      ],
                      minY: 0,
                      maxY: 100,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],

            const Text(
              'Recent Results',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: history.isEmpty
                  ? const Center(
                      child: Text(
                        'No history yet',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.separated(
                      itemCount: history.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final h = history[index];
                        return common.AppCard(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${h.category.toUpperCase()} · ${h.difficulty.toUpperCase()}',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${h.score}/${h.total} · ${(h.percentage).toStringAsFixed(1)}% · ${Duration(seconds: h.durationSeconds).inMinutes.toString().padLeft(2, '0')}:${(h.durationSeconds % 60).toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
