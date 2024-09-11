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
    var heightTextFinder = find.byKey(const Key('height'));
    var weightTextFinder = find.byKey(const Key('weight'));
    var buttonFinder = find.byKey(const Key('calculate_button'));

    group('Calculate button', () {

      testWidgets('Button disabled no text', (tester) async {
        await tester.pumpWidget(const MainApp());

        ElevatedButton button = tester.widget<ElevatedButton>(buttonFinder);
        expect(button.enabled, isFalse);
      });

      testWidgets('Button enabled both text', (tester) async {
        await tester.pumpWidget(const MainApp());

        await tester.enterText(heightTextFinder, '1');
        await tester.enterText(weightTextFinder, '1');
        await tester.pumpAndSettle();
        
        ElevatedButton button = tester.widget<ElevatedButton>(buttonFinder);
        expect(button.enabled, isTrue);
      });

      testWidgets('Button disabled: height only', (tester) async {
        await tester.pumpWidget(const MainApp());

        await tester.enterText(heightTextFinder, '1');
        await tester.pumpAndSettle();
        
        ElevatedButton button = tester.widget<ElevatedButton>(buttonFinder);
        expect(button.enabled, isFalse);
      });

      testWidgets('Button disabled: weight only', (tester) async {
        await tester.pumpWidget(const MainApp());

        await tester.enterText(weightTextFinder, '1');
        await tester.pumpAndSettle();
        
        ElevatedButton button = tester.widget<ElevatedButton>(buttonFinder);
        expect(button.enabled, isFalse);
      });
    });

    group('Unit switching', () {

      testWidgets('Test default unit: metric', (tester) async {
        await tester.pumpWidget(const MainApp());

        expect(find.text('Metric'), findsOneWidget);
        expect(find.text('Imperial'), findsNothing);

        expect(find.text('kg'), findsOneWidget);
        expect(find.text('m'), findsOneWidget);
        expect(find.text('lb'), findsNothing);
        expect(find.text('in'), findsNothing);

        await tester.enterText(heightTextFinder, '1.78');
        await tester.enterText(weightTextFinder, '60');
        await tester.pumpAndSettle();
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();
      
        expect(find.text('BMI = ''18.94') , findsOneWidget);
      });

      testWidgets('Test unit: imperial', (tester) async {
        await tester.pumpWidget(const MainApp());
        //Switch to next unit
        await tester.tap(find.byKey(const Key('unit_button')));
        await tester.pumpAndSettle();

        expect(find.text('Imperial'), findsOneWidget);
        expect(find.text('Metric'), findsNothing);

        expect(find.text('kg'), findsNothing);
        expect(find.text('m'), findsNothing);
        expect(find.text('lb'), findsOneWidget);
        expect(find.text('in'), findsOneWidget);

        await tester.enterText(heightTextFinder, '70.07');
        await tester.enterText(weightTextFinder, '132.27');
        await tester.pumpAndSettle();
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();
      
        expect(find.text('BMI = ''18.94') , findsOneWidget);
      });

      testWidgets('Test unit looping', (tester) async {
        await tester.pumpWidget(const MainApp());

        expect(find.text('Metric'), findsOneWidget);
        expect(find.text('Imperial'), findsNothing);

        await tester.tap(find.byKey(const Key('unit_button')));
        await tester.pumpAndSettle();

        expect(find.text('Metric'), findsNothing);
        expect(find.text('Imperial'), findsOneWidget);

        await tester.tap(find.byKey(const Key('unit_button')));
        await tester.pumpAndSettle();

        expect(find.text('Metric'), findsOneWidget);
        expect(find.text('Imperial'), findsNothing);
      });
    });

    group('Errors', () {
      testWidgets('Invalid format', (tester) async {
        await tester.pumpWidget(const MainApp());
        
        expect(find.byKey(const Key('error')), findsNothing);

        await tester.enterText(heightTextFinder, '70.07');
        await tester.enterText(weightTextFinder, '132.27.4');
        await tester.pumpAndSettle();
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        //Error visible
        expect(find.byKey(const Key('error')), findsOneWidget);

        await tester.enterText(weightTextFinder, '132.27');
        await tester.pumpAndSettle();
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();
        
        //No error visible
        expect(find.byKey(const Key('error')), findsNothing);
      });

      testWidgets('0 division', (tester) async {
        await tester.pumpWidget(const MainApp());
        
        expect(find.byKey(const Key('error')), findsNothing);

        await tester.enterText(heightTextFinder, '0');
        await tester.enterText(weightTextFinder, '132');
        await tester.pumpAndSettle();
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        //No reaction expected
        expect(find.byKey(const Key('error')), findsNothing);
        expect(find.byKey(const Key('result')), findsNothing);
      });
    });
  });   
}