import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter/main.dart';

void main() {
  testWidgets('', (WidgetTester tester) async {
    await tester.pumpWidget(const WebSnapApp());
  });
}
