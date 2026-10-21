import 'package:equatable/equatable.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class LoadProgressEvent extends ProgressEvent {
  final String categoryId;
  final int totalSteps;

  const LoadProgressEvent({
    required this.categoryId,
    required this.totalSteps,
  });

  @override
  List<Object?> get props => [categoryId, totalSteps];
}

class RecordStepProgressEvent extends ProgressEvent {
  final String categoryId;
  final int stepNumber;
  final int score;
  final int totalQuestions;
  final int maxSteps;

  const RecordStepProgressEvent({
    required this.categoryId,
    required this.stepNumber,
    required this.score,
    required this.totalQuestions,
    required this.maxSteps,
  });

  @override
  List<Object?> get props => [
        categoryId,
        stepNumber,
        score,
        totalQuestions,
        maxSteps,
      ];
}

class ResetProgressEvent extends ProgressEvent {
  final String categoryId;
  final int totalSteps;

  const ResetProgressEvent({
    required this.categoryId,
    required this.totalSteps,
  });

  @override
  List<Object?> get props => [categoryId, totalSteps];
}
