import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:gk_quiz_app/blocs/quiz/quiz_bloc.dart';
import 'package:gk_quiz_app/data/quiz_data.dart';

void main() {
  group('Quiz JSON Data & BLoC Unit Tests', () {
    late List<Map<String, dynamic>> categories;

    setUpAll(() {
      final loaded = <Map<String, dynamic>>[];
      for (final relPath in QuizData.categoryAssetPaths) {
        final filePath = File(relPath).existsSync()
            ? relPath
            : 'apps/gk_quiz_app/$relPath';
        final file = File(filePath);
        final jsonString = file.readAsStringSync();
        final catMap = jsonDecode(jsonString) as Map<String, dynamic>;
        loaded.add(catMap);
      }
      categories = loaded;
      QuizData.setCategories(categories);
    });

    test('Verify all 5 separate category JSON files exist and load individually', () {
      expect(QuizData.categoryAssetPaths.length, equals(5));
      for (final relPath in QuizData.categoryAssetPaths) {
        final filePath = File(relPath).existsSync()
            ? relPath
            : 'apps/gk_quiz_app/$relPath';
        expect(File(filePath).existsSync(), isTrue, reason: '$filePath must exist');
      }
    });

    test('Verify JSON structure has 5 categories with 110 questions each (550 total)', () {
      expect(categories.length, equals(5));

      for (final category in categories) {
        final questions = (category['questions'] as List).cast<Map<String, dynamic>>();
        expect(questions.length, equals(110),
            reason: '${category['name']} must have 110 questions');
        expect(QuizData.getTotalSteps(category), equals(11),
            reason: '${category['name']} must have 11 steps');
      }
    });

    test('Verify each step has exactly 10 questions from JSON', () {
      for (final category in categories) {
        for (int step = 1; step <= 11; step++) {
          final questions = QuizData.getQuestionsForStep(category, step);
          expect(questions.length, equals(10),
              reason: '${category['name']} Step $step must have 10 questions');
        }
      }
    });

    test('Verify question JSON format (id, question, options[4], correctOptionIndex, explanation)', () {
      for (final category in categories) {
        final questions = (category['questions'] as List).cast<Map<String, dynamic>>();
        for (final q in questions) {
          expect(q['id'], isA<String>());
          expect(q['question'], isA<String>());
          expect((q['question'] as String).isNotEmpty, isTrue);

          final options = q['options'] as List;
          expect(options.length, equals(4),
              reason: 'Question ${q['id']} must have exactly 4 options');

          final correctIndex = q['correctOptionIndex'] as int;
          expect(correctIndex >= 0 && correctIndex < 4, isTrue,
              reason: 'Question ${q['id']} correctOptionIndex must be 0..3');

          expect(q['explanation'], isA<String>());
          expect((q['explanation'] as String).isNotEmpty, isTrue);
        }
      }
    });

    test('QuizBloc starts quiz and selects option correctly', () async {
      final quizBloc = QuizBloc();
      final sampleCategory = categories.first;
      final stepQuestions = QuizData.getQuestionsForStep(sampleCategory, 1);

      quizBloc.add(StartQuizEvent(
        category: sampleCategory,
        stepNumber: 1,
        questions: stepQuestions,
      ));

      await expectLater(
        quizBloc.stream,
        emits(isA<QuizActiveState>().having(
          (s) => s.currentIndex,
          'currentIndex',
          0,
        )),
      );

      quizBloc.add(const SelectOptionEvent(0));

      await expectLater(
        quizBloc.stream,
        emits(isA<QuizActiveState>().having(
          (s) => s.isAnswered,
          'isAnswered',
          true,
        )),
      );

      await quizBloc.close();
    });
  });
}
