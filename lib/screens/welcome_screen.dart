import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import '../widgets/common_widgets.dart' as common;
import '../providers/theme_provider.dart';
import 'settings_screen.dart';
import 'app_settings_screen.dart';
import 'stats_screen.dart';

/// شاشة الترحيب الرئيسية
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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

  void _showAboutDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.bgCardDark : AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          'About MasterMath',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'MasterMath is a comprehensive mathematics training app that helps you develop your mathematical skills through structured practice. Choose from different categories and levels to challenge yourself and track your progress.',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(
                color: AppColors.primaryAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToStats() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const StatsScreen()));
  }

  void _navigateToSettings() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AppSettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return common.AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _navigateToSettings,
            icon: Icon(
              Icons.settings,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              size: 28,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(flex: 2),

            // الشعار والاسم
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: AppColors.primaryGradient,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryAccent.withValues(
                                  alpha: isDark ? 0.6 : 0.4,
                                ),
                                blurRadius: isDark ? 50 : 40,
                                spreadRadius: isDark ? 10 : 8,
                                offset: const Offset(0, 8),
                              ),
                              BoxShadow(
                                color: AppColors.secondaryAccent.withValues(
                                  alpha: isDark ? 0.3 : 0.2,
                                ),
                                blurRadius: 20,
                                spreadRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.calculate,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'MasterMath',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // النص الفرعي
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        const Text(
                          'Master Mathematics!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Train your mind and improve your skills',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const Spacer(flex: 3),

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
                        // زر Play Now الرئيسي
                        SizedBox(
                          width: double.infinity,
                          child: OpenContainer(
                            closedElevation: 0,
                            openElevation: 0,
                            closedColor: Colors.transparent,
                            openColor: Colors.transparent,
                            transitionDuration: const Duration(
                              milliseconds: 500,
                            ),
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            openBuilder: (context, _) => const TestSettingsScreen(),
                            closedBuilder: (context, openContainer) =>
                                common.PrimaryButton(
                                  text: 'Play Now',
                                  onPressed: openContainer,
                                  icon: Icons.play_arrow,
                                ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // زر About الثانوي
                        SizedBox(
                          width: double.infinity,
                          child: common.SecondaryButton(
                            text: 'About',
                            onPressed: _showAboutDialog,
                            icon: Icons.info_outline,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // زر Stats
                        SizedBox(
                          width: double.infinity,
                          child: common.SecondaryButton(
                            text: 'Stats',
                            onPressed: _navigateToStats,
                            icon: Icons.bar_chart_rounded,
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
