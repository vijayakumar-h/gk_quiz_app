import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class StartQuizEvent extends QuizEvent {
  final Map<String, dynamic> category;
  final int? stepNumber;
  final List<Map<String, dynamic>> questions;

  const StartQuizEvent({
    required this.category,
    this.stepNumber,
    required this.questions,
  });

  @override
  List<Object?> get props => [category, stepNumber, questions];
}

class SelectOptionEvent extends QuizEvent {
  final int optionIndex;

  const SelectOptionEvent(this.optionIndex);

  @override
  List<Object?> get props => [optionIndex];
}

class TimerTickEvent extends QuizEvent {
  const TimerTickEvent();
}

class TimerExpiredEvent extends QuizEvent {
  const TimerExpiredEvent();
}

class NextQuestionEvent extends QuizEvent {
  const NextQuestionEvent();
}
