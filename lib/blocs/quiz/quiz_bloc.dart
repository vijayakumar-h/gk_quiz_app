import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/quiz_data.dart';
import '../../services/quiz_progress_service.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

export 'quiz_event.dart';
export 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  static const int questionDuration = 20;
  Timer? _questionTimer;

  QuizBloc() : super(const QuizInitialState()) {
    on<StartQuizEvent>(_onStartQuiz);
    on<SelectOptionEvent>(_onSelectOption);
    on<TimerTickEvent>(_onTimerTick);
    on<TimerExpiredEvent>(_onTimerExpired);
    on<NextQuestionEvent>(_onNextQuestion);
  }

  @override
  Future<void> close() {
    _questionTimer?.cancel();
    return super.close();
  }

  void _startTimer() {
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is QuizActiveState) {
        final activeState = state as QuizActiveState;
        if (activeState.isAnswered) {
          timer.cancel();
          return;
        }
        if (activeState.secondsRemaining > 1) {
          add(const TimerTickEvent());
        } else {
          timer.cancel();
          add(const TimerExpiredEvent());
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _onStartQuiz(StartQuizEvent event, Emitter<QuizState> emit) {
    _questionTimer?.cancel();
    emit(QuizActiveState(
      category: event.category,
      stepNumber: event.stepNumber,
      questions: event.questions,
      currentIndex: 0,
      secondsRemaining: questionDuration,
      selectedOptionIndex: null,
      isAnswered: false,
      correctCount: 0,
      userAnswers: const {},
      timeSpentSeconds: 0,
    ));
    _startTimer();
  }

  void _onSelectOption(SelectOptionEvent event, Emitter<QuizState> emit) {
    if (state is! QuizActiveState) return;
    final active = state as QuizActiveState;
    if (active.isAnswered) return;

    _questionTimer?.cancel();

    final correctIndex =
        active.currentQuestion['correctOptionIndex'] as int;
    final isCorrect = event.optionIndex == correctIndex;
    final newCorrectCount =
        isCorrect ? active.correctCount + 1 : active.correctCount;

    final updatedAnswers = Map<int, int>.from(active.userAnswers);
    updatedAnswers[active.currentIndex] = event.optionIndex;

    emit(active.copyWith(
      selectedOptionIndex: event.optionIndex,
      isAnswered: true,
      correctCount: newCorrectCount,
      userAnswers: updatedAnswers,
    ));
  }

  void _onTimerTick(TimerTickEvent event, Emitter<QuizState> emit) {
    if (state is! QuizActiveState) return;
    final active = state as QuizActiveState;
    emit(active.copyWith(
      secondsRemaining: active.secondsRemaining - 1,
      timeSpentSeconds: active.timeSpentSeconds + 1,
    ));
  }

  void _onTimerExpired(TimerExpiredEvent event, Emitter<QuizState> emit) {
    if (state is! QuizActiveState) return;
    final active = state as QuizActiveState;
    if (active.isAnswered) return;

    _questionTimer?.cancel();

    final updatedAnswers = Map<int, int>.from(active.userAnswers);
    updatedAnswers[active.currentIndex] = -1; // -1 represents timed out

    emit(active.copyWith(
      selectedOptionIndex: null,
      isAnswered: true,
      secondsRemaining: 0,
      userAnswers: updatedAnswers,
    ));
  }

  Future<void> _onNextQuestion(
    NextQuestionEvent event,
    Emitter<QuizState> emit,
  ) async {
    if (state is! QuizActiveState) return;
    final active = state as QuizActiveState;

    if (active.isLastQuestion) {
      _questionTimer?.cancel();

      final total = active.totalQuestions;
      final correct = active.correctCount;
      final wrong = total - correct;
      final percentage = total > 0 ? (correct / total) * 100 : 0.0;
      final isQualified = total > 0 && (correct / total) >= 0.6;

      int stars = 0;
      if (correct >= 9) {
        stars = 3;
      } else if (correct >= 7) {
        stars = 2;
      } else if (correct >= 6) {
        stars = 1;
      }

      // If in step mode, persist progress
      if (active.stepNumber != null) {
        final categoryId = active.category['id'] as String;
        final totalSteps =
            QuizData.getTotalSteps(active.category);
        await QuizProgressService.recordStepResult(
          categoryId: categoryId,
          stepNumber: active.stepNumber!,
          score: correct,
          totalQuestions: total,
          maxSteps: totalSteps,
        );
      }

      emit(QuizFinishedState(
        category: active.category,
        stepNumber: active.stepNumber,
        questions: active.questions,
        totalQuestions: total,
        correctCount: correct,
        wrongCount: wrong,
        scorePercentage: percentage,
        isQualified: isQualified,
        stars: stars,
        timeSpentSeconds: active.timeSpentSeconds,
        userAnswers: active.userAnswers,
      ));
    } else {
      emit(active.copyWith(
        currentIndex: active.currentIndex + 1,
        secondsRemaining: questionDuration,
        selectedOptionIndex: null,
        isAnswered: false,
      ));
      _startTimer();
    }
  }
}
