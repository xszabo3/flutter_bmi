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

class BmiData{ //TODO remove
  Unit unit;
  String height;
  String weight;
  String? bmi;
  String? errorMessage;
  BmiCategory category;

  BmiData({
    required this.unit, 
    required this.height, 
    required this.weight,
    required this.category,
  });
}

class BmiModel{
  Unit unit = Unit.metric;
  String height = '';
  String weight = '';
  String? bmi;
  String? errorMessage;
  BmiCategory category = BmiCategory.unknown;

  final _unitsLength = Unit.values.length;

  void setUnit(int index){
    index < _unitsLength
    ? unit = Unit.values[index]
    : throw UnimplementedError('This unit is not implemented');
  }
}