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

class BmiData{
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
  final _unitsLength = Unit.values.length;
  final BmiData _data = BmiData(unit: Unit.metric, height: '0', weight: '0', category: BmiCategory.unknown);

  BmiData get data => _data;

  void setUnit(int index){
    index < _unitsLength
    ? _data.unit = Unit.values[index]
    : throw UnimplementedError('This unit is not implemented');
  }
}