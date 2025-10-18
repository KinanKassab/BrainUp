import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'BrainUp Quiz'**
  String get appTitle;

  /// Welcome screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome to BrainUp'**
  String get welcomeTitle;

  /// Welcome screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Test your knowledge and challenge yourself!'**
  String get welcomeSubtitle;

  /// Button to start playing quiz
  ///
  /// In en, this message translates to:
  /// **'Play Now'**
  String get playNow;

  /// About button text
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Statistics button text
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get stats;

  /// Settings button text
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Quiz settings screen title
  ///
  /// In en, this message translates to:
  /// **'Quiz Settings'**
  String get quizSettings;

  /// Label for number of questions setting
  ///
  /// In en, this message translates to:
  /// **'Number of Questions'**
  String get numberOfQuestions;

  /// Label for difficulty setting
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// Label for category setting
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Label for timer setting
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// Label for timer enabled setting
  ///
  /// In en, this message translates to:
  /// **'Enable Timer'**
  String get timerEnabled;

  /// Label for timer duration setting
  ///
  /// In en, this message translates to:
  /// **'Timer Duration (seconds)'**
  String get timerDuration;

  /// Label for shuffle questions setting
  ///
  /// In en, this message translates to:
  /// **'Shuffle Questions'**
  String get shuffleQuestions;

  /// Label for show explanations setting
  ///
  /// In en, this message translates to:
  /// **'Show Explanations'**
  String get showExplanations;

  /// Label for sound effects setting
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// Label for language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label for high contrast mode setting
  ///
  /// In en, this message translates to:
  /// **'High Contrast Mode'**
  String get highContrast;

  /// Easy difficulty level
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// Medium difficulty level
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Hard difficulty level
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// General knowledge category
  ///
  /// In en, this message translates to:
  /// **'General Knowledge'**
  String get general;

  /// Science category
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get science;

  /// History category
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Geography category
  ///
  /// In en, this message translates to:
  /// **'Geography'**
  String get geography;

  /// Literature category
  ///
  /// In en, this message translates to:
  /// **'Literature'**
  String get literature;

  /// Sports category
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// Entertainment category
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// Button to start the quiz
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get startQuiz;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Finish button text
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Explanation label
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanation;

  /// Correct answer feedback
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// Incorrect answer feedback
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get incorrect;

  /// Time up message
  ///
  /// In en, this message translates to:
  /// **'Time\'s up!'**
  String get timeUp;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No internet connection error message
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Failed to load questions error message
  ///
  /// In en, this message translates to:
  /// **'Failed to load questions'**
  String get failedToLoadQuestions;

  /// Quiz completed message
  ///
  /// In en, this message translates to:
  /// **'Quiz Completed!'**
  String get quizCompleted;

  /// Your score label
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get yourScore;

  /// Correct answers label
  ///
  /// In en, this message translates to:
  /// **'Correct Answers'**
  String get correctAnswers;

  /// Total questions label
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get totalQuestions;

  /// Percentage label
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// Play again button text
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// View results button text
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get viewResults;

  /// Back to home button text
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// Quiz history title
  ///
  /// In en, this message translates to:
  /// **'Quiz History'**
  String get quizHistory;

  /// No quiz history message
  ///
  /// In en, this message translates to:
  /// **'No quiz history yet'**
  String get noHistory;

  /// Clear history button text
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// Confirm clear history message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all quiz history?'**
  String get confirmClearHistory;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// App settings title
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// About app title
  ///
  /// In en, this message translates to:
  /// **'About BrainUp'**
  String get aboutApp;

  /// About app description
  ///
  /// In en, this message translates to:
  /// **'BrainUp is a fun and interactive quiz app that helps you learn and test your knowledge across various categories. Customize your quiz experience with flexible settings and track your progress.'**
  String get aboutDescription;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Developed by label
  ///
  /// In en, this message translates to:
  /// **'Developed by'**
  String get developedBy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
