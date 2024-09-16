import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

class BmiViewModel extends ChangeNotifier {
  final BmiModel _model;
  final _unitsLength = Unit.values.length;

  final heightTextController = TextEditingController();
  final weightTextController = TextEditingController();
  
  String? get bmi => _model.bmi;
  String get height => _model.height;
  String get weight => _model.weight;
  String? get errorMessage => _model.errorMessage;

  
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

  /*Future<void> currentUnit() async { //TODO
    try {
      unit = (await model.loadFromServer());
    } catch (e) {
      errorMessage = 'Could not get the Unit from the server';
    }
    notifyListeners();
  }

  Future<void> switchUnit() async {
    try {
      unit = 
    } catch(e) {
      errorMessage = 'Cannot switch unit';
    }
    notifyListeners();
  }*/

  void calculate(){
    double height;
    double weight;
    try{
      height = double.parse(this.height);
      weight = double.parse(this.weight);
    }on FormatException {
      _model.errorMessage = 'The input is not a valid number. Use "." for decimal delimeter';
      _model.bmi = null;
      notifyListeners();
      return;
    }
    _model.errorMessage = null;
      
    if(height == 0){
        _model.bmi = null;
        notifyListeners();
        return;
    }

    _model.bmi = (weight / (pow(height, 2)) * unit.conversionFactor).toStringAsFixed(2);
    notifyListeners();
  }
}