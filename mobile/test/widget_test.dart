import 'package:flutter_test/flutter_test.dart';
import 'package:unireserve/main.dart';

void main() {
  testWidgets('App can be created', (tester) async {
    await tester.pumpWidget(const UniReserveApp());
    expect(find.text('UniReserve'), findsOneWidget);
  });
}
