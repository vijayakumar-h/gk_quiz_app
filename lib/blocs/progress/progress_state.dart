import 'package:equatable/equatable.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitialState extends ProgressState {
  const ProgressInitialState();
}

class ProgressLoadingState extends ProgressState {
  const ProgressLoadingState();
}

class ProgressLoadedState extends ProgressState {
  final String categoryId;
  final int highestUnlockedStep;
  final Map<int, int> bestScores;
  final int totalStars;

  const ProgressLoadedState({
    required this.categoryId,
    required this.highestUnlockedStep,
    required this.bestScores,
    required this.totalStars,
  });

  @override
  List<Object?> get props => [
        categoryId,
        highestUnlockedStep,
        bestScores,
        totalStars,
      ];
}
