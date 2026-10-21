import 'dart:async';
import 'package:flutter/material.dart';
import '../models/quiz_category.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const int questionDuration = 20;

  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  int _correctCount = 0;
  final Map<int, int> _userAnswers = {};

  Timer? _timer;
  int _secondsRemaining = questionDuration;
  int _totalSecondsSpent = 0;
  Timer? _totalDurationTimer;

  QuizQuestion get _currentQuestion => widget.category.questions[_currentIndex];
  bool get _isLastQuestion =>
      _currentIndex == widget.category.questions.length - 1;

  @override
  void initState() {
    super.initState();
    _startQuestionTimer();
    _totalDurationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _totalSecondsSpent++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _totalDurationTimer?.cancel();
    super.dispose();
  }

  void _startQuestionTimer() {
    _timer?.cancel();
    _secondsRemaining = questionDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _handleTimeOut();
      }
    });
  }

  void _handleTimeOut() {
    if (_isAnswered) return;
    setState(() {
      _isAnswered = true;
      _selectedOptionIndex = null;
      _userAnswers[_currentIndex] = -1; // -1 represents timed out
    });
  }

  void _selectOption(int index) {
    if (_isAnswered) return;
    _timer?.cancel();

    final isCorrect = _currentQuestion.isCorrect(index);
    if (isCorrect) {
      _correctCount++;
    }

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      _userAnswers[_currentIndex] = index;
    });
  }

  void _goToNextQuestion() {
    if (_isLastQuestion) {
      _totalDurationTimer?.cancel();
      final result = QuizResult(
        category: widget.category,
        totalQuestions: widget.category.questions.length,
        correctCount: _correctCount,
        answers: _userAnswers,
        timeSpentSeconds: _totalSecondsSpent,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(result: result),
        ),
      );
    } else {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _isAnswered = false;
      });
      _startQuestionTimer();
    }
  }

  Future<bool> _onWillPop() async {
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
    final totalQuestions = widget.category.questions.length;
    final progress = (_currentIndex + 1) / totalQuestions;
    final question = _currentQuestion;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category.name),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: widget.category.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 16,
                    color: widget.category.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$_correctCount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.category.primaryColor,
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${_currentIndex + 1} of $totalQuestions',
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
                              color: _secondsRemaining <= 5
                                  ? const Color(0xFFD32F2F)
                                  : widget.category.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_secondsRemaining}s',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _secondsRemaining <= 5
                                  ? const Color(0xFFD32F2F)
                                  : widget.category.primaryColor,
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
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.category.primaryColor,
                        ),
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
                          question.question,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Options
                      ...List.generate(question.options.length, (index) {
                        final optionText = question.options[index];
                        return _buildOptionTile(
                          index: index,
                          optionText: optionText,
                          correctIndex: question.correctOptionIndex,
                        );
                      }),

                      // Explanation Card (Visible once answered)
                      if (_isAnswered) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.amber.shade600.withValues(alpha: 0.3),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      question.explanation,
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
                    onPressed: _isAnswered ? _goToNextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.category.primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLastQuestion ? 'View Results' : 'Next Question',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _isLastQuestion
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
      ),
    );
  }

  Widget _buildOptionTile({
    required int index,
    required String optionText,
    required int correctIndex,
  }) {
    final isSelected = _selectedOptionIndex == index;
    final isCorrectOption = correctIndex == index;

    Color borderColor = Colors.grey.shade300;
    Color backgroundColor = Theme.of(context).cardColor;
    Color textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
    Widget? trailingIcon;

    if (_isAnswered) {
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
    final letter = index < optionLetters.length ? optionLetters[index] : '${index + 1}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: _isAnswered ? null : () => _selectOption(index),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: isSelected || (_isAnswered && isCorrectOption) ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_isAnswered && isCorrectOption)
                        ? const Color(0xFF2E7D32)
                        : (isSelected && _isAnswered)
                            ? const Color(0xFFD32F2F)
                            : widget.category.primaryColor.withValues(alpha: 0.1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: (_isAnswered && (isCorrectOption || isSelected))
                          ? Colors.white
                          : widget.category.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    optionText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
