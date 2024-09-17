import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bmi/logic/bmi_logic.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

import 'package:flutter_bmi/utils/constants.dart' as constants;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as prov;

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

class BmiPage extends ConsumerWidget {
  const BmiPage({
    super.key,
  });


  @override
  Widget build(BuildContext context, WidgetRef  ref) {
    return prov.MultiProvider(
      providers: [
        prov.ChangeNotifierProvider.value(value: ref.watch(viewModelProvider.notifier))
      ],
      child: prov.Consumer<BmiViewModel>(builder: (_, model, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PageContents(viewModel: model,)
          ],
        );
      },)    
    );
  }
}

class PageContents extends ConsumerWidget {
  const PageContents({
    super.key,
    required this.viewModel
  });

  final BmiViewModel viewModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final provider = 
    return Column(
      children: [
        InputRow(label: "Weight:", textfieldWidth: constants.textfieldWidth, isHeight: false,
          textController: ref.watch(viewModelProvider.select((value) => value.weightTextController)),
          textKey: const Key('weight'),),
        InputRow(label: "Height:", textfieldWidth: constants.textfieldWidth, isHeight: true, 
          textController: ref.watch(viewModelProvider.select((value) => value.heightTextController)), 
          textKey: const Key('height'),),
        const SizedBox(height: 20,),
        
        //Buttons
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: UnitToggle(),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CalculateButton(),
        ),
        //Result    
        FutureBuilder(
          future: viewModel.bmi, 
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            }
            if(snapshot.hasError){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  key: const Key('error'),
                  snapshot.error.toString()),
              );
            }
            if(snapshot.data == null){
              return Container();
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                key: const Key('result'),
                style: TextStyle(backgroundColor: ColorBmi(viewModel.category(snapshot.data)).color),
                'BMI = ${snapshot.data}'),
            );
          }
        ),
      ],
    );
  }
}

class CalculateButton extends ConsumerWidget {
  const CalculateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        key: const Key('calculate_button'),
        onPressed: ref.watch(viewModelProvider).buttonStateHandler,
        child: const Text('Calculate')
    );
  }
}

class UnitToggle extends ConsumerWidget {
  const UnitToggle({
    super.key,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color primary = Theme.of(context).colorScheme.primary;
    
    return ToggleButtons(
      isSelected: Unit.values.map((e) => e == ref.watch(viewModelProvider.select((value) => value.unit))).toList(),
      selectedColor: Colors.white,
      color: primary,
      fillColor: primary,
      renderBorder: true,
      borderRadius: BorderRadius.circular(10),
      onPressed: ref.read(viewModelProvider).setUnit,
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
  });

  final String label;
  final bool isHeight;
  final double textfieldWidth;
  final TextEditingController textController;
  final Key textKey;

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
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: const [
                TextInputFormatter.withFunction(doubleInputChecker),
              ],
            ),
          ),
        ),
        UnitLabel(isHeight: isHeight),
      ],
    );
  }
}

class UnitLabel extends ConsumerWidget {
  const UnitLabel({
    super.key,
    required this.isHeight,
  });

  final bool isHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(viewModelProvider.select((value) => value.unit));
    return Text( isHeight ? unit.heightUnit : unit.weightUnit);
  }
}