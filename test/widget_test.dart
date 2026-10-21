import 'package:flutter_test/flutter_test.dart';
import 'package:gk_quiz_app/main.dart';

void main() {
  testWidgets('GKQuizApp smoke test renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GKQuizApp());
    await tester.pumpAndSettle();

    expect(find.text('GK Quiz App'), findsOneWidget);
    expect(find.text('Choose a Category'), findsOneWidget);
    expect(find.text('Science & Nature'), findsOneWidget);
  });
}
