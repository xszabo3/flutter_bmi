import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

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

sealed class BmiResultState {
    const BmiResultState();
}

class BmiHiddenResult implements BmiResultState {
    const BmiHiddenResult();
}

class BmiCalculateResult implements BmiResultState {
  @override
  operator==(Object other){
    return other.runtimeType == BmiCalculateResult;
  }
  
  @override
  int get hashCode => runtimeType.hashCode;
}

enum BmiCategory{
  underweight,
  normal,
  overweight,
  obese
}

typedef BmiResult = (double?,);

extension ResultCategory on BmiResult {
  BmiCategory get category => switch($1) {
    null => BmiCategory.normal,
    < 18.5 => BmiCategory.underweight,
    >= 30 => BmiCategory.obese,
    >= 25 => BmiCategory.overweight,
    _ => BmiCategory.normal,
  };
}

@immutable
class BmiModel extends Equatable {
  final Unit unit;
  final double? height;
  final double? weight;
  final BmiResultState bmiState;

  const BmiModel(this.unit, this.height, this.weight, this.bmiState);
  
  @override
  List<Object?> get props => [unit, height, weight, bmiState];
}
