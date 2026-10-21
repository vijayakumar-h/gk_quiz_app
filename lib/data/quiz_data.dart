import 'dart:convert';
import 'package:flutter/services.dart';

class QuizData {
  static const int questionsPerStep = 10;
  static List<Map<String, dynamic>>? _cachedCategories;

  /// Asset paths for each separated category JSON file.
  static const List<String> categoryAssetPaths = [
    'assets/data/science.json',
    'assets/data/history_geo.json',
    'assets/data/technology.json',
    'assets/data/sports.json',
    'assets/data/general_trivia.json',
  ];

  /// Loads all categories and questions from individual JSON assets.
  static Future<List<Map<String, dynamic>>> loadCategories() async {
    if (_cachedCategories != null && _cachedCategories!.isNotEmpty) {
      return _cachedCategories!;
    }
    final List<Map<String, dynamic>> loaded = [];
    for (final path in categoryAssetPaths) {
      final jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> data = jsonDecode(jsonString);
      loaded.add(data);
    }
    _cachedCategories = loaded;
    return _cachedCategories!;
  }

  /// Loads a specific category by its ID directly from its dedicated JSON file.
  static Future<Map<String, dynamic>> loadCategory(String id) async {
    final path = 'assets/data/$id.json';
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Sets categories manually (useful in tests or when loaded from external source).
  static void setCategories(List<Map<String, dynamic>> categories) {
    _cachedCategories = categories;
  }

  /// Returns synchronous cached categories (or empty if not loaded yet).
  static List<Map<String, dynamic>> get cachedCategories =>
      _cachedCategories ?? [];

  /// Finds a category map by its ID from cached categories.
  static Map<String, dynamic>? getCategoryById(String id) {
    if (_cachedCategories == null) return null;
    return _cachedCategories!.firstWhere(
      (cat) => cat['id'] == id,
      orElse: () => _cachedCategories!.first,
    );
  }

  /// Calculate total steps for a category (each step has 10 questions).
  static int getTotalSteps(Map<String, dynamic> category) {
    final List questions = (category['questions'] as List?) ?? [];
    return (questions.length / questionsPerStep).ceil();
  }

  /// Retrieves a 10-question slice for the requested stepNumber (1-based index).
  static List<Map<String, dynamic>> getQuestionsForStep(
    Map<String, dynamic> category,
    int stepNumber,
  ) {
    final List questions = (category['questions'] as List?) ?? [];
    final totalSteps = getTotalSteps(category);
    if (stepNumber < 1 || stepNumber > totalSteps) {
      return [];
    }
    final startIndex = (stepNumber - 1) * questionsPerStep;
    final endIndex = (startIndex + questionsPerStep).clamp(0, questions.length);
    return questions
        .sublist(startIndex, endIndex)
        .cast<Map<String, dynamic>>();
  }
}
