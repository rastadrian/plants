import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plants/app.dart';

void main() {
  testWidgets('App renders plants list screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: PlantsApp()),
    );
    await tester.pump();
    expect(find.text('My Plants'), findsOneWidget);
  });
}
