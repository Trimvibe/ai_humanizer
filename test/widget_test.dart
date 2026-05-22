import 'package:flutter_test/flutter_test.dart';
import 'package:humanflow_ai/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HumanFlowApp());
  });
}
