import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';

/// مؤشر التقدم المحسن
class AppProgressIndicator extends StatelessWidget {
  final int current;
  final int total;
  final bool showPercentage;
  final bool showNumbers;

  const AppProgressIndicator({
    super.key,
    required this.current,
    required this.total,
    this.showPercentage = true,
    this.showNumbers = true,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / total;
    final percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // شريط التقدم
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                  child: Stack(
                    children: [
                      // الخلفية
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      // التقدم
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: MediaQuery.of(context).size.width * 0.7 * progress,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryAccent,
                              AppColors.secondaryAccent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // النسبة المئوية
              if (showPercentage)
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryAccent,
                  ),
                ),
            ],
          ),
          
          if (showNumbers) ...[
            const SizedBox(height: 8),
            // الأرقام
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question $current',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'of $total',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// مؤشر تقدم دائري
class CircularProgressIndicator extends StatelessWidget {
  final int current;
  final int total;
  final double size;
  final double strokeWidth;

  const CircularProgressIndicator({
    super.key,
    required this.current,
    required this.total,
    this.size = 60,
    this.strokeWidth = 6,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / total;
    final percentage = (progress * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // الخلفية الدائرية
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
          // التقدم الدائري
          CustomPaint(
            painter: CircularProgressPainter(
              progress: progress,
              strokeWidth: strokeWidth,
            ),
            child: Container(),
          ),
          // النسبة المئوية في المنتصف
          Center(
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontSize: size * 0.2,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// رسام التقدم الدائري
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;
    
    // فرشاة الخلفية
    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
    // فرشاة التقدم
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    // تدرج لوني للتقدم
    progressPaint.shader = const LinearGradient(
      colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    // رسم الخلفية الدائرية
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // رسم التقدم
    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // بداية من الأعلى
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
