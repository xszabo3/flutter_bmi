import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

extension BmiModelExt on BmiModel {
  BmiModel copyWith({Unit? unit, double? height, double? weight, Future<double?>? bmi}){
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
  final resultController = TextEditingController();
  
  Future<double?> get bmi => _model.bmi;
  double? get height => _model.height;
  double? get weight => _model.weight;
  Unit get unit => _model.unit;
  BmiCategory Function(double? input) get category => _model.category;
  //BmiCategory get category => _model.category();

  String converter(double? state, double conversionFactor){
      return state != null 
        ? (state * conversionFactor).toStringAsFixed(2) 
        : '';
  }

  set _update(BmiModel model){
    _model = model;
    notifyListeners();
  }

  void _clearBmi(){
    _model = BmiModel(
      unit, 
      height, 
      weight,
      Future.value(null),
    );
    notifyListeners();
  }

  void setUnit(int index){
    assert(index >= 0 && index < Unit.values.length);
    final newUnit = Unit.values[index];
    _update = _model.copyWith(unit: newUnit);
    
    heightTextController.text = converter(height, newUnit.heightconverter);
    weightTextController.text = converter(weight, newUnit.weightconverter);
  }

  set height(double? value){
    _update = _model.copyWith(height: value);
  }

  set weight(double? value){
    _update = _model.copyWith(weight: value);
  }

  set _bmi(Future<double?> value){
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
      _clearBmi();
    });
    weightTextController.addListener((){
      weight = double.tryParse(weightTextController.text);
      _clearBmi();
    });
  }

  void calculate() async {
    assert(_model.valid);
    _bmi = _model.calculate().catchError((err) {
      _clearBmi();
      throw err;
    });
    notifyListeners();
  }
}