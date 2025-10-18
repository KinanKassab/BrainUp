import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import 'common_widgets.dart';

/// عنصر إعداد قابل لإعادة الاستخدام
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding ?? const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryAccent, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            trailing,
          ],
        ),
      ),
    );
  }
}

/// عنصر خيار السؤال
class OptionItem extends StatefulWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback? onTap;
  final bool isDisabled;

  const OptionItem({
    super.key,
    required this.index,
    required this.text,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  State<OptionItem> createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (widget.isDisabled) {
      if (widget.isCorrect) return AppColors.success.withValues(alpha: 0.2);
      if (widget.isWrong) return AppColors.error.withValues(alpha: 0.2);
      return AppColors.outline.withValues(alpha: 0.1);
    }
    if (widget.isSelected) {
      return AppColors.primaryAccent.withValues(alpha: 0.2);
    }
    return AppColors.bgCard;
  }

  Color _getBorderColor() {
    if (widget.isDisabled) {
      if (widget.isCorrect) return AppColors.success;
      if (widget.isWrong) return AppColors.error;
      return AppColors.outline;
    }
    if (widget.isSelected) return AppColors.primaryAccent;
    return AppColors.outline;
  }

  Color _getNumberColor() {
    if (widget.isDisabled) {
      if (widget.isCorrect) return AppColors.success;
      if (widget.isWrong) return AppColors.error;
      return AppColors.textMuted;
    }
    if (widget.isSelected) return AppColors.primaryAccent;
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: widget.isDisabled
                ? null
                : (_) => _animationController.forward(),
            onTapUp: widget.isDisabled
                ? null
                : (_) => _animationController.reverse(),
            onTapCancel: widget.isDisabled
                ? null
                : () => _animationController.reverse(),
            onTap: widget.isDisabled ? null : widget.onTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _getBorderColor(), width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _getNumberColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        widget.index.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getNumberColor(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: widget.isDisabled
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (widget.isDisabled) ...[
                    const SizedBox(width: 8),
                    Icon(
                      widget.isCorrect ? Icons.check_circle : Icons.cancel,
                      color: widget.isCorrect
                          ? AppColors.success
                          : AppColors.error,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// بطاقة السؤال
class QuestionCard extends StatelessWidget {
  final String questionText;
  final String? imageUrl;
  final Widget? imageWidget;

  const QuestionCard({
    super.key,
    required this.questionText,
    this.imageUrl,
    this.imageWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          if (imageUrl != null || imageWidget != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    imageWidget ??
                    (imageUrl != null
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: AppColors.textMuted,
                                  size: 48,
                                ),
                              );
                            },
                          )
                        : const SizedBox()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// دائرة النتيجة
class ResultCircle extends StatefulWidget {
  final double score;
  final double maxScore;
  final double size;
  final String? label;

  const ResultCircle({
    super.key,
    required this.score,
    required this.maxScore,
    this.size = 120,
    this.label,
  });

  @override
  State<ResultCircle> createState() => _ResultCircleState();
}

class _ResultCircleState extends State<ResultCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.score / widget.maxScore)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.scoreYellow.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // دائرة الخلفية
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                ),
              ),
              // دائرة التقدم
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: 8,
                  backgroundColor: AppColors.outline,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.scoreYellow,
                  ),
                ),
              ),
              // النص في المنتصف
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${widget.score.toInt()}',
                    style: TextStyle(
                      fontSize: widget.size * 0.3,
                      fontWeight: FontWeight.bold,
                      color: AppColors.scoreYellow,
                    ),
                  ),
                  if (widget.label != null) ...[
                    Text(
                      widget.label!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// مؤشر التقدم
class AppProgressIndicator extends StatelessWidget {
  final int current;
  final int total;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;

  const AppProgressIndicator({
    super.key,
    required this.current,
    required this.total,
    this.height = 6,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / total;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: backgroundColor ?? AppColors.outline,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: animatedProgress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height / 2),
                color: progressColor ?? AppColors.primaryAccent,
              ),
            ),
          ),
        );
      },
    );
  }
}
