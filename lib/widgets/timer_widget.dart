import 'package:flutter/material.dart';

/// مؤقت دائري متقدم مع ألوان متدرجة
class CircularTimerWidget extends StatefulWidget {
  final int totalSeconds;
  final int remainingSeconds;
  final VoidCallback? onTimeUp;
  final bool isActive;

  const CircularTimerWidget({
    super.key,
    required this.totalSeconds,
    required this.remainingSeconds,
    this.onTimeUp,
    this.isActive = true,
  });

  @override
  State<CircularTimerWidget> createState() => _CircularTimerWidgetState();
}

class _CircularTimerWidgetState extends State<CircularTimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.totalSeconds),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    
    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CircularTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.remainingSeconds / widget.totalSeconds;
    final isLowTime = progress <= 0.2;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            children: [
              // الخلفية الدائرية
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withValues(alpha:0.1),
                ),
              ),
              // المؤقت الدائري
              CustomPaint(
                painter: CircularTimerPainter(
                  progress: progress,
                  isLowTime: isLowTime,
                ),
              ),
              // النص في المنتصف
              Center(
                child: Text(
                  '${widget.remainingSeconds}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLowTime ? Colors.red : Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// رسام المؤقت الدائري
class CircularTimerPainter extends CustomPainter {
  final double progress;
  final bool isLowTime;

  CircularTimerPainter({
    required this.progress,
    required this.isLowTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    
    // فرشاة الخلفية
    final backgroundPaint = Paint()
      ..color = Colors.grey.withValues(alpha:0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    
    // فرشاة المؤقت
    final timerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    
    // تحديد اللون حسب الوقت المتبقي
    if (isLowTime) {
      timerPaint.shader = const LinearGradient(
        colors: [Colors.red, Colors.orange],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    } else {
      timerPaint.shader = const LinearGradient(
        colors: [Colors.blue, Colors.green],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    }
    
    // رسم الخلفية الدائرية
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // رسم المؤقت
    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // بداية من الأعلى
      sweepAngle,
      false,
      timerPaint,
    );
  }

  @override
  bool shouldRepaint(CircularTimerPainter oldDelegate) {
    return progress != oldDelegate.progress || isLowTime != oldDelegate.isLowTime;
  }
}

/// مؤقت خطي متقدم
class LinearTimerWidget extends StatefulWidget {
  final int totalSeconds;
  final int remainingSeconds;
  final VoidCallback? onTimeUp;
  final bool isActive;

  const LinearTimerWidget({
    super.key,
    required this.totalSeconds,
    required this.remainingSeconds,
    this.onTimeUp,
    this.isActive = true,
  });

  @override
  State<LinearTimerWidget> createState() => _LinearTimerWidgetState();
}

class _LinearTimerWidgetState extends State<LinearTimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.totalSeconds),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    
    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(LinearTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.remainingSeconds / widget.totalSeconds;
    final isLowTime = progress <= 0.2;
    
    return Container(
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey.withValues(alpha:0.2),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(
              isLowTime ? Colors.red : Colors.blue,
            ),
            minHeight: 8,
          );
        },
      ),
    );
  }
}
