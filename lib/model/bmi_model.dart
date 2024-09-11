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

class BmiModel{
  int index = 0;
  final units = Unit.values;
  final unitsLength = Unit.values.length;
  
  //Server simulation
  Future<Unit> loadFromServer() async {
    return await Future.value(Unit.values[index]);
  }

  //Allows multiple units in the future
  Future<Unit> switchUnit() async{
    index = ++index % unitsLength;
    return await loadFromServer();
  }
}