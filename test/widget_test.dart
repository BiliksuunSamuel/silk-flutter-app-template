import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silk/app/app.dart';

void main() {
  testWidgets('app boots without error', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SilkApp()));
    await tester.pump();
    expect(find.byType(SilkApp), findsOneWidget);
  });
}
