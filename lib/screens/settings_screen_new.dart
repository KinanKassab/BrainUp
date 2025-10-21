import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/common_widgets.dart' as common;
import '../l10n/app_localizations.dart';

/// شاشة الإعدادات المحسنة مع دعم الوضع عالي التباين
class SettingsScreenNew extends ConsumerWidget {
  const SettingsScreenNew({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    return common.AppScaffold(
      appBar: AppBar(
        title: Text(l10n.appSettings),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: common.AdaptiveBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إعدادات الاختبار
            _buildSection(
              context,
              l10n.quizSettings,
              [
                _buildNumberSetting(
                  context,
                  l10n.numberOfQuestions,
                  settings.numQuestions,
                  (value) => ref.read(settingsNotifierProvider.notifier)
                      .updateNumQuestions(value),
                  min: 5,
                  max: 50,
                ),
                _buildDropdownSetting(
                  context,
                  l10n.difficulty,
                  settings.difficulty,
                  {
                    'easy': l10n.easy,
                    'medium': l10n.medium,
                    'hard': l10n.hard,
                  },
                  (value) => ref.read(settingsNotifierProvider.notifier)
                      .updateDifficulty(value),
                ),
                _buildDropdownSetting(
                  context,
                  l10n.category,
                  settings.category,
                  {
                    'general': l10n.general,
                    'science': l10n.science,
                    'history': l10n.history,
                    'geography': l10n.geography,
                    'literature': l10n.literature,
                    'sports': l10n.sports,
                    'entertainment': l10n.entertainment,
                  },
                  (value) => ref.read(settingsNotifierProvider.notifier)
                      .updateCategory(value),
                ),
                _buildSwitchSetting(
                  context,
                  l10n.useApiQuestions,
                  settings.useApiQuestions,
                  (value) => ref.read(settingsNotifierProvider.notifier)
                      .updateUseApiQuestions(value),
                ),
                if (settings.useApiQuestions)
                  _buildNumberSetting(
                    context,
                    l10n.apiQuestionCount,
                    settings.apiQuestionCount,
                    (value) => ref.read(settingsNotifierProvider.notifier)
                        .updateApiQuestionCount(value),
                    min: 5,
                    max: 50,
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // إعدادات المؤقت
            _buildSection(
              context,
              l10n.timer,
              [
                _buildSwitchSetting(
                  context,
                  l10n.timerEnabled,
                  settings.timerEnabled,
                  (value) => ref.read(settingsNotifierProvider.notifier)
                      .updateTimerEnabled(value),
                ),
                if (settings.timerEnabled)
                  _buildNumberSetting(
                    context,
                    l10n.timerDuration,
                    settings.timerSeconds,
                    (value) => ref.read(settingsNotifierProvider.notifier)
                        .updateTimerSeconds(value),
                    min: 10,
                    max: 300,
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // إعدادات التطبيق
            _buildSection(
              context,
              l10n.appSettings,
              [
                _buildDropdownSetting(
                  context,
                  l10n.language,
                  settings.language,
                  {
                    'en': 'English',
                    'ar': 'العربية',
                  },
                  (value) => ref.read(settingsNotifierProvider.notifier)
                      .updateLanguage(value),
                ),
                _buildDropdownSetting(
                  context,
                  l10n.theme,
                  ref.watch(themeNotifierProvider).name,
                  {
                    'light': l10n.light,
                    'dark': l10n.dark,
                    'system': l10n.system,
                  },
                  (value) {
                    final themeMode = value == 'light' ? ThemeMode.light :
                                   value == 'dark' ? ThemeMode.dark :
                                   ThemeMode.system;
                    ref.read(themeNotifierProvider.notifier).setThemeMode(themeMode);
                  },
                ),
                _buildSwitchSetting(
                  context,
                  l10n.highContrast,
                  settings.highContrastMode,
                  (value) => ref.read(settingsNotifierProvider.notifier)
                      .updateHighContrastMode(value),
                ),
                _buildSwitchSetting(
                  context,
                  l10n.shuffleQuestions,
                  settings.shuffle,
                  (value) => ref.read(settingsNotifierProvider.notifier)
                      .updateShuffle(value),
                ),
                _buildSwitchSetting(
                  context,
                  l10n.showExplanations,
                  settings.showExplanations,
                  (value) => ref.read(settingsNotifierProvider.notifier)
                      .updateShowExplanations(value),
                ),
                _buildSwitchSetting(
                  context,
                  l10n.soundEffects,
                  settings.soundOn,
                  (value) => ref.read(settingsNotifierProvider.notifier)
                      .updateSoundOn(value),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: common.SecondaryButton(
                    text: l10n.reset,
                    onPressed: () => _showResetDialog(context, ref, l10n),
                    icon: Icons.refresh,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: common.PrimaryButton(
                    text: l10n.save,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icons.check,
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

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.textPrimaryDark 
              : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildSwitchSetting(
    BuildContext context,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.textPrimaryDark 
                  : AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberSetting(
    BuildContext context,
    String title,
    int value,
    ValueChanged<int> onChanged, {
    required int min,
    required int max,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: value > min ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surface,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryAccent,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: value < max ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    BuildContext context,
    String title,
    String value,
    Map<String, String> options,
    ValueChanged<String> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: value,
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: options.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reset),
        content: Text('Are you sure you want to reset all settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(settingsNotifierProvider.notifier).resetToDefaults();
              Navigator.of(context).pop();
            },
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }
}
