import 'package:flutter/material.dart';

enum Unit{
  metric(heightUnit: 'm', weightUnit: 'kg', conversionFactor: 1, weightconverter: 0.4535924, heightconverter: 0.0254),
  imperial(heightUnit: 'in', weightUnit: 'lb', conversionFactor: 703, weightconverter: 2.204623, heightconverter: 39.37008);

  const Unit({
    required this.heightUnit,
    required this.weightUnit,
    required this.conversionFactor,
    required this.weightconverter,
    required this.heightconverter,
  });

  final String heightUnit;
  final String weightUnit;
  final double conversionFactor;
  final double weightconverter;
  final double heightconverter;
}
enum BmiState{
  hidden, value,
}



enum BmiCategory{
  underweight,
  normal,
  overweight,
  obese
}

@immutable
class BmiModel{
  final Unit unit;
  final double? height;
  final double? weight;
  final BmiState bmiState;

  const BmiModel(this.unit, this.height, this.weight, this.bmiState);

  bool get valid => height != null && weight != null && height! > 0 && weight! > 0;
  BmiCategory category(double? input) => switch(input) {
    null => BmiCategory.normal,
    < 18.5 => BmiCategory.underweight,
    >= 30 => BmiCategory.obese,
    >= 25 => BmiCategory.overweight,
    _ => BmiCategory.normal,
  };

  Future<(double,)> calculate() async {
    assert(valid);
    return Future.delayed(const Duration(seconds: 3), 
      () { 
        if(weight == 1) return Future.error(AssertionError("That's a lie!"));
        return ((weight! / (height! * height!)) * unit.conversionFactor,);
      });
  }
}