import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/common_widgets.dart' as common;
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';

/// شاشة إعدادات التطبيق العامة
class AppSettingsScreen extends ConsumerStatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  ConsumerState<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends ConsumerState<AppSettingsScreen> {
  final List<String> _languages = ['en', 'ar'];

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

  Widget _buildVerticalOption(String title, bool isSelected, VoidCallback onTap) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryAccent.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryAccent : AppColors.outline,
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
    final currentMode = ref.read(themeProvider);

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
                ref.read(themeProvider.notifier).setTheme(ThemeMode.system);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 8),
            _buildVerticalOption(
              'Light',
              currentMode == ThemeMode.light,
              () {
                ref.read(themeProvider.notifier).setTheme(ThemeMode.light);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 8),
            _buildVerticalOption(
              'Dark',
              currentMode == ThemeMode.dark,
              () {
                ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
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
    final currentLanguage = ref.read(settingsProvider).language;

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
                ref.read(settingsProvider.notifier).updateLanguage('en');
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 8),
            _buildVerticalOption(
              'العربية',
              currentLanguage == 'ar',
              () {
                ref.read(settingsProvider.notifier).updateLanguage('ar');
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
    final settings = ref.watch(settingsProvider);
    final themeMode = ref.watch(themeProvider);

    return common.AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
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

            // وضع المظهر
            Builder(
              builder: (context) {
                return SettingsTile(
                  icon: Icons.brightness_6,
                  title: 'Theme',
                  subtitle: _themeLabel(themeMode),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textMuted,
                    size: 16,
                  ),
                  onTap: _showThemeDialog,
                );
              },
            ),

            const SizedBox(height: 16),

            // اللغة
            SettingsTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: settings.language == 'en' ? 'English' : 'العربية',
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textMuted,
                size: 16,
              ),
              onTap: _showLanguageDialog,
            ),

            const SizedBox(height: 16),

            // عرض التفسيرات
            SettingsTile(
              icon: Icons.lightbulb_outline,
              title: 'Show Explanations',
              subtitle: settings.showExplanations ? 'Enabled' : 'Disabled',
              trailing: Switch(
                value: settings.showExplanations,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .updateShowExplanations(value);
                },
                activeThumbColor: AppColors.primaryAccent,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// عنصر إعداد قابل لإعادة الاستخدام
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return common.AppCard(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryAccent,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 16),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
