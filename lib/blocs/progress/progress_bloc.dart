import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/quiz_progress_service.dart';
import 'progress_event.dart';
import 'progress_state.dart';

export 'progress_event.dart';
export 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc() : super(const ProgressInitialState()) {
    on<LoadProgressEvent>(_onLoadProgress);
    on<RecordStepProgressEvent>(_onRecordStepProgress);
    on<ResetProgressEvent>(_onResetProgress);
  }

  Future<void> _onLoadProgress(
    LoadProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(const ProgressLoadingState());
    final highest =
        await QuizProgressService.getHighestUnlockedStep(event.categoryId);
    final scores = <int, int>{};
    for (int i = 1; i <= event.totalSteps; i++) {
      scores[i] =
          await QuizProgressService.getBestScore(event.categoryId, i);
    }
    final stars = _calculateStars(scores);

    emit(ProgressLoadedState(
      categoryId: event.categoryId,
      highestUnlockedStep: highest,
      bestScores: scores,
      totalStars: stars,
    ));
  }

  Future<void> _onRecordStepProgress(
    RecordStepProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    await QuizProgressService.recordStepResult(
      categoryId: event.categoryId,
      stepNumber: event.stepNumber,
      score: event.score,
      totalQuestions: event.totalQuestions,
      maxSteps: event.maxSteps,
    );

    // Reload state after saving
    final highest =
        await QuizProgressService.getHighestUnlockedStep(event.categoryId);
    final scores = <int, int>{};
    for (int i = 1; i <= event.maxSteps; i++) {
      scores[i] =
          await QuizProgressService.getBestScore(event.categoryId, i);
    }
    final stars = _calculateStars(scores);

    emit(ProgressLoadedState(
      categoryId: event.categoryId,
      highestUnlockedStep: highest,
      bestScores: scores,
      totalStars: stars,
    ));
  }

  Future<void> _onResetProgress(
    ResetProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(const ProgressLoadingState());
    await QuizProgressService.resetCategoryProgress(event.categoryId);

    final scores = <int, int>{};
    for (int i = 1; i <= event.totalSteps; i++) {
      scores[i] = 0;
    }

    emit(ProgressLoadedState(
      categoryId: event.categoryId,
      highestUnlockedStep: 1,
      bestScores: scores,
      totalStars: 0,
    ));
  }

  int _calculateStars(Map<int, int> scores) {
    int total = 0;
    for (final score in scores.values) {
      if (score >= 9) {
        total += 3;
      } else if (score >= 7) {
        total += 2;
      } else if (score >= 6) {
        total += 1;
      }
    }
    return total;
  }
}
