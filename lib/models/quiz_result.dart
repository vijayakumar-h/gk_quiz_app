import 'quiz_category.dart';

class QuizResult {
  final QuizCategory category;
  final int totalQuestions;
  final int correctCount;
  final Map<int, int> answers; // question index -> chosen option (-1 if timed out)
  final int timeSpentSeconds;

  const QuizResult({
    required this.category,
    required this.totalQuestions,
    required this.correctCount,
    required this.answers,
    required this.timeSpentSeconds,
  });

  double get scorePercentage =>
      totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0.0;

  int get wrongCount => totalQuestions - correctCount;

  String get performanceTitle {
    final pct = scorePercentage;
    if (pct >= 90) return 'Trivia Master!';
    if (pct >= 75) return 'Great Job!';
    if (pct >= 50) return 'Good Effort!';
    return 'Keep Practicing!';
  }

  String get performanceMessage {
    final pct = scorePercentage;
    if (pct >= 90) {
      return 'Incredible knowledge! You aced this quiz with flying colors.';
    }
    if (pct >= 75) {
      return 'Impressive score! You clearly know your facts well.';
    }
    if (pct >= 50) {
      return 'Nice attempt! Review the answers below to master this topic.';
    }
    return 'Don\'t give up! Trivia is all about learning something new every day.';
  }
}
