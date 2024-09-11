import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bmi/logic/bmi_logic.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

import 'package:flutter_bmi/utils/constants.dart' as constants;

extension Capitalize on String{
  String capitalize() {
    return '${this[0].toUpperCase()}''${substring(1)}';
  }
}

class BmiPage extends StatefulWidget {
  const BmiPage({
    super.key,
  });

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  
  var viewModel = BmiViewModel(model: BmiModel());

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel, 
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(viewModel.errorMessage != null)...[
                Text(
                  key: const Key('error'),
                  'Error: ${viewModel.errorMessage}',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.apply(color: Colors.red),
                ),
              ],
              
              ValueListenableBuilder(
                valueListenable: viewModel.heightTextController, 
                builder: (context, TextEditingValue valueHeight, __) {
                  return ValueListenableBuilder(
                    valueListenable: viewModel.weightTextController, 
                    builder: (context, TextEditingValue valueHeight, __) {
                      return PageContents(viewModel: viewModel);
                    }
                  );
                }
              ),
            ],
        );
      },
    );
  }
}

class PageContents extends StatelessWidget {
  const PageContents({
    super.key,
    required this.viewModel,
  });

  final BmiViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputRow(label: "Weight:", textfieldWidth: constants.textfieldWidth, unit: viewModel.unit,
          isHeight: false, textController: viewModel.weightTextController, textKey: const Key('weight'),),
        InputRow(label: "Height:", textfieldWidth: constants.textfieldWidth, unit: viewModel.unit, 
          isHeight: true, textController: viewModel.heightTextController, textKey: const Key('height'),),
        const SizedBox(height: 20,),
        
        //Buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () { 
              viewModel.switchUnit();
            }, 
            child: Text(viewModel.unit.name.capitalize())),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            key: const Key('calculate_button'),
            onPressed: viewModel.heightTextController.text.isNotEmpty && viewModel.weightTextController.text.isNotEmpty ?
              () { viewModel.calculate(); } : 
              null,
            child: const Text('Calculate')
          ),
        ),
        //Result
        if(viewModel.bmi != null)...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(key: const Key('result'),
              'BMI = ${viewModel.bmi}'),
          )
        ],
      ],
    );
  }
}

class InputRow extends StatelessWidget {
  const InputRow({
    super.key,
    required this.label,
    required this.textfieldWidth,
    required this.unit,
    required this.isHeight,
    required this.textController,
    required this.textKey,
  });

  final String label;
  final double textfieldWidth;
  final Unit unit;
  final bool isHeight;
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
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
            ),
          ),
        ),
        Text(isHeight ? unit.heightUnit : unit.weightUnit),
      ],
    );
  }
}