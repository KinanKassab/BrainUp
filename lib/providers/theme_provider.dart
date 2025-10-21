import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void setTheme(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

// الألوان المخصصة للتطبيق
class AppColors {
  // الألوان الأساسية
  static const Color primaryAccent = Color(0xFF6366F1);
  static const Color secondaryAccent = Color(0xFF8B5CF6);
  static const Color logoPink = Color(0xFFEC4899);
  static const Color ctaPurple = Color(0xFF8B5CF6);
  
  // ألوان النص - Light Mode
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  
  // ألوان النص - Dark Mode
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFF1F5F9);
  static const Color textMutedDark = Color(0xFFE2E8F0);
  
  // ألوان الخلفية - Light Mode
  static const Color bgPrimary = Color(0xFFF9FAFB);
  static const Color bgSecondary = Color(0xFFFFFFFF);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF3F4F6);
  static const Color backgroundStart = Color(0xFFF9FAFB);
  static const Color backgroundEnd = Color(0xFFFFFFFF);
  
  // ألوان الخلفية - Dark Mode
  static const Color bgPrimaryDark = Color(0xFF0F172A);
  static const Color bgSecondaryDark = Color(0xFF1E293B);
  static const Color bgCardDark = Color(0xFF1E293B);
  static const Color surfaceDark = Color(0xFF334155);
  static const Color backgroundStartDark = Color(0xFF0F172A);
  static const Color backgroundEndDark = Color(0xFF1E293B);
  
  // ألوان الحدود
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF475569);
  
  // ألوان الحالة
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // ألوان إضافية
  static const Color scoreYellow = Color(0xFFF59E0B);
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);
  static const Color outline = Color(0xFFE5E7EB);
  
  // التدرجات الجديدة
  static const List<Color> primaryGradient = [Color(0xFF6366F1), Color(0xFF8B5CF6)];
  static const List<Color> secondaryGradient = [Color(0xFFEC4899), Color(0xFF8B5CF6)];
  static const List<Color> successGradient = [Color(0xFF10B981), Color(0xFF34D399)];
  static const List<Color> warningGradient = [Color(0xFFF59E0B), Color(0xFFFBBF24)];
  
  // Glassmorphism
  static Color get glassBackground => Colors.white.withValues(alpha: 0.1);
  static Color get glassBorder => Colors.white.withValues(alpha: 0.2);
  static Color get glassBackgroundDark => Colors.white.withValues(alpha: 0.05);
  static Color get glassBorderDark => Colors.white.withValues(alpha: 0.1);
  
  // ألوان ديناميكية حسب النتيجة
  static List<Color> getScoreGradient(double percentage) {
    if (percentage >= 80) return successGradient;
    if (percentage >= 60) return warningGradient;
    return [error, Color(0xFFF87171)];
  }
}

// الثيم الفاتح
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryAccent,
    secondary: AppColors.secondaryAccent,
    surface: AppColors.bgCard,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimary,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.bgPrimary,
  cardColor: AppColors.bgCard,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: AppColors.textPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryAccent,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryAccent,
      side: const BorderSide(color: AppColors.primaryAccent),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.bgCard,
    elevation: 2,
    shadowColor: AppColors.shadowLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.borderLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.borderLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
);

// الثيم الداكن
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryAccent,
    secondary: AppColors.secondaryAccent,
    surface: AppColors.bgCardDark,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimaryDark,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.bgPrimaryDark,
  cardColor: AppColors.bgCardDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryAccent,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryAccent,
      side: const BorderSide(color: AppColors.primaryAccent),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.bgCardDark,
    elevation: 4,
    shadowColor: AppColors.shadowDark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.borderDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.borderDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
);