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
    void Function()? pressHandler = ref.watch(bmiViewModelProvider).valid ? () { 
      final viewModel = ref.read(bmiViewModelProvider.notifier);
      viewModel.update(bmiState: BmiState.value);
    } : null;
    enterPressHandler() {
      if(pressHandler != null) pressHandler();
    }
    void Function(int) setUnit = ref.read(bmiViewModelProvider.notifier.select((v) => v.setUnit));
    currentUnit(Unit unit) => unit == ref.watch(bmiViewModelProvider.select((v) => v.unit));
    final unit = ref.watch(bmiViewModelProvider.select((value) => value.unit));
    var bmi = ref.watch(bmiProvider);

    return Column(
      children: [
        InputRow(label: "Weight:", textfieldWidth: constants.textfieldWidth, isHeight: false,
          textController: ref.watch(bmiViewModelProvider.notifier).weightTextController,
          textKey: const Key('weight'), enterPressHandler: enterPressHandler, selectedUnit: unit,
        ),
        InputRow(label: "Height:", textfieldWidth: constants.textfieldWidth, isHeight: true, 
          textController: ref.watch(bmiViewModelProvider.notifier).heightTextController, 
          textKey: const Key('height'), enterPressHandler: enterPressHandler, selectedUnit: unit,
        ),
        const SizedBox(height: 20,),
        
        //Buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: UnitToggle(currentUnit: currentUnit, setUnit: setUnit,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CalculateButton(pressHandler: pressHandler,),
        ),
        //Result
        if(ref.watch(bmiViewModelProvider).bmiState != BmiState.hidden)
          bmi.when(
            skipLoadingOnRefresh: false,
            data: (data) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                key: const Key('result'),
                style: TextStyle(backgroundColor: ColorBmi(ref.read(bmiViewModelProvider).category(data.$1)).color),
                'BMI = ${data.$1}'),
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
    required this.currentUnit,
    required this.setUnit,
  });

  final bool Function(Unit) currentUnit;
  final void Function(int) setUnit;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return ToggleButtons(
      isSelected: Unit.values.map(currentUnit).toList(),
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