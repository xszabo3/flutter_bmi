import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bmi_logic.g.dart';

extension BmiModelExt on BmiModel {
  BmiModel copyWith({Unit? unit, (double?,)? height, (double?,)? weight, (Future<double>?,)? bmi}) {
    return BmiModel(
      unit ?? this.unit, 
      height != null ? height.$1 : this.height, 
      weight != null ? weight.$1 : this.weight,
      bmi != null ? bmi.$1 : this.bmi
    );
  }
}

@riverpod
class BmiViewModel extends _$BmiViewModel {
  //BmiModel _model;

  @override
  BmiModel build() {
    return const BmiModel(Unit.metric, null, null, null);
  }

  final heightTextController = TextEditingController();
  final weightTextController = TextEditingController();
  
  Future<double>? get bmi => state.bmi;
  double? get height => state.height;
  double? get weight => state.weight;
  Unit get unit => state.unit;
  BmiCategory Function(double? input) get category => state.category;
  bool get valid => state.valid;

  String converter(double? state, double conversionFactor){
      return state != null 
        ? (state * conversionFactor).toStringAsFixed(2) 
        : '';
  }

  set _update(BmiModel model){
    state = model;
  }

  void setUnit(int index){
    assert(index >= 0 && index < Unit.values.length);
    final newUnit = Unit.values[index];
    _update = state.copyWith(unit: newUnit);
    
    heightTextController.text = converter(height, newUnit.heightconverter);
    weightTextController.text = converter(weight, newUnit.weightconverter);
  }

  void update({Unit? unit, (double?,)? height, (double?,)? weight, (Future<double>?,)? bmi}){
    state = state.copyWith(
      unit: null,
      height: height,
      weight: weight,
      bmi: bmi,
    );
  }

  set height(double? value){
    _update = state.copyWith(height: (value,));
  }

  set weight(double? value){
    _update = state.copyWith(weight: (value,));
  }

  set _bmi(Future<double>? value){
    _update = state.copyWith(bmi: (value,));
  }

  Function()? get buttonStateHandler => 
    state.valid
      ? calculate
      : null;
  
  BmiViewModel() {
    init();
  }

  void init(){
    heightTextController.addListener((){
      var height = double.tryParse(heightTextController.text);
      if(height == this.height){
        return;   
      }
      update(height: (height,), weight: null, bmi: (null,));
    });
    weightTextController.addListener((){
      var weight = double.tryParse(weightTextController.text);
      if(weight == this.weight){
        return;   
      }
      update(weight: (weight,), bmi: (null,));
    });
  }

  void calculate() async {
    assert(state.valid);
    _bmi = state.calculate();
  }
}

/*final viewModelProvider = NotifierProvider<_$BmiViewModel, BmiModel>(() {
  return BmiViewModel();
});*/

/*@riverpod
Future<double> bmi(BmiRef ref) { // TODO use later
  return Future.value(1);
}*/