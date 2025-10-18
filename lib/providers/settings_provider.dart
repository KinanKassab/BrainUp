import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';

/// مقدم خدمة إدارة الإعدادات
class SettingsNotifier extends StateNotifier<SettingsModel> {
  SettingsNotifier() : super(const SettingsModel()) {
    _loadSettings();
  }

  static const String _settingsKey = 'quiz_settings';

  /// تحميل الإعدادات من التخزين المحلي
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
        state = SettingsModel.fromJson(settingsMap);
      }
    } catch (e) {
      // في حالة الخطأ، استخدم الإعدادات الافتراضية
      state = const SettingsModel();
    }
  }

  /// حفظ الإعدادات في التخزين المحلي
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(state.toJson());
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      // يمكن إضافة معالجة الأخطاء هنا
      developer.log(
        'Error saving settings',
        name: 'SettingsNotifier',
        error: e,
      );
    }
  }

  /// تحديث عدد الأسئلة
  void updateNumQuestions(int numQuestions) {
    state = state.copyWith(numQuestions: numQuestions);
    _saveSettings();
  }

  /// تحديث مستوى الصعوبة
  void updateDifficulty(String difficulty) {
    state = state.copyWith(difficulty: difficulty);
    _saveSettings();
  }

  /// تحديث الفئة
  void updateCategory(String category) {
    state = state.copyWith(category: category);
    _saveSettings();
  }

  /// تحديث تفعيل المؤقت
  void updateTimerEnabled(bool enabled) {
    state = state.copyWith(timerEnabled: enabled);
    _saveSettings();
  }

  /// تحديث مدة المؤقت
  void updateTimerSeconds(int seconds) {
    state = state.copyWith(timerSeconds: seconds);
    _saveSettings();
  }

  /// تحديث خلط الأسئلة
  void updateShuffle(bool shuffle) {
    state = state.copyWith(shuffle: shuffle);
    _saveSettings();
  }

  /// تحديث عرض التفسيرات
  void updateShowExplanations(bool show) {
    state = state.copyWith(showExplanations: show);
    _saveSettings();
  }

  /// تحديث الصوت
  void updateSoundOn(bool soundOn) {
    state = state.copyWith(soundOn: soundOn);
    _saveSettings();
  }

  /// تحديث اللغة
  void updateLanguage(String language) {
    state = state.copyWith(language: language);
    _saveSettings();
  }

  /// إعادة تعيين الإعدادات للقيم الافتراضية
  void resetToDefaults() {
    state = const SettingsModel();
    _saveSettings();
  }
}

/// مقدم خدمة الإعدادات
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsModel>(
  (ref) => SettingsNotifier(),
);
