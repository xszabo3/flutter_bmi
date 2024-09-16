enum Unit{
  metric(heightUnit: 'm', weightUnit: 'kg', conversionFactor: 1),
  imperial(heightUnit: 'in', weightUnit: 'lb', conversionFactor: 703);

  const Unit({
    required this.heightUnit,
    required this.weightUnit,
    required this.conversionFactor
  });

  final String heightUnit;
  final String weightUnit;
  final double conversionFactor;
}

enum BmiCategory{
  underweight,
  normal,
  overweight,
  obese
}

class BmiModel{
  final Unit unit;
  final double? height;
  final double? weight;
  final double? bmi;
  
  bool get valid => height != null && weight != null && height! > 0 && weight! > 0;
  BmiCategory get category => switch(bmi) {
    null => BmiCategory.normal,
    < 18.5 => BmiCategory.underweight,
    >= 30 => BmiCategory.obese,
    >= 25 => BmiCategory.overweight,
    _ => BmiCategory.normal,
  };

  BmiModel(this.unit, this.height, this.weight, this.bmi);
}