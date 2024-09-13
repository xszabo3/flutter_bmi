import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

class BmiViewModel extends ChangeNotifier {
  final BmiModel model;
  Unit unit = Unit.values.first;
  String? errorMessage;
  final heightTextController = TextEditingController();
  final weightTextController = TextEditingController();
  String? bmi;

  Function()? get buttonStateHandler => 
    heightTextController.text.isNotEmpty && weightTextController.text.isNotEmpty 
    && heightTextController.text != '.' && weightTextController.text != '.'
    ? calculate 
    : null;

  BmiViewModel({
    required this.model
  });

  @override
  void dispose() {  
    heightTextController.dispose();
    weightTextController.dispose();
    super.dispose();
  }

  Future<void> currentUnit() async {
    try {
      unit = (await model.loadFromServer());
    } catch (e) {
      errorMessage = 'Could not get the Unit from the server';
    }
    notifyListeners();
  }

  Future<void> switchUnit() async {
    try {
      unit = await model.switchUnit();
    } catch(e) {
      errorMessage = 'Cannot switch unit';
    }
    notifyListeners();
  }

  void calculate(){
    double height;
    double weight;
    try{
      height = double.parse(heightTextController.text);
      weight = double.parse(weightTextController.text);
    }on FormatException {
      errorMessage = 'The input is not a valid number. Use "." for decimal delimeter';
      bmi = null;
      notifyListeners();
      return;
    }
    errorMessage = null;
      
    if(height == 0){
        bmi = null;
        notifyListeners();
        return;
    }

    bmi = (weight / (pow(height, 2)) * unit.conversionFactor).toStringAsFixed(2);
    notifyListeners();
  }
}