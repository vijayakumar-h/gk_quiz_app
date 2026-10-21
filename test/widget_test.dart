import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:gk_quiz_app/data/quiz_data.dart';
import 'package:gk_quiz_app/main.dart';

void main() {
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
    QuizData.setCategories(loaded);
  });

  testWidgets('GKQuizApp smoke test renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GKQuizApp());
    await tester.pumpAndSettle();

    expect(find.text('GK Quiz App'), findsOneWidget);
    expect(find.text('Choose a Category'), findsOneWidget);
    expect(find.text('Science & Nature'), findsOneWidget);
  });
}
