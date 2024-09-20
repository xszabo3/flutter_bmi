import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bmi_logic.g.dart';

extension BmiModelExt on BmiModel {
  BmiModel copyWith({Unit? unit, (double?,)? height, (double?,)? weight, bool? bmiState}) {
    return BmiModel(
      unit ?? this.unit, 
      height != null ? height.$1 : this.height, 
      weight != null ? weight.$1 : this.weight,
      bmiState ?? this.bmiState,
    );
  }
}

@Riverpod(keepAlive: true)
class BmiViewModel extends _$BmiViewModel {

  @override
  BmiModel build() {
    return const BmiModel(Unit.metric, null, null, false);
  }

  final heightTextController = TextEditingController();
  final weightTextController = TextEditingController();
  
  double? get height => state.height;
  double? get weight => state.weight;
  Unit get unit => state.unit;
  BmiCategory Function(double? input) get category => state.category;

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

  void update({Unit? unit, (double?,)? height, (double?,)? weight, bool? bmiState}){
    state = state.copyWith(
      unit: unit,
      height: height,
      weight: weight,
      bmiState: bmiState,
    );
  }

  set height(double? value){
    _update = state.copyWith(height: (value,));
  }

  set weight(double? value){
    _update = state.copyWith(weight: (value,));
  }
  
  BmiViewModel() {
    init();
  }

  void init(){
    heightTextController.addListener((){
      var height = double.tryParse(heightTextController.text);
      if(height == this.height){
        return;   
      }
      update(height: (height,), weight: null, bmiState: false);
    });
    weightTextController.addListener((){
      var weight = double.tryParse(weightTextController.text);
      if(weight == this.weight){
        return;   
      }
      update(weight: (weight,), bmiState: false);
    });
  }
}

final bmiProvider = FutureProvider((ref) async {
  final uiState = ref.read(bmiViewModelProvider);
  if(uiState.valid) return uiState.calculate();
  return (null,);
});