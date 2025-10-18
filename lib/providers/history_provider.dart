import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_history.dart';

/// مقدم خدمة محفوظات الاختبارات
class HistoryNotifier extends StateNotifier<List<QuizHistoryEntry>> {
  HistoryNotifier() : super(const []) {
    _load();
  }

  static const String _key = 'quiz_history_entries_v1';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    state = decoded
        .map((e) => QuizHistoryEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  Future<void> addEntry(QuizHistoryEntry entry) async {
    final List<QuizHistoryEntry> updated = List.of(state);
    updated.insert(0, entry);
    // احتفظ فقط بآخر 200 سجل لتجنب التضخم
    state = updated.take(200).toList();
    await _save();
  }

  Future<void> clearAll() async {
    state = const [];
    await _save();
  }
}

/// موفر محفوظات الاختبارات
final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<QuizHistoryEntry>>(
      (ref) => HistoryNotifier(),
    );
