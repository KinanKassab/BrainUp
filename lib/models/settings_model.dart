/// نموذج بيانات إعدادات الاختبار
class SettingsModel {
  final int numQuestions;
  final String difficulty;
  final String category;
  final String level;
  final bool timerEnabled;
  final int timerSeconds;
  final bool shuffle;
  final bool showExplanations;
  final bool soundOn;
  final String language;
  final bool highContrastMode;
  final bool useApiQuestions;
  final int apiQuestionCount;

  const SettingsModel({
    this.numQuestions = 10,
    this.difficulty = 'medium',
    this.category = 'super_mind',
    this.level = '0',
    this.timerEnabled = false,
    this.timerSeconds = 30,
    this.shuffle = true,
    this.showExplanations = true,
    this.soundOn = false,
    this.language = 'en',
    this.highContrastMode = false,
    this.useApiQuestions = true,
    this.apiQuestionCount = 10,
  });

  /// إنشاء نسخة جديدة من النموذج مع تعديلات
  SettingsModel copyWith({
    int? numQuestions,
    String? difficulty,
    String? category,
    String? level,
    bool? timerEnabled,
    int? timerSeconds,
    bool? shuffle,
    bool? showExplanations,
    bool? soundOn,
    String? language,
    bool? highContrastMode,
    bool? useApiQuestions,
    int? apiQuestionCount,
  }) {
    return SettingsModel(
      numQuestions: numQuestions ?? this.numQuestions,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      level: level ?? this.level,
      timerEnabled: timerEnabled ?? this.timerEnabled,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      shuffle: shuffle ?? this.shuffle,
      showExplanations: showExplanations ?? this.showExplanations,
      soundOn: soundOn ?? this.soundOn,
      language: language ?? this.language,
      highContrastMode: highContrastMode ?? this.highContrastMode,
      useApiQuestions: useApiQuestions ?? this.useApiQuestions,
      apiQuestionCount: apiQuestionCount ?? this.apiQuestionCount,
    );
  }

  /// تحويل النموذج إلى Map للتخزين
  Map<String, dynamic> toJson() {
    return {
      'numQuestions': numQuestions,
      'difficulty': difficulty,
      'category': category,
      'level': level,
      'timerEnabled': timerEnabled,
      'timerSeconds': timerSeconds,
      'shuffle': shuffle,
      'showExplanations': showExplanations,
      'soundOn': soundOn,
      'language': language,
      'highContrastMode': highContrastMode,
      'useApiQuestions': useApiQuestions,
      'apiQuestionCount': apiQuestionCount,
    };
  }

  /// إنشاء النموذج من Map
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      numQuestions: json['numQuestions'] ?? 10,
      difficulty: json['difficulty'] ?? 'medium',
      category: json['category'] ?? 'super_mind',
      level: json['level'] ?? '0',
      timerEnabled: json['timerEnabled'] ?? false,
      timerSeconds: json['timerSeconds'] ?? 30,
      shuffle: json['shuffle'] ?? true,
      showExplanations: json['showExplanations'] ?? true,
      soundOn: json['soundOn'] ?? false,
      language: json['language'] ?? 'en',
      highContrastMode: json['highContrastMode'] ?? false,
      useApiQuestions: json['useApiQuestions'] ?? true,
      apiQuestionCount: json['apiQuestionCount'] ?? 10,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsModel &&
        other.numQuestions == numQuestions &&
        other.difficulty == difficulty &&
        other.category == category &&
        other.level == level &&
        other.timerEnabled == timerEnabled &&
        other.timerSeconds == timerSeconds &&
        other.shuffle == shuffle &&
        other.showExplanations == showExplanations &&
        other.soundOn == soundOn &&
        other.language == language &&
        other.highContrastMode == highContrastMode &&
        other.useApiQuestions == useApiQuestions &&
        other.apiQuestionCount == apiQuestionCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      numQuestions,
      difficulty,
      category,
      level,
      timerEnabled,
      timerSeconds,
      shuffle,
      showExplanations,
      soundOn,
      language,
      highContrastMode,
      useApiQuestions,
      apiQuestionCount,
    );
  }
}
