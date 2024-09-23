import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bmi/logic/bmi_logic.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

import 'package:flutter_bmi/utils/constants.dart' as constants;
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension Capitalize on String{
  String capitalize() {
    return '${this[0].toUpperCase()}''${substring(1)}';
  }
}

extension ColorBmi on BmiCategory{
  Color get color {
    switch(this) {
      case BmiCategory.underweight: return Colors.yellow;
      case BmiCategory.normal: return Colors.green;
      case BmiCategory.overweight: return Colors.orange;
      case BmiCategory.obese: return Colors.red;
    }
  }
}

TextEditingValue doubleInputChecker(TextEditingValue old, TextEditingValue next){
  if (next.text.isEmpty || next.text == '.'){
    return next;
  }

  final value = double.tryParse(next.text);
  return value != null && value > 0
    ? next 
    : old;
}

class BmiPage extends StatelessWidget {
  const BmiPage({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PageContents()
      ],
    );
  }
}

class PageContents extends ConsumerWidget {
  const PageContents({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BmiViewModel(
        weightTextController: weightTextController,
        heightTextController: heightTextController,
        calcHandler: calcHandler,
        setUnit: setUnit
      ) = ref.watch(bmiViewModelProvider.notifier);
    final model = ref.watch(bmiViewModelProvider);
    final result = ref.watch(bmiResultProvider);

    enterPressHandler() {
      if(calcHandler != null) calcHandler();
    }

    return Column(
      children: [
        InputRow(label: "Weight:", textfieldWidth: constants.textfieldWidth, isHeight: false,
          textController: weightTextController,
          textKey: const Key('weight'), enterPressHandler: enterPressHandler, selectedUnit: model.unit,
        ),
        InputRow(label: "Height:", textfieldWidth: constants.textfieldWidth, isHeight: true, 
          textController: heightTextController, 
          textKey: const Key('height'), enterPressHandler: enterPressHandler, selectedUnit: model.unit,
        ),
        const SizedBox(height: 20,),
        
        //Buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: UnitToggle(unit: model.unit, setUnit: setUnit,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CalculateButton(pressHandler: calcHandler,),
        ),
        //Result
        if(model.bmiState is! BmiHiddenResult)
          result.when(
            skipLoadingOnRefresh: false,
            data: (data) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                key: const Key('result'),
                style: TextStyle(backgroundColor: data.category.color),
                'BMI = ${data.$1?.toStringAsFixed(2)}'),
            ), 
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                key: const Key('error'),
                error.toString()),
            ), 
            loading: () => const CircularProgressIndicator()
          )
        else Container()
      ],
    );
  }
}

class CalculateButton extends StatelessWidget {
  const CalculateButton({
    super.key,
    required this.pressHandler,
  });

  final void Function()? pressHandler;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        key: const Key('calculate_button'),
        onPressed: pressHandler,
        child: const Text('Calculate')
    );
  }
}

class UnitToggle extends StatelessWidget {
  const UnitToggle({
    super.key,
    required this.unit,
    required this.setUnit,
  });

  final Unit unit;
  final void Function(int) setUnit;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return ToggleButtons(
      isSelected: Unit.values.map((e) => e == unit).toList(),
      selectedColor: Colors.white,
      color: primary,
      fillColor: primary,
      renderBorder: true,
      borderRadius: BorderRadius.circular(10),
      onPressed: setUnit,
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            key: Key('unit_button_metric'),
            'Metric'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(key: Key('unit_button_imperial'),
          'Imperial'),
        ),
      ],
    );
  }
}

class InputRow extends StatelessWidget {
  const InputRow({
    super.key,
    required this.label,
    required this.textfieldWidth,
    required this.isHeight,
    required this.textController,
    required this.textKey,
    required this.enterPressHandler,
    required this.selectedUnit,
  });

  final String label;
  final bool isHeight;
  final double textfieldWidth;
  final TextEditingController textController;
  final Key textKey;
  final void Function() enterPressHandler;
  final Unit selectedUnit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: textfieldWidth,
            child: TextField(
              key: textKey,
              controller: textController,
              onSubmitted: (s) => enterPressHandler(), 
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: const [
                TextInputFormatter.withFunction(doubleInputChecker),
              ],
            ),
          ),
        ),
        UnitLabel(isHeight: isHeight, selectedUnit: selectedUnit,),
      ],
    );
  }
}

class UnitLabel extends StatelessWidget {
  const UnitLabel({
    super.key,
    required this.isHeight,
    required this.selectedUnit,
  });

  final bool isHeight;
  final Unit selectedUnit;

  @override
  Widget build(BuildContext context) {
    return Text( isHeight ? selectedUnit.heightUnit : selectedUnit.weightUnit);
  }
}