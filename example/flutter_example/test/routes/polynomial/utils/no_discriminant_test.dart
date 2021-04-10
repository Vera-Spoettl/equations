import 'package:equations_solver/routes/polynomial_page/utils/no_discriminant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'NoDiscriminant' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(child: NoDiscriminant()));

      expect(find.byType(NoDiscriminant), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.text('No discriminant.'), findsOneWidget);
    });

    testGoldens('NoDiscriminant', (tester) async {
      const widget = SizedBox(
        width: 300,
        height: 150,
        child: Scaffold(body: NoDiscriminant()),
      );

      final builder = GoldenBuilder.column()..addScenario('', widget);

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(300, 300),
      );
      await screenMatchesGolden(tester, 'no_discriminant');
    });
  });
}
