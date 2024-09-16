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
  
  BmiModel(this.unit, this.height, this.weight, this.bmi);
}