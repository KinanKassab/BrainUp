import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// مقدم خدمة إدارة المظهر
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';

  /// تحميل المظهر من التخزين المحلي
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);
      if (themeIndex != null) {
        state = ThemeMode.values[themeIndex];
      }
    } catch (e) {
      // في حالة الخطأ، استخدم المظهر الافتراضي
      state = ThemeMode.dark;
    }
  }

  /// حفظ المظهر في التخزين المحلي
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, state.index);
    } catch (e) {
      // يمكن إضافة معالجة الأخطاء هنا
    }
  }

  /// تبديل المظهر
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveTheme();
  }

  /// تعيين المظهر
  void setTheme(ThemeMode theme) {
    state = theme;
    _saveTheme();
  }
}

/// مقدم خدمة المظهر
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

/// ألوان التطبيق المخصصة
class AppColors {
  // الألوان الأساسية
  static const Color primaryAccent = Color(0xFF2EE6C9);
  static const Color ctaPurple = Color(0xFF6F45FF);
  static const Color bgCard = Color(0xFF1A1130);
  static const Color scoreYellow = Color(0xFFFFC857);
  static const Color logoPink = Color(0xFFFF4FB0);
  static const Color textPrimary = Color(0xFFE6F7FF);
  static const Color textMuted = Color(0xFFA6A0C3);

  // ألوان الخلفية
  static const Color backgroundStart = Color(0xFF0E0820);
  static const Color backgroundEnd = Color(0xFF1C1330);

  // ألوان الحالة
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // ألوان إضافية
  static const Color surface = Color(0xFF2A1F3D);
  static const Color onSurface = Color(0xFFE6F7FF);
  static const Color outline = Color(0xFF3A2F4D);
}

/// موضوع التطبيق المظلم
final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryAccent,
    secondary: AppColors.ctaPurple,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    outline: AppColors.outline,
    error: AppColors.error,
  ),
  scaffoldBackgroundColor: AppColors.backgroundStart,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: AppColors.textPrimary,
  ),
  cardTheme: CardThemeData(
    color: AppColors.bgCard,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.ctaPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.textPrimary,
      side: const BorderSide(color: AppColors.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryAccent;
      }
      return AppColors.textMuted;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryAccent.withValues(alpha: 0.3);
      }
      return AppColors.outline;
    }),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: AppColors.primaryAccent,
    inactiveTrackColor: AppColors.outline,
    thumbColor: AppColors.primaryAccent,
    overlayColor: AppColors.primaryAccent.withValues(alpha: 0.2),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      color: AppColors.textMuted,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      color: AppColors.textMuted,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
  ),
);

/// ألوان التطبيق للوضع المضيء
class LightAppColors {
  // الألوان الأساسية
  static const Color primaryAccent = Color(0xFF2EE6C9);
  static const Color ctaPurple = Color(0xFF6F45FF);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color scoreYellow = Color(0xFFFFC857);
  static const Color logoPink = Color(0xFFFF4FB0);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF666666);

  // ألوان الخلفية
  static const Color backgroundStart = Color(0xFFF8F9FA);
  static const Color backgroundEnd = Color(0xFFE9ECEF);

  // ألوان الحالة
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // ألوان إضافية
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color outline = Color(0xFFE0E0E0);
}

/// موضوع التطبيق المضيء
final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: LightAppColors.primaryAccent,
    secondary: LightAppColors.ctaPurple,
    surface: LightAppColors.surface,
    onSurface: LightAppColors.onSurface,
    outline: LightAppColors.outline,
    error: LightAppColors.error,
  ),
  scaffoldBackgroundColor: LightAppColors.backgroundStart,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: LightAppColors.textPrimary,
  ),
  cardTheme: CardThemeData(
    color: LightAppColors.bgCard,
    elevation: 2,
    shadowColor: Colors.black.withValues(alpha: 0.1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: LightAppColors.ctaPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      elevation: 2,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: LightAppColors.textPrimary,
      side: const BorderSide(color: LightAppColors.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: LightAppColors.primaryAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return LightAppColors.primaryAccent;
      }
      return LightAppColors.textMuted;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return LightAppColors.primaryAccent.withValues(alpha: 0.3);
      }
      return LightAppColors.outline;
    }),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: LightAppColors.primaryAccent,
    inactiveTrackColor: LightAppColors.outline,
    thumbColor: LightAppColors.primaryAccent,
    overlayColor: LightAppColors.primaryAccent.withValues(alpha: 0.2),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      color: LightAppColors.textMuted,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: LightAppColors.textPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      color: LightAppColors.textMuted,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
  ),
);
