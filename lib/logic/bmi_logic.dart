import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

extension BmiModelExt on BmiModel {
  BmiModel copyWith({Unit? unit, double? height, double? weight, double? bmi}){
    return BmiModel(
      unit ?? this.unit, 
      height ?? this.height, 
      weight ?? this.weight,
      bmi ?? this.bmi
    );
  }
}

class BmiViewModel extends ChangeNotifier {
  BmiModel _model;

  final heightTextController = TextEditingController();
  final weightTextController = TextEditingController();
  
  String? get bmi => _model.bmi?.toStringAsFixed(2);
  double? get height => _model.height;
  double? get weight => _model.weight;
  Unit get unit => _model.unit;
  BmiCategory get category => _model.category;

  set _update(BmiModel model){
    _model = model;
    notifyListeners();
  }

  void setUnit(int index){
    assert(index >= 0 && index < Unit.values.length);

    _update = _model.copyWith(unit: Unit.values[index]);
  }

  set height(double? value){
    _update = _model.copyWith(height: value);
  }

  set weight(double? value){
    _update = _model.copyWith(weight: value);
  }

  set _bmi(double? value){
    _update = _model.copyWith(bmi: value);
  }

  Function()? get buttonStateHandler => 
    _model.valid
      ? calculate
      : null;
  
  BmiViewModel({
    required model
  }) : _model = model {

    init();
  }

  void init(){
    heightTextController.addListener((){
      height = double.tryParse(heightTextController.text);
    });
    weightTextController.addListener((){
      weight = double.tryParse(weightTextController.text);
    });
  }

  void calculate(){
    assert(_model.valid);
    _bmi = (weight! / (pow(height!, 2)) * unit.conversionFactor);
  }
}