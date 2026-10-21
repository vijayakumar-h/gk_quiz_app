import 'package:flutter/material.dart';
import 'quiz_question.dart';

class QuizCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;
  final List<QuizQuestion> questions;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
    required this.questions,
  });

  int get totalQuestions => questions.length;
}
