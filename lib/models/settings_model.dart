/// نموذج بيانات إعدادات الاختبار
class SettingsModel {
  final int numQuestions;
  final String difficulty;
  final String category;
  final bool timerEnabled;
  final int timerSeconds;
  final bool shuffle;
  final bool showExplanations;
  final bool soundOn;
  final String language;

  const SettingsModel({
    this.numQuestions = 10,
    this.difficulty = 'medium',
    this.category = 'general',
    this.timerEnabled = false,
    this.timerSeconds = 30,
    this.shuffle = true,
    this.showExplanations = true,
    this.soundOn = false,
    this.language = 'en',
  });

  /// إنشاء نسخة جديدة من النموذج مع تعديلات
  SettingsModel copyWith({
    int? numQuestions,
    String? difficulty,
    String? category,
    bool? timerEnabled,
    int? timerSeconds,
    bool? shuffle,
    bool? showExplanations,
    bool? soundOn,
    String? language,
  }) {
    return SettingsModel(
      numQuestions: numQuestions ?? this.numQuestions,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      timerEnabled: timerEnabled ?? this.timerEnabled,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      shuffle: shuffle ?? this.shuffle,
      showExplanations: showExplanations ?? this.showExplanations,
      soundOn: soundOn ?? this.soundOn,
      language: language ?? this.language,
    );
  }

  /// تحويل النموذج إلى Map للتخزين
  Map<String, dynamic> toJson() {
    return {
      'numQuestions': numQuestions,
      'difficulty': difficulty,
      'category': category,
      'timerEnabled': timerEnabled,
      'timerSeconds': timerSeconds,
      'shuffle': shuffle,
      'showExplanations': showExplanations,
      'soundOn': soundOn,
      'language': language,
    };
  }

  /// إنشاء النموذج من Map
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      numQuestions: json['numQuestions'] ?? 10,
      difficulty: json['difficulty'] ?? 'medium',
      category: json['category'] ?? 'general',
      timerEnabled: json['timerEnabled'] ?? false,
      timerSeconds: json['timerSeconds'] ?? 30,
      shuffle: json['shuffle'] ?? true,
      showExplanations: json['showExplanations'] ?? true,
      soundOn: json['soundOn'] ?? false,
      language: json['language'] ?? 'en',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsModel &&
        other.numQuestions == numQuestions &&
        other.difficulty == difficulty &&
        other.category == category &&
        other.timerEnabled == timerEnabled &&
        other.timerSeconds == timerSeconds &&
        other.shuffle == shuffle &&
        other.showExplanations == showExplanations &&
        other.soundOn == soundOn &&
        other.language == language;
  }

  @override
  int get hashCode {
    return Object.hash(
      numQuestions,
      difficulty,
      category,
      timerEnabled,
      timerSeconds,
      shuffle,
      showExplanations,
      soundOn,
      language,
    );
  }
}
