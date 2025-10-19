import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/common_widgets.dart' as common;
import '../widgets/quiz_widgets.dart';
import '../providers/settings_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import 'quiz_screen.dart';
import 'package:animations/animations.dart';

/// شاشة إعدادات الاختبار
class TestSettingsScreen extends ConsumerStatefulWidget {
  const TestSettingsScreen({super.key});

  @override
  ConsumerState<TestSettingsScreen> createState() => _TestSettingsScreenState();
}

class _TestSettingsScreenState extends ConsumerState<TestSettingsScreen> {
  final List<String> _categories = [
    'super_mind',
    'amazing_fingers',
    'mental_calculation',
  ];
  final List<String> _languages = ['en', 'ar'];
  
  // Category-specific levels
  final Map<String, List<String>> _categoryLevels = {
    'super_mind': ['0', '1', '2'],
    'amazing_fingers': ['1', '2', '3'],
    'mental_calculation': ['0', '1', '2', '3', '4', '5', '6'],
  };

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'super_mind':
        return 'Super Mind';
      case 'amazing_fingers':
        return 'Amazing Fingers';
      case 'mental_calculation':
        return 'Mental Calculation';
      default:
        return 'Super Mind';
    }
  }

  Widget _buildVerticalOption(String title, bool isSelected, VoidCallback onTap) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryAccent.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryAccent : AppColors.borderLight,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? AppColors.primaryAccent : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primaryAccent,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showThemeDialog() {
    final currentMode = ref.read(themeNotifierProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Select Theme',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildVerticalOption(
              'System',
              currentMode == ThemeMode.system,
              () {
                ref.read(themeNotifierProvider.notifier).setThemeMode(ThemeMode.system);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 8),
            _buildVerticalOption(
              'Light',
              currentMode == ThemeMode.light,
              () {
                ref.read(themeNotifierProvider.notifier).setThemeMode(ThemeMode.light);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 8),
            _buildVerticalOption(
              'Dark',
              currentMode == ThemeMode.dark,
              () {
                ref.read(themeNotifierProvider.notifier).setThemeMode(ThemeMode.dark);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startQuiz() {
    final settings = ref.read(settingsNotifierProvider);
    ref.read(quizNotifierProvider.notifier).startQuiz(settings);

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const QuizScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          );
        },
      ),
    );
  }

  void _showLevelDialog() {
    final currentSettings = ref.read(settingsNotifierProvider);
    final currentCategory = currentSettings.category;
    final currentLevel = currentSettings.level;
    final availableLevels = _categoryLevels[currentCategory] ?? ['0'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Select Level',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableLevels.map((level) {
            return Column(
              children: [
                _buildVerticalOption(
                  'Level $level',
                  currentLevel == level,
                  () {
                    ref.read(settingsNotifierProvider.notifier).updateLevel(level);
                    Navigator.of(context).pop();
                  },
                ),
                if (level != availableLevels.last) const SizedBox(height: 8),
              ],
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog() {
    final currentCategory = ref.read(settingsNotifierProvider).category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Select Category',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildVerticalOption(
              'Super Mind',
              currentCategory == 'super_mind',
              () {
                ref.read(settingsNotifierProvider.notifier).updateCategory('super_mind');
                // Reset to first level when changing category
                ref.read(settingsNotifierProvider.notifier).updateLevel('0');
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 8),
            _buildVerticalOption(
              'Amazing Fingers',
              currentCategory == 'amazing_fingers',
              () {
                ref.read(settingsNotifierProvider.notifier).updateCategory('amazing_fingers');
                // Reset to first level when changing category
                ref.read(settingsNotifierProvider.notifier).updateLevel('1');
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 8),
            _buildVerticalOption(
              'Mental Calculation',
              currentCategory == 'mental_calculation',
              () {
                ref.read(settingsNotifierProvider.notifier).updateCategory('mental_calculation');
                // Reset to first level when changing category
                ref.read(settingsNotifierProvider.notifier).updateLevel('0');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final currentLanguage = ref.read(settingsNotifierProvider).language;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Select Language',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildVerticalOption(
              'English',
              currentLanguage == 'en',
              () {
                ref.read(settingsNotifierProvider.notifier).updateLanguage('en');
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 8),
            _buildVerticalOption(
              'العربية',
              currentLanguage == 'ar',
              () {
                ref.read(settingsNotifierProvider.notifier).updateLanguage('ar');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifierProvider);

    return common.AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Test Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: common.AdaptiveBackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),


            // عدد الأسئلة
            SettingsTile(
              icon: Icons.quiz,
              title: 'Number of Questions',
              subtitle: '${settings.numQuestions} questions',
              trailing: const SizedBox(width: 100),
              onTap: () {
                int dialogNumQuestions = settings.numQuestions;
                showDialog(
                  context: context,
                  builder: (context) => StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      backgroundColor: AppColors.bgCard,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      title: const Text(
                        'Number of Questions',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$dialogNumQuestions',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryAccent,
                            ),
                          ),
                          Slider(
                            value: dialogNumQuestions.toDouble(),
                            min: 5,
                            max: 50,
                            divisions: 45,
                            activeColor: AppColors.primaryAccent,
                            inactiveColor: AppColors.borderLight,
                            onChanged: (value) {
                              setState(() {
                                dialogNumQuestions = value.round();
                              });
                              // تحديث فوري للإعدادات
                              ref
                                  .read(settingsNotifierProvider.notifier)
                                  .updateNumQuestions(dialogNumQuestions);
                            },
                          ),
                          const Text(
                            'Range: 5 - 50 questions',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              color: AppColors.primaryAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // الفئة
            SettingsTile(
              icon: Icons.category,
              title: 'Category',
              subtitle: _getCategoryDisplayName(settings.category),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textMuted,
                size: 16,
              ),
              onTap: _showCategoryDialog,
            ),

            const SizedBox(height: 16),

            // المستوى
            SettingsTile(
              icon: Icons.trending_up,
              title: 'Level',
              subtitle: 'Level ${settings.level}',
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textMuted,
                size: 16,
              ),
              onTap: _showLevelDialog,
            ),

            const SizedBox(height: 16),

            // المؤقت
            SettingsTile(
              icon: Icons.timer,
              title: 'Timer per Question',
              subtitle: settings.timerEnabled
                  ? '${settings.timerSeconds} seconds'
                  : 'Disabled',
              trailing: Switch(
                value: settings.timerEnabled,
                onChanged: (value) {
                  ref.read(settingsNotifierProvider.notifier).updateTimerEnabled(value);
                },
                activeThumbColor: AppColors.primaryAccent,
              ),
            ),

            // إعدادات المؤقت
            if (settings.timerEnabled) ...[
              const SizedBox(height: 8),
              common.AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Timer Duration: ${settings.timerSeconds} seconds',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: settings.timerSeconds.toDouble(),
                      min: 10,
                      max: 120,
                      divisions: 22,
                      activeColor: AppColors.primaryAccent,
                      inactiveColor: AppColors.borderLight,
                      onChanged: (value) {
                        // تحديث فوري للإعدادات
                        ref
                            .read(settingsNotifierProvider.notifier)
                            .updateTimerSeconds(value.round());
                      },
                    ),
                    const Text(
                      'Range: 10 - 120 seconds',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // الصوت
            SettingsTile(
              icon: Icons.volume_up,
              title: 'Sound Effects',
              subtitle: settings.soundOn ? 'Enabled' : 'Disabled',
              trailing: Switch(
                value: settings.soundOn,
                onChanged: (value) {
                  ref.read(settingsNotifierProvider.notifier).updateSoundOn(value);
                },
                activeThumbColor: AppColors.primaryAccent,
              ),
            ),

            const SizedBox(height: 32),

            // زر بدء الاختبار
            SizedBox(
              width: double.infinity,
              child: common.PrimaryButton(
                text: 'Start Quiz',
                onPressed: _startQuiz,
                icon: Icons.play_arrow,
              ),
            ),

            const SizedBox(height: 16),

            // زر إعادة تعيين الإعدادات
            SizedBox(
              width: double.infinity,
              child: common.SecondaryButton(
                text: 'Reset to Defaults',
                onPressed: () {
                  ref.read(settingsNotifierProvider.notifier).resetToDefaults();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings reset to defaults'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                icon: Icons.refresh,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
