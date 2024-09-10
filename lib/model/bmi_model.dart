enum Unit{
  metric(heightUnit: 'cm', weightUnit: 'kg'),
  imperial(heightUnit: 'foot', weightUnit: 'pounds');

  const Unit({
    required this.heightUnit,
    required this.weightUnit,
  });

  final String heightUnit;
  final String weightUnit;
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