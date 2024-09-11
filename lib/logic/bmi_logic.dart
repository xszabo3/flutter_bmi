import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

class BmiViewModel extends ChangeNotifier {
  final BmiModel model;
  Unit? unit = Unit.values.first;
  String? errorMessage;

  BmiViewModel({
    required this.model
  });

  Future<void> currentUnit() async {
    try {
      unit = (await model.loadFromServer());
    } catch (e) {
      errorMessage = 'Could not get the Unit from the server';
    }
    notifyListeners();
  }

  Future<void> switchUnit() async {
    if (unit == null) {
      throw('Not initialized');
    }

    try {
      unit = await model.switchUnit();
    } catch(e) {
      errorMessage = 'Count not switch unit';
    }
    notifyListeners();
  }
}