import 'package:equatable/equatable.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitialState extends QuizState {
  const QuizInitialState();
}

class QuizActiveState extends QuizState {
  final Map<String, dynamic> category;
  final int? stepNumber;
  final List<Map<String, dynamic>> questions;
  final int currentIndex;
  final int secondsRemaining;
  final int? selectedOptionIndex;
  final bool isAnswered;
  final int correctCount;
  final Map<int, int> userAnswers;
  final int timeSpentSeconds;

  const QuizActiveState({
    required this.category,
    this.stepNumber,
    required this.questions,
    required this.currentIndex,
    required this.secondsRemaining,
    this.selectedOptionIndex,
    required this.isAnswered,
    required this.correctCount,
    required this.userAnswers,
    required this.timeSpentSeconds,
  });

  Map<String, dynamic> get currentQuestion => questions[currentIndex];
  int get totalQuestions => questions.length;
  bool get isLastQuestion => currentIndex == questions.length - 1;
  double get progress => (currentIndex + 1) / totalQuestions;

  QuizActiveState copyWith({
    Map<String, dynamic>? category,
    int? stepNumber,
    List<Map<String, dynamic>>? questions,
    int? currentIndex,
    int? secondsRemaining,
    int? selectedOptionIndex,
    bool? isAnswered,
    int? correctCount,
    Map<int, int>? userAnswers,
    int? timeSpentSeconds,
  }) {
    return QuizActiveState(
      category: category ?? this.category,
      stepNumber: stepNumber ?? this.stepNumber,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      selectedOptionIndex: selectedOptionIndex,
      isAnswered: isAnswered ?? this.isAnswered,
      correctCount: correctCount ?? this.correctCount,
      userAnswers: userAnswers ?? this.userAnswers,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
    );
  }

  @override
  List<Object?> get props => [
        category,
        stepNumber,
        questions,
        currentIndex,
        secondsRemaining,
        selectedOptionIndex,
        isAnswered,
        correctCount,
        userAnswers,
        timeSpentSeconds,
      ];
}

class QuizFinishedState extends QuizState {
  final Map<String, dynamic> category;
  final int? stepNumber;
  final List<Map<String, dynamic>> questions;
  final int totalQuestions;
  final int correctCount;
  final int wrongCount;
  final double scorePercentage;
  final bool isQualified;
  final int stars;
  final int timeSpentSeconds;
  final Map<int, int> userAnswers;

  const QuizFinishedState({
    required this.category,
    this.stepNumber,
    required this.questions,
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.scorePercentage,
    required this.isQualified,
    required this.stars,
    required this.timeSpentSeconds,
    required this.userAnswers,
  });

  bool get isStepMode => stepNumber != null;

  String get performanceTitle {
    if (isStepMode) {
      if (isQualified) {
        return stars == 3
            ? 'Outstanding! 3 Stars ⭐⭐⭐'
            : (stars == 2 ? 'Great Job! 2 Stars ⭐⭐' : 'Step Cleared! 1 Star ⭐');
      } else {
        return 'Step Not Cleared';
      }
    }
    if (scorePercentage >= 90) return 'Trivia Master!';
    if (scorePercentage >= 75) return 'Great Job!';
    if (scorePercentage >= 50) return 'Good Effort!';
    return 'Keep Practicing!';
  }

  String get performanceMessage {
    if (isStepMode) {
      if (isQualified) {
        return 'Congratulations! You qualified for the next step.';
      } else {
        return 'You need at least 6 out of 10 to qualify for the next step. Give it another shot!';
      }
    }
    if (scorePercentage >= 90) {
      return 'Incredible knowledge! You aced this quiz with flying colors.';
    }
    if (scorePercentage >= 75) {
      return 'Impressive score! You clearly know your facts well.';
    }
    if (scorePercentage >= 50) {
      return 'Nice attempt! Review the answers below to master this topic.';
    }
    return 'Don\'t give up! Trivia is all about learning something new every day.';
  }

  @override
  List<Object?> get props => [
        category,
        stepNumber,
        questions,
        totalQuestions,
        correctCount,
        wrongCount,
        scorePercentage,
        isQualified,
        stars,
        timeSpentSeconds,
        userAnswers,
      ];
}
