import 'package:flutter/material.dart';
import 'package:flutter_bmi/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget tests', () {
    testWidgets('Test basic widgets', (tester) async {
      await tester.pumpWidget(const MainApp());

      expect(find.text('Weight:'), findsOneWidget);
      expect(find.text('Height:'), findsOneWidget);

      expect(find.text('Calculate'), findsOneWidget);
      expect(find.text('BMI calculator'), findsOneWidget);
    });

    testWidgets('Test hidden widgets', (tester) async {
      await tester.pumpWidget(const MainApp());

      expect(find.byKey(const Key('result')), findsNothing);
      expect(find.byKey(const Key('error')), findsNothing);
    });
  });

  group('Interaction tests', () {

    group('Calculate button', () {
      var heightTexFinder = find.byKey(const Key('height'));
      var weightTexFinder = find.byKey(const Key('weight'));
      var buttonFinder = find.byKey(const Key('calculate_button'));
      testWidgets('Button disabled no text', (tester) async {
        await tester.pumpWidget(const MainApp());

        ElevatedButton button = tester.widget<ElevatedButton>(buttonFinder);
        expect(button.enabled, isFalse);
      });

      testWidgets('Button enabled both text', (tester) async {
        await tester.pumpWidget(const MainApp());

        await tester.enterText(heightTexFinder, '1');
        await tester.enterText(weightTexFinder, '1');
        await tester.pumpAndSettle();
        
        ElevatedButton button = tester.widget<ElevatedButton>(buttonFinder);
        expect(button.enabled, isTrue);
      });

      testWidgets('Button disabled: height only', (tester) async {
        await tester.pumpWidget(const MainApp());

        await tester.enterText(heightTexFinder, '1');
        await tester.pumpAndSettle();
        
        ElevatedButton button = tester.widget<ElevatedButton>(buttonFinder);
        expect(button.enabled, isFalse);
      });

      testWidgets('Button disabled: weight only', (tester) async {
        await tester.pumpWidget(const MainApp());

        await tester.enterText(weightTexFinder, '1');
        await tester.pumpAndSettle();
        
        ElevatedButton button = tester.widget<ElevatedButton>(buttonFinder);
        expect(button.enabled, isFalse);
      });
  });
    });

    group('Unit switching', () {
      
    });
    /*testWidgets('Find basic widgets', (tester) async {
      await tester.pumpWidget(const MainApp());

      expect(find.text('Weight:'), findsOneWidget);
      expect(find.text('Height:'), findsOneWidget);

      expect(find.text('Calculate'), findsOneWidget);
      expect(find.text('BMI calculator'), findsOneWidget);
    });*/
}