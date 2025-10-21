import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';

/// عنصر خيار محسن مع تأثيرات بصرية
class OptionItem extends StatefulWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool isDisabled;
  final VoidCallback? onTap;

  const OptionItem({
    super.key,
    required this.index,
    required this.text,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  State<OptionItem> createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: widget.isDisabled ? null : (_) => _controller.forward(),
            onTapUp: widget.isDisabled ? null : (_) => _controller.reverse(),
            onTapCancel: widget.isDisabled ? null : () => _controller.reverse(),
            onTap: widget.isDisabled ? null : widget.onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getBorderColor(),
                  width: 2,
                ),
                boxShadow: _getBoxShadow(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // رقم الخيار
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _getIndexBackgroundColor(),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getIndexBorderColor(),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: _getIndexIcon(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // نص الخيار
                    Expanded(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _getTextColor(),
                        ),
                      ),
                    ),
                    
                    // أيقونة الحالة
                    if (widget.isSelected || widget.isCorrect || widget.isWrong)
                      _getStatusIcon(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor() {
    if (widget.isCorrect) {
      return Colors.green.withValues(alpha: 0.1);
    } else if (widget.isWrong) {
      return Colors.red.withValues(alpha: 0.1);
    } else if (widget.isSelected) {
      return AppColors.primaryAccent.withValues(alpha: 0.1);
    } else {
      return Colors.transparent;
    }
  }

  Color _getBorderColor() {
    if (widget.isCorrect) {
      return Colors.green;
    } else if (widget.isWrong) {
      return Colors.red;
    } else if (widget.isSelected) {
      return AppColors.primaryAccent;
    } else {
      return Colors.grey.withValues(alpha: 0.3);
    }
  }

  Color _getIndexBackgroundColor() {
    if (widget.isCorrect) {
      return Colors.green;
    } else if (widget.isWrong) {
      return Colors.red;
    } else if (widget.isSelected) {
      return AppColors.primaryAccent;
    } else {
      return Colors.grey.withValues(alpha: 0.1);
    }
  }

  Color _getIndexBorderColor() {
    if (widget.isCorrect) {
      return Colors.green;
    } else if (widget.isWrong) {
      return Colors.red;
    } else if (widget.isSelected) {
      return AppColors.primaryAccent;
    } else {
      return Colors.grey.withValues(alpha: 0.3);
    }
  }

  Color _getTextColor() {
    if (widget.isCorrect || widget.isWrong) {
      return Colors.white;
    } else if (widget.isSelected) {
      return AppColors.primaryAccent;
    } else {
      return Theme.of(context).brightness == Brightness.dark 
        ? AppColors.textPrimaryDark 
        : AppColors.textPrimary;
    }
  }

  Widget _getIndexIcon() {
    if (widget.isCorrect) {
      return const Icon(
        Icons.check,
        color: Colors.white,
        size: 20,
      );
    } else if (widget.isWrong) {
      return const Icon(
        Icons.close,
        color: Colors.white,
        size: 20,
      );
    } else {
      return Text(
        '${widget.index}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: widget.isSelected 
            ? Colors.white 
            : (Theme.of(context).brightness == Brightness.dark 
                ? AppColors.textPrimaryDark 
                : AppColors.textPrimary),
        ),
      );
    }
  }

  Widget _getStatusIcon() {
    if (widget.isCorrect) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 24,
      );
    } else if (widget.isWrong) {
      return const Icon(
        Icons.cancel,
        color: Colors.red,
        size: 24,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  List<BoxShadow> _getBoxShadow() {
    if (widget.isCorrect || widget.isWrong) {
      return [
        BoxShadow(
          color: (widget.isCorrect ? Colors.green : Colors.red).withValues(alpha: 0.3),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ];
    } else if (widget.isSelected) {
      return [
        BoxShadow(
          color: AppColors.primaryAccent.withValues(alpha: 0.3),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ];
    } else {
      return [];
    }
  }
}
