import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

class BmiViewModel extends ChangeNotifier {
  final BmiModel _model;
  final _unitsLength = Unit.values.length;

  final heightTextController = TextEditingController();
  final weightTextController = TextEditingController();
  
  String? get bmi => _model.bmi?.toStringAsFixed(2);
  String get height => _model.height;
  String get weight => _model.weight;
  String? get errorMessage => _model.errorMessage;
  
  BmiCategory get category => switch(_model.bmi) {
    null => BmiCategory.unknown,
    < 18.5 => BmiCategory.underweight,
    >= 30 => BmiCategory.obese,
    >= 25 => BmiCategory.overweight,
    _ => BmiCategory.normal,
  };

  
  Unit get unit => _model.unit;
  void setUnit(int index){
    index < _unitsLength
    ? _model.unit = Unit.values[index]
    : throw UnimplementedError('This unit is not implemented');
    notifyListeners();
  }

  Function()? get buttonStateHandler => 
    height.isNotEmpty && weight.isNotEmpty 
    && height != '.' && weight != '.'
    ? calculate 
    : null;
  
  BmiViewModel({
    required model
  }) : _model = model {

    init();
  }

  init(){
    heightTextController.addListener((){
      _model.height = heightTextController.text;
      notifyListeners();
    });
    weightTextController.addListener((){
      _model.weight = weightTextController.text;
      notifyListeners();
    });
  }

  void calculate(){
    double height;
    double weight;

    // Button is active when height and weight have valid data
    height = double.parse(this.height);
    weight = double.parse(this.weight);
      
    if(height == 0){
        _model.bmi = null;
        _model.errorMessage = 'Wrong input - 0 height is impossible!';
        notifyListeners();
        return;
    }
    _model.errorMessage = null;
    _model.bmi = (weight / (pow(height, 2)) * unit.conversionFactor);
    notifyListeners();
  }
}