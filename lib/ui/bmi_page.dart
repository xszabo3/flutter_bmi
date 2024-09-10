import 'package:flutter/material.dart';

import 'package:flutter_bmi/utils/constants.dart' as constants;

class BmiPage extends StatelessWidget {
  const BmiPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const InputRow(label: "Weight:", textfieldWidth: constants.textfieldWidth, unit: constants.Units.metricWeight),
          const InputRow(label: "Height:", textfieldWidth: constants.textfieldWidth, unit: constants.Units.metricHeight,),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () { print('Button pressed'); }, child: const Text('Use imperial')), //TODO Use something better
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
  }
}

class InputRow extends StatelessWidget {
  const InputRow({
    super.key,
    required this.label,
    required this.textfieldWidth,
    required this.unit
  });

  final String label;
  final double textfieldWidth;
  final String unit;

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
        Text(unit), //TODO swap later
      ],
    );
  }
}