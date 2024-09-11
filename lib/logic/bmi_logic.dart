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
      errorMessage = 'Count not switch unit';
    }
    notifyListeners();
  }

  void calculate(){
      final height = double.parse(heightTextController.text);
      final weight = double.parse(weightTextController.text);
      
      if(height == 0){
          bmi = null;
          notifyListeners();
          return;
      }

      bmi = (weight / (pow(height, 2)) * unit.conversionFactor).toStringAsFixed(2);
      notifyListeners();
  }
}