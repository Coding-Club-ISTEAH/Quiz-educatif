import 'package:flutter_test/flutter_test.dart';

import 'package:quiz_educatif/main.dart';

void main() {
  testWidgets('L\'application démarre sur l\'écran d\'accueil', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuizEducatifApp());
    await tester.pump();

    expect(find.text('EduClé'), findsOneWidget);
    expect(find.text('Jouer'), findsOneWidget);
  });
}
