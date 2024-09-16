import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

class BmiViewModel extends ChangeNotifier {
  BmiModel _model;
  final _unitsLength = Unit.values.length;

  final heightTextController = TextEditingController();
  final weightTextController = TextEditingController();
  
  String? get bmi => _model.bmi?.toStringAsFixed(2);
  double? get height => _model.height;
  double? get weight => _model.weight;
  Unit get unit => _model.unit;
  
  BmiCategory get category => switch(_model.bmi) {
    null => BmiCategory.normal,
    < 18.5 => BmiCategory.underweight,
    >= 30 => BmiCategory.obese,
    >= 25 => BmiCategory.overweight,
    _ => BmiCategory.normal,
  };

  void setUnit(int index){
    index < _unitsLength
    ? _model = BmiModel(Unit.values[index], _model.height, _model.weight, _model.bmi)
    : throw UnimplementedError('This unit is not implemented');
    notifyListeners();
  }

  set height(double? value){
    _model = BmiModel(unit, value, _model.weight, _model.bmi);
  }

  set weight(double? value){
    _model = BmiModel(unit, _model.height, value, _model.bmi);
  }

  set _bmi(double? value){
    _model = BmiModel(unit, _model.height, _model.weight, value);
  }



  Function()? get buttonStateHandler => 
    height == null || weight == null
    ? null 
    : calculate;
  
  BmiViewModel({
    required model
  }) : _model = model {

    init();
  }

  void init(){
    heightTextController.addListener((){
      height = double.tryParse(heightTextController.text);
      notifyListeners();
    });
    weightTextController.addListener((){
      weight = double.tryParse(weightTextController.text);
      notifyListeners();
    });
  }

  void calculate(){
    // Button is disabled if either height or weight is null
    _bmi = (weight! / (pow(height!, 2)) * unit.conversionFactor);
    notifyListeners();
  }
}