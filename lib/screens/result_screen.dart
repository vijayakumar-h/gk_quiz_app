import 'package:flutter/material.dart';
import '../blocs/quiz/quiz_bloc.dart';
import '../data/quiz_data.dart';
import '../utils/category_ui_helper.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final QuizFinishedState finishedState;

  const ResultScreen({
    super.key,
    required this.finishedState,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final category = finishedState.category;
    final primaryColor = CategoryUIHelper.getPrimaryColor(category);
    final percentage = finishedState.scorePercentage;
    final totalCategorySteps = QuizData.getTotalSteps(category);

    Color badgeColor;
    if (finishedState.isQualified) {
      badgeColor = const Color(0xFF2E7D32); // Green
    } else if (percentage >= 50) {
      badgeColor = const Color(0xFFF57C00); // Orange
    } else {
      badgeColor = const Color(0xFFD32F2F); // Red
    }

    final hasNextStep = finishedState.isStepMode &&
        finishedState.isQualified &&
        (finishedState.stepNumber! < totalCategorySteps);

    final titleText = finishedState.isStepMode
        ? '${category['name']} • Step ${finishedState.stepNumber}'
        : 'Quiz Completed';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Result Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.15),
                      colorScheme.surface,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: badgeColor.withValues(alpha: 0.15),
                        border: Border.all(color: badgeColor, width: 4),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${percentage.toStringAsFixed(0)}%',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: badgeColor,
                            ),
                          ),
                          Text(
                            '${finishedState.correctCount}/${finishedState.totalQuestions}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      finishedState.performanceTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      finishedState.performanceMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Qualification Banner for Step Mode
                    if (finishedState.isStepMode) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: finishedState.isQualified
                              ? const Color(0xFF2E7D32).withValues(alpha: 0.12)
                              : const Color(0xFFD32F2F).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: finishedState.isQualified
                                ? const Color(0xFF2E7D32).withValues(alpha: 0.3)
                                : const Color(0xFFD32F2F).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              finishedState.isQualified
                                  ? Icons.military_tech_rounded
                                  : Icons.lock_outline_rounded,
                              color: finishedState.isQualified
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFD32F2F),
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                finishedState.isQualified
                                    ? (hasNextStep
                                        ? '🎉 QUALIFIED! Step ${finishedState.stepNumber! + 1} is now unlocked!'
                                        : '🏆 ALL STEPS COMPLETED in this category!')
                                    : 'NOT QUALIFIED: Score 6/10 or more to unlock Step ${finishedState.stepNumber! + 1}.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: finishedState.isQualified
                                      ? const Color(0xFF1B5E20)
                                      : const Color(0xFFB71C1C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Quick Stats Grid
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Correct',
                            value: '${finishedState.correctCount}',
                            color: const Color(0xFF2E7D32),
                            icon: Icons.check_circle_outline_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Wrong',
                            value: '${finishedState.wrongCount}',
                            color: const Color(0xFFD32F2F),
                            icon: Icons.cancel_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Time',
                            value: '${finishedState.timeSpentSeconds}s',
                            color: primaryColor,
                            icon: Icons.timer_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Step Action Buttons
              if (hasNextStep) ...[
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final nextStep = finishedState.stepNumber! + 1;
                      final nextQuestions =
                          QuizData.getQuestionsForStep(category, nextStep);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            category: category,
                            stepNumber: nextStep,
                            questions: nextQuestions,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                        'Next Step (Step ${finishedState.stepNumber! + 1})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.format_list_bulleted_rounded),
                      label: Text(
                          finishedState.isStepMode ? 'All Steps' : 'Home'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              category: category,
                              stepNumber: finishedState.stepNumber,
                              questions: finishedState.questions,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.replay_rounded),
                      label: Text(finishedState.isStepMode
                          ? 'Retry Step'
                          : 'Play Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Question Review Header
              Text(
                'Review Answers',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Question Review List
              ...List.generate(finishedState.questions.length, (index) {
                final question = finishedState.questions[index];
                final options = (question['options'] as List).cast<String>();
                final correctIndex = question['correctOptionIndex'] as int;
                final selectedOptionIndex =
                    finishedState.userAnswers[index] ?? -1;
                final isCorrect = selectedOptionIndex == correctIndex;
                final isTimedOut = selectedOptionIndex == -1;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCorrect
                          ? const Color(0xFF2E7D32).withValues(alpha: 0.3)
                          : const Color(0xFFD32F2F).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: isCorrect
                                ? const Color(0xFF2E7D32).withValues(alpha: 0.2)
                                : const Color(0xFFD32F2F).withValues(alpha: 0.2),
                            child: Icon(
                              isCorrect
                                  ? Icons.check_rounded
                                  : Icons.close_rounded,
                              size: 16,
                              color: isCorrect
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFD32F2F),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${index + 1}. ${question['question']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (!isCorrect && !isTimedOut)
                        Padding(
                          padding: const EdgeInsets.only(left: 40, bottom: 4),
                          child: Text(
                            'Your answer: ${options[selectedOptionIndex]}',
                            style: const TextStyle(
                              color: Color(0xFFD32F2F),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (isTimedOut)
                        const Padding(
                          padding: EdgeInsets.only(left: 40, bottom: 4),
                          child: Text(
                            'Time ran out (No answer selected)',
                            style: TextStyle(
                              color: Color(0xFFD32F2F),
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, bottom: 6),
                        child: Text(
                          'Correct answer: ${options[correctIndex]}',
                          style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text(
                          '💡 ${question['explanation']}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
