import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

class BmiViewModel extends ChangeNotifier {
  final BmiModel _model;
  String? errorMessage;
  final heightTextController = TextEditingController();
  final weightTextController = TextEditingController();
  
  String? get bmi => _model.data.bmi;
  String get height => _model.data.height;
  String get weight => _model.data.weight;
  
  Unit get unit => _model.data.unit;

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
      _model.data.height = heightTextController.text;
    });
    weightTextController.addListener((){
      _model.data.weight = weightTextController.text;
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

  void setUnit(int index){
    _model.setUnit(index);
    notifyListeners();
  }

  void calculate(){
    double height;
    double weight;
    try{
      height = double.parse(this.height);
      weight = double.parse(this.weight);
    }on FormatException {
      errorMessage = 'The input is not a valid number. Use "." for decimal delimeter';
      _model.data.bmi = null;
      notifyListeners();
      return;
    }
    errorMessage = null;
      
    if(height == 0){
        _model.data.bmi = null;
        notifyListeners();
        return;
    }

    _model.data.bmi = (weight / (pow(height, 2)) * unit.conversionFactor).toStringAsFixed(2);
    notifyListeners();
  }
}