import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension BmiModelExt on BmiModel {
  BmiModel copyWith({Unit? unit, double? Function()? height, double? Function()? weight, Future<double?>? bmi}) {
    return BmiModel(
      unit ?? this.unit, 
      height != null ? height() : this.height, 
      weight != null ? weight() : this.weight,
      bmi ?? this.bmi
    );
  }
}

class BmiViewModel extends ChangeNotifier {
  BmiModel _model;

  final heightTextController = TextEditingController();
  final weightTextController = TextEditingController();
  
  Future<double?> get bmi => _model.bmi;
  double? get height => _model.height;
  double? get weight => _model.weight;
  Unit get unit => _model.unit;
  BmiCategory Function(double? input) get category => _model.category;

  String converter(double? state, double conversionFactor){
      return state != null 
        ? (state * conversionFactor).toStringAsFixed(2) 
        : '';
  }

  set _update(BmiModel model){
    _model = model;
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
    _update = _model.copyWith(height: () => value);
  }

  set weight(double? value){
    _update = _model.copyWith(weight: () => value);
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
      var height = double.tryParse(heightTextController.text);
      if(height == this.height){
        return;   
      }
      this.height = height;
      _bmi = Future.value(null);
    });
    weightTextController.addListener((){
      var weight = double.tryParse(weightTextController.text);
      if(weight == this.weight){
        return;   
      }
      this.weight = weight;
      _bmi = Future.value(null);
    });
  }

  void calculate() async {
    assert(_model.valid);
    _bmi = _model.calculate().catchError((err) {
      _bmi = Future.value(null);
      throw err;
    });
    notifyListeners();
  }
}

final viewModelProvider = ChangeNotifierProvider<BmiViewModel>((ref) {
  return BmiViewModel(model: BmiModel(Unit.metric, null, null, Future.value(null)));
});