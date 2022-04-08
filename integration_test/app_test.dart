import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Tap add watchlist', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Popular Movie'), findsOneWidget);

      final Finder fab = find.byType(ListView).first;

      await tester.tap(fab);

      await tester.pumpAndSettle();

      final Finder icon = find.byIcon(Icons.add);

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);

      await tester.tap(icon);

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
