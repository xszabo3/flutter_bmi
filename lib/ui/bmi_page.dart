import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bmi/logic/bmi_logic.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

import 'package:flutter_bmi/utils/constants.dart' as constants;
import 'package:provider/provider.dart';

extension Capitalize on String{
  String capitalize() {
    return '${this[0].toUpperCase()}''${substring(1)}';
  }
}

extension ColorBmi on BmiCategory{
  Color get color {
    switch(this) {
      case BmiCategory.unknown: return Colors.transparent;
      case BmiCategory.underweight: return Colors.yellow;
      case BmiCategory.normal: return Colors.green;
      case BmiCategory.overweight: return Colors.orange;
      case BmiCategory.obese: return Colors.red;
    }
  }
} 

class BmiPage extends StatelessWidget {
  const BmiPage({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BmiViewModel(model: BmiModel(Unit.metric, null, null, null))),
      ],
      child: Consumer<BmiViewModel>(builder: (_, model, child) {
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

class PageContents extends StatelessWidget {
  const PageContents({
    super.key,
    required this.viewModel
  });

  final BmiViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        InputRow(label: "Weight:", textfieldWidth: constants.textfieldWidth, isHeight: false,
          textController: viewModel.weightTextController , textKey: const Key('weight'),viewModel: viewModel,),
        InputRow(label: "Height:", textfieldWidth: constants.textfieldWidth, isHeight: true, 
          textController: viewModel.heightTextController, textKey: const Key('height'),viewModel: viewModel,),
        const SizedBox(height: 20,),
        
        //Buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: UnitToggle(viewModel: viewModel,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CalculateButton(viewModel: viewModel,),
        ),
        //Result
        if(viewModel.bmi != null)...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              key: const Key('result'),
              style: TextStyle(backgroundColor: ColorBmi(viewModel.category).color),
              'BMI = ${viewModel.bmi}'),
          )
        ],
      ],
    );
  }
}

class CalculateButton extends StatelessWidget {
  const CalculateButton({
    super.key,
    required this.viewModel
  });

  final BmiViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        key: const Key('calculate_button'),
        onPressed: viewModel.buttonStateHandler,
        child: const Text('Calculate')
    );
  }
}

class UnitToggle extends StatefulWidget {
  const UnitToggle({
    super.key,
    required this.viewModel
  });

  final BmiViewModel viewModel;

  @override
  State<UnitToggle> createState() => _UnitToggleState();
}

class _UnitToggleState extends State<UnitToggle> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    
    return ToggleButtons(
      isSelected: isSelected,
      selectedColor: Colors.white,
      color: primary,
      fillColor: primary,
      renderBorder: true,
      borderRadius: BorderRadius.circular(10),
      onPressed: (int newIndex) {
        widget.viewModel.setUnit(newIndex);
        setState(() {
          for (int index = 0; index < isSelected.length; index++) {
            if (index == newIndex) {
              isSelected[index] = true;
            } else {
              isSelected[index] = false;
            }
          }
        });
      },
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Metric'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Imperial'),
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
    required this.viewModel
  });

  final BmiViewModel viewModel;
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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.isEmpty || newValue.text == '.'){
                    return newValue;
                  }

                  final value = double.tryParse(newValue.text);
                  return value != null && value > 0
                  ? newValue 
                  : oldValue;
                },)
              ],
            ),
          ),
        ),
        Text( isHeight ? viewModel.unit.heightUnit : viewModel.unit.weightUnit),
      ],
    );
  }
}