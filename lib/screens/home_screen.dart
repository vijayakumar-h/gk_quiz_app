import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/category/category_bloc.dart';
import '../data/quiz_data.dart';
import '../utils/category_ui_helper.dart';
import 'level_selection_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startRandomChallenge(
    BuildContext context,
    List<Map<String, dynamic>> categories,
  ) {
    // Pick 2 random questions from each category for a 10-question mixed grand challenge
    final mixedQuestions = <Map<String, dynamic>>[];
    for (final category in categories) {
      final questions =
          List<Map<String, dynamic>>.from(category['questions'] as List)..shuffle();
      if (questions.length >= 2) {
        mixedQuestions.addAll(questions.take(2));
      } else if (questions.isNotEmpty) {
        mixedQuestions.add(questions.first);
      }
    }
    mixedQuestions.shuffle();

    final challengeCategory = {
      'id': 'daily_mix',
      'name': 'Grand Trivia Mix',
      'description': 'A handpicked mix of 10 trivia questions across all topics!',
      'icon': 'auto_awesome',
      'primaryColor': 0xFF673AB7,
      'accentColor': 0xFF9575CD,
      'questions': mixedQuestions,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          category: challengeCategory,
          questions: mixedQuestions,
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.help_outline_rounded, color: Color(0xFF5E35B1)),
            SizedBox(width: 8),
            Text('How Progression Works'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Each category contains 11 progressive Steps (110 total questions).'),
            SizedBox(height: 8),
            Text('2. Each Step consists of exactly 10 questions with a 20s timer.'),
            SizedBox(height: 8),
            Text('3. Score at least 6/10 (60%) in a step to qualify and unlock the next step!'),
            SizedBox(height: 8),
            Text('4. Earn up to 3 stars per step based on your score:'),
            Padding(
              padding: EdgeInsets.only(left: 12, top: 4),
              child: Text('• 9-10 Correct: ⭐⭐⭐\n• 7-8 Correct: ⭐⭐\n• 6 Correct: ⭐'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF5E35B1).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.quiz_rounded,
                color: Color(0xFF5E35B1),
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            const Text('GK Quiz App'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'How to Play',
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoryErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<CategoryBloc>()
                          .add(const LoadCategoriesEvent()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final categories = (state is CategoryLoadedState)
                ? state.categories
                : QuizData.cachedCategories;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                // Hero Banner
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5E35B1), Color(0xFF3949AB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5E35B1).withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.bolt_rounded,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'DAILY MIX CHALLENGE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Grand Trivia Mix',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Test your knowledge with 10 mixed questions sampled across science, history, technology, and sports!',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: categories.isEmpty
                            ? null
                            : () => _startRandomChallenge(context, categories),
                        icon: const Icon(Icons.play_arrow_rounded,
                            color: Color(0xFF5E35B1)),
                        label: const Text(
                          'Start Grand Mix',
                          style: TextStyle(
                            color: Color(0xFF5E35B1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF5E35B1),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Categories Section Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose a Category',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${categories.length} Categories • 550+ Questions',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Categories List
                ...categories.map((category) => _CategoryCard(
                      category: category,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevelSelectionScreen(
                              category: category,
                            ),
                          ),
                        );
                      },
                    )),

                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = CategoryUIHelper.getPrimaryColor(category);
    final iconData = CategoryUIHelper.getIcon(category['icon'] as String?);
    final totalSteps = QuizData.getTotalSteps(category);
    final totalQuestions = (category['questions'] as List?)?.length ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Category Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    iconData,
                    color: primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Category Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['name'] as String? ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalSteps Steps • $totalQuestions Questions',
                        style: TextStyle(
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category['description'] as String? ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
