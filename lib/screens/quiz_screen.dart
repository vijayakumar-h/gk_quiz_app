import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/quiz/quiz_bloc.dart';
import '../utils/category_ui_helper.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  final Map<String, dynamic> category;
  final int? stepNumber;
  final List<Map<String, dynamic>> questions;

  const QuizScreen({
    super.key,
    required this.category,
    this.stepNumber,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc()
        ..add(StartQuizEvent(
          category: category,
          stepNumber: stepNumber,
          questions: questions,
        )),
      child: _QuizView(
        category: category,
        stepNumber: stepNumber,
      ),
    );
  }
}

class _QuizView extends StatelessWidget {
  final Map<String, dynamic> category;
  final int? stepNumber;

  const _QuizView({
    required this.category,
    required this.stepNumber,
  });

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Are you sure you want to leave? Your progress in this quiz will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return shouldLeave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = CategoryUIHelper.getPrimaryColor(category);

    final titleText = stepNumber != null
        ? '${category['name']} • Step $stepNumber'
        : (category['name'] as String? ?? 'Quiz');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizFinishedState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(finishedState: state),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is! QuizActiveState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final active = state;
          final question = active.currentQuestion;
          final options = (question['options'] as List).cast<String>();
          final correctIndex = question['correctOptionIndex'] as int;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                titleText,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () async {
                  final shouldPop = await _onWillPop(context);
                  if (shouldPop && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 16,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${active.correctCount}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // Progress Bar & Info
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question ${active.currentIndex + 1} of ${active.totalQuestions}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            // Timer Indicator
                            Row(
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 16,
                                  color: active.secondsRemaining <= 5
                                      ? const Color(0xFFD32F2F)
                                      : primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${active.secondsRemaining}s',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: active.secondsRemaining <= 5
                                        ? const Color(0xFFD32F2F)
                                        : primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: active.progress,
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade200,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Question & Options Area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Question Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              question['question'] as String? ?? '',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Options
                          ...List.generate(options.length, (index) {
                            return _buildOptionTile(
                              context: context,
                              index: index,
                              optionText: options[index],
                              correctIndex: correctIndex,
                              selectedIndex: active.selectedOptionIndex,
                              isAnswered: active.isAnswered,
                              primaryColor: primaryColor,
                            );
                          }),

                          // Explanation Card (Visible once answered)
                          if (active.isAnswered) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.amber.shade600
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline_rounded,
                                    color: Colors.amber.shade800,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Fact & Explanation',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.amber.shade900,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          question['explanation'] as String? ?? '',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade800,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Bottom Bar: Next / Finish Button
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: active.isAnswered
                            ? () => context
                                .read<QuizBloc>()
                                .add(const NextQuestionEvent())
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              active.isLastQuestion
                                  ? 'View Results'
                                  : 'Next Question',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              active.isLastQuestion
                                  ? Icons.emoji_events_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required int index,
    required String optionText,
    required int correctIndex,
    required int? selectedIndex,
    required bool isAnswered,
    required Color primaryColor,
  }) {
    final isSelected = selectedIndex == index;
    final isCorrectOption = correctIndex == index;

    Color borderColor = Colors.grey.shade300;
    Color backgroundColor = Theme.of(context).cardColor;
    Color textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
    Widget? trailingIcon;

    if (isAnswered) {
      if (isCorrectOption) {
        borderColor = const Color(0xFF2E7D32);
        backgroundColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF1B5E20);
        trailingIcon = const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF2E7D32),
          size: 20,
        );
      } else if (isSelected) {
        borderColor = const Color(0xFFD32F2F);
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFB71C1C);
        trailingIcon = const Icon(
          Icons.cancel_rounded,
          color: Color(0xFFD32F2F),
          size: 20,
        );
      }
    }

    final optionLetters = ['A', 'B', 'C', 'D'];
    final letter =
        index < optionLetters.length ? optionLetters[index] : '${index + 1}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isAnswered
              ? null
              : () => context.read<QuizBloc>().add(SelectOptionEvent(index)),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: isSelected || (isAnswered && isCorrectOption) ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (isAnswered && isCorrectOption)
                        ? const Color(0xFF2E7D32)
                        : (isSelected && isAnswered)
                            ? const Color(0xFFD32F2F)
                            : primaryColor.withValues(alpha: 0.1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: (isAnswered && (isCorrectOption || isSelected))
                          ? Colors.white
                          : primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    optionText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  trailingIcon,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
