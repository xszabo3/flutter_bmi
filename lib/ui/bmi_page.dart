import 'package:flutter/material.dart';
import 'package:flutter_bmi/logic/calculation.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

import 'package:flutter_bmi/utils/constants.dart' as constants;

class BmiPage extends StatefulWidget {
  const BmiPage({
    super.key,
  });

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  
  final BmiViewModel viewModel = BmiViewModel(BmiModel());

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: viewModel, builder: (context, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(viewModel.errorMessage != null) 
              Text(
                'Error: ${viewModel.errorMessage}',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.apply(color: Colors.red),
              ),
            
            InputRow(label: "Weight:", textfieldWidth: constants.textfieldWidth, unit: viewModel.unit!, isHeight: false),
            InputRow(label: "Height:", textfieldWidth: constants.textfieldWidth, unit: viewModel.unit!, isHeight: true,),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () { 
                  viewModel.switchUnit();
                }, 
                child: const Text('Switch units')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () { print('Button pressed'); }, child: const Text('Calculate')),
            ),
            const Text('Result:'),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('0 BMI'),
            )
          ],
      );
    },);
  }
    
}

class InputRow extends StatelessWidget {
  const InputRow({
    super.key,
    required this.label,
    required this.textfieldWidth,
    required this.unit,
    required this.isHeight,
  });

  final String label;
  final double textfieldWidth;
  final Unit unit;
  final bool isHeight;

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
            child: const TextField(),
          ),
        ),
        Text(isHeight ? unit.heightUnit : unit.weightUnit),
      ],
    );
  }
}