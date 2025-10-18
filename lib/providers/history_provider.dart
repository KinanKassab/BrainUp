import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_history.dart';

part 'history_provider.g.dart';

@riverpod
class HistoryNotifier extends _$HistoryNotifier {
  static const String _key = 'quiz_history_entries_v1';

  @override
  List<QuizHistoryEntry> build() {
    _load();
    return const [];
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return;
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      state = decoded
          .map((e) => QuizHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading history: $e');
      state = const [];
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(state.map((e) => e.toJson()).toList());
      await prefs.setString(_key, raw);
    } catch (e) {
      print('Error saving history: $e');
    }
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