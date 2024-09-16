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
  unknown,
  underweight,
  normal,
  overweight,
  obese
}

class BmiModel{
  Unit unit = Unit.metric;
  String height = '';
  String weight = '';
  String? bmi;
  String? errorMessage;
  BmiCategory category = BmiCategory.unknown;
}