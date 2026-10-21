import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/progress/progress_bloc.dart';
import '../data/quiz_data.dart';
import '../utils/category_ui_helper.dart';
import 'quiz_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  final Map<String, dynamic> category;

  const LevelSelectionScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final totalSteps = QuizData.getTotalSteps(category);
    final categoryId = category['id'] as String;

    return BlocProvider(
      create: (context) => ProgressBloc()
        ..add(LoadProgressEvent(
          categoryId: categoryId,
          totalSteps: totalSteps,
        )),
      child: _LevelSelectionView(category: category),
    );
  }
}

class _LevelSelectionView extends StatelessWidget {
  final Map<String, dynamic> category;

  const _LevelSelectionView({required this.category});

  void _startStep(BuildContext context, int stepNumber) async {
    final questions = QuizData.getQuestionsForStep(category, stepNumber);
    if (questions.isEmpty) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          category: category,
          stepNumber: stepNumber,
          questions: questions,
        ),
      ),
    );

    // Refresh progress when returning
    if (context.mounted) {
      final totalSteps = QuizData.getTotalSteps(category);
      final categoryId = category['id'] as String;
      context.read<ProgressBloc>().add(LoadProgressEvent(
            categoryId: categoryId,
            totalSteps: totalSteps,
          ));
    }
  }

  Future<void> _confirmReset(BuildContext context) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Category Progress?'),
        content: Text(
          'This will lock all steps in ${category['name']} except Step 1 and reset your scores.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset == true && context.mounted) {
      final totalSteps = QuizData.getTotalSteps(category);
      final categoryId = category['id'] as String;
      context.read<ProgressBloc>().add(ResetProgressEvent(
            categoryId: categoryId,
            totalSteps: totalSteps,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalSteps = QuizData.getTotalSteps(category);
    final totalQuestions = (category['questions'] as List?)?.length ?? 0;
    final primaryColor = CategoryUIHelper.getPrimaryColor(category);
    final accentColor = CategoryUIHelper.getAccentColor(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(category['name'] as String? ?? 'Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded),
            tooltip: 'Reset Progress',
            onPressed: () => _confirmReset(context),
          ),
        ],
      ),
      body: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          if (state is ProgressLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          final highestUnlocked =
              (state is ProgressLoadedState) ? state.highestUnlockedStep : 1;
          final bestScores = (state is ProgressLoadedState)
              ? state.bestScores
              : <int, int>{};
          final totalStars =
              (state is ProgressLoadedState) ? state.totalStars : 0;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                // Category Progress Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$totalQuestions TOTAL QUESTIONS',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '$totalStars Stars',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Step $highestUnlocked of $totalSteps Unlocked',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Score at least 6 out of 10 in each step to qualify for the next level!',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: totalSteps > 0
                              ? highestUnlocked / totalSteps
                              : 0.0,
                          minHeight: 6,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'All Steps (10 Questions Each)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Steps List
                ...List.generate(totalSteps, (index) {
                  final stepNumber = index + 1;
                  final isUnlocked = stepNumber <= highestUnlocked;
                  final bestScore = bestScores[stepNumber] ?? 0;
                  final hasCompleted = bestScore >= 6;

                  return _StepCard(
                    stepNumber: stepNumber,
                    category: category,
                    primaryColor: primaryColor,
                    isUnlocked: isUnlocked,
                    bestScore: bestScore,
                    hasCompleted: hasCompleted,
                    isCurrentTarget:
                        stepNumber == highestUnlocked && !hasCompleted,
                    onTap:
                        isUnlocked ? () => _startStep(context, stepNumber) : null,
                  );
                }),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final Map<String, dynamic> category;
  final Color primaryColor;
  final bool isUnlocked;
  final int bestScore;
  final bool hasCompleted;
  final bool isCurrentTarget;
  final VoidCallback? onTap;

  const _StepCard({
    required this.stepNumber,
    required this.category,
    required this.primaryColor,
    required this.isUnlocked,
    required this.bestScore,
    required this.hasCompleted,
    required this.isCurrentTarget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color cardBorderColor = Colors.grey.shade300;
    if (isCurrentTarget) {
      cardBorderColor = primaryColor;
    } else if (hasCompleted) {
      cardBorderColor = const Color(0xFF2E7D32).withValues(alpha: 0.4);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color:
            isUnlocked ? theme.cardColor : Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cardBorderColor,
                width: isCurrentTarget ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Step Badge Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUnlocked
                        ? (hasCompleted
                            ? const Color(0xFF2E7D32).withValues(alpha: 0.15)
                            : primaryColor.withValues(alpha: 0.15))
                        : Colors.grey.shade300,
                  ),
                  alignment: Alignment.center,
                  child: isUnlocked
                      ? (hasCompleted
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF2E7D32),
                              size: 26,
                            )
                          : Text(
                              '$stepNumber',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ))
                      : const Icon(
                          Icons.lock_rounded,
                          color: Colors.grey,
                          size: 22,
                        ),
                ),
                const SizedBox(width: 16),

                // Step Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Step $stepNumber',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked ? null : Colors.grey,
                            ),
                          ),
                          if (isCurrentTarget) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'CURRENT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isUnlocked
                            ? (hasCompleted
                                ? 'Completed • Best Score: $bestScore / 10'
                                : '10 Questions • Pass score: 6/10')
                            : 'Complete Step ${stepNumber - 1} to unlock',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                if (isUnlocked)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (hasCompleted)
                        Row(
                          children: List.generate(3, (starIndex) {
                            final starsEarned = bestScore >= 9
                                ? 3
                                : (bestScore >= 7 ? 2 : 1);
                            return Icon(
                              Icons.star_rounded,
                              size: 18,
                              color: starIndex < starsEarned
                                  ? Colors.amber
                                  : Colors.grey.shade300,
                            );
                          }),
                        )
                      else
                        Icon(
                          Icons.play_circle_fill_rounded,
                          color: primaryColor,
                          size: 28,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
