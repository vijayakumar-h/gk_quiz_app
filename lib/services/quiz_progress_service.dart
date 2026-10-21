import 'package:shared_preferences/shared_preferences.dart';

class QuizProgressService {
  static const String _prefixUnlocked = 'gk_quiz_unlocked_step_';
  static const String _prefixScore = 'gk_quiz_best_score_';

  /// Returns the highest step number (1-based) unlocked for a given category.
  /// Step 1 is always unlocked by default.
  static Future<int> getHighestUnlockedStep(String categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_prefixUnlocked$categoryId') ?? 1;
  }

  /// Returns the best score (number of correct answers) for a specific step.
  static Future<int> getBestScore(String categoryId, int stepNumber) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_prefixScore${categoryId}_$stepNumber') ?? 0;
  }

  /// Check whether a specific step is unlocked.
  static Future<bool> isStepUnlocked(String categoryId, int stepNumber) async {
    if (stepNumber <= 1) return true;
    final highest = await getHighestUnlockedStep(categoryId);
    return stepNumber <= highest;
  }

  /// Save the result of a quiz step. If passed (>= 60%), unlocks the next step.
  /// Returns true if a new step was unlocked.
  static Future<bool> recordStepResult({
    required String categoryId,
    required int stepNumber,
    required int score,
    required int totalQuestions,
    required int maxSteps,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Update best score
    final currentBest = prefs.getInt('$_prefixScore${categoryId}_$stepNumber') ?? 0;
    if (score > currentBest) {
      await prefs.setInt('$_prefixScore${categoryId}_$stepNumber', score);
    }

    // Check passing threshold (60% i.e. 6/10)
    final isPassed = totalQuestions > 0 && (score / totalQuestions) >= 0.6;
    if (!isPassed) return false;

    // Check if we need to unlock the next step
    final currentHighest = prefs.getInt('$_prefixUnlocked$categoryId') ?? 1;
    if (stepNumber >= currentHighest && currentHighest < maxSteps) {
      final nextStep = currentHighest + 1;
      await prefs.setInt('$_prefixUnlocked$categoryId', nextStep);
      return true;
    }

    return false;
  }

  /// Reset progress for a specific category
  static Future<void> resetCategoryProgress(String categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefixUnlocked$categoryId');
    // Clear best scores for steps 1..30
    for (int i = 1; i <= 30; i++) {
      await prefs.remove('$_prefixScore${categoryId}_$i');
    }
  }
}
