import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

/// خدمة API لجلب الأسئلة من Open Trivia DB
class ApiService {
  static const String _baseUrl = 'https://opentdb.com/api.php';
  
  /// جلب الأسئلة من API
  static Future<List<Question>> fetchQuestions({
    required int amount,
    required String category,
    required String difficulty,
  }) async {
    try {
      // تحويل الفئة إلى معرف API
      final categoryId = _getCategoryId(category);
      
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'amount': amount.toString(),
        'category': categoryId.toString(),
        'difficulty': difficulty,
        'type': 'multiple',
        'encode': 'url3986',
      });

      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['response_code'] == 0) {
          final results = data['results'] as List;
          return results.map((item) => _parseQuestion(item)).toList();
        } else {
          throw Exception('API returned error: ${data['response_code']}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch questions: $e');
    }
  }
  
  /// تحويل الفئة إلى معرف API
  static int _getCategoryId(String category) {
    switch (category.toLowerCase()) {
      case 'general':
        return 9; // General Knowledge
      case 'science':
        return 17; // Science & Nature
      case 'history':
        return 23; // History
      case 'geography':
        return 22; // Geography
      case 'literature':
        return 10; // Books
      case 'sports':
        return 21; // Sports
      case 'entertainment':
        return 11; // Film
      default:
        return 9; // General Knowledge as default
    }
  }
  
  /// تحليل سؤال من API
  static Question _parseQuestion(Map<String, dynamic> data) {
    // فك تشفير النص
    final question = Uri.decodeComponent(data['question']);
    final correctAnswer = Uri.decodeComponent(data['correct_answer']);
    final incorrectAnswers = (data['incorrect_answers'] as List)
        .map((answer) => Uri.decodeComponent(answer))
        .toList();
    
    // خلط الخيارات
    final allOptions = [correctAnswer, ...incorrectAnswers]..shuffle();
    final correctIndex = allOptions.indexOf(correctAnswer);
    
    return Question(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: question,
      options: allOptions,
      correctAnswerIndex: correctIndex,
      explanation: _generateExplanation(data['category'], data['difficulty']),
      category: _mapCategoryFromApi(data['category']),
      difficulty: data['difficulty'],
    );
  }
  
  /// إنشاء تفسير للسؤال
  static String _generateExplanation(String category, String difficulty) {
    final difficultyText = difficulty == 'easy' ? 'basic' : 
                          difficulty == 'medium' ? 'intermediate' : 'advanced';
    return 'This is a $difficultyText level question from the $category category.';
  }
  
  /// تحويل فئة API إلى فئة التطبيق
  static String _mapCategoryFromApi(String apiCategory) {
    switch (apiCategory.toLowerCase()) {
      case 'general knowledge':
        return 'general';
      case 'science & nature':
        return 'science';
      case 'history':
        return 'history';
      case 'geography':
        return 'geography';
      case 'books':
        return 'literature';
      case 'sports':
        return 'sports';
      case 'film':
        return 'entertainment';
      default:
        return 'general';
    }
  }
}
