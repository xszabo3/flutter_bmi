import 'package:flutter/material.dart';
import 'package:flutter_bmi/model/bmi_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

extension BmiModelExt on BmiModel {
  BmiModel copyWith({Unit? unit, (double?,)? height, (double?,)? weight, BmiResultState? bmiState}) {
    return BmiModel(
      unit ?? this.unit, 
      height != null ? height.$1 : this.height, 
      weight != null ? weight.$1 : this.weight,
      bmiState ?? this.bmiState,
    );
  }

  bool get valid => height != null && weight != null && height! > 0 && weight! > 0;
}

class BmiViewModel extends Notifier<BmiModel> {

  final BmiModel? initial;

  BmiViewModel({this.initial});

  @override
  BmiModel build() {
    ref.onDispose(() {
        heightTextController.removeListener(updateHeight);
        weightTextController.removeListener(updateWeight);
    });

    heightTextController.addListener(updateHeight);
    weightTextController.addListener(updateWeight);

    return initial != null ? initial! : const BmiModel(Unit.metric, null, null, BmiHiddenResult());
  }

  final heightTextController = TextEditingController();
  final weightTextController = TextEditingController();
  
  void setUnit(int index){
    assert(index >= 0 && index < Unit.values.length);
    final newUnit = Unit.values[index];
    
    final height = converter(state.height, newUnit.heightconverter);
    final weight = converter(state.weight, newUnit.weightconverter);

    update(unit: newUnit, height: (height.$2,), weight: (weight.$2,));

    heightTextController.text = height.$1;
    weightTextController.text = weight.$1;
  }

  void Function()? get calcHandler => state.valid ? () => update(bmiState: BmiCalculateResult()) : null;

  @visibleForTesting
  (String, double?) converter(double? state, double conversionFactor) {
      final value = state != null ? state * conversionFactor : null;

      return (value?.toString() ?? '', value);
  }

  @visibleForTesting
  void update({Unit? unit, (double?,)? height, (double?,)? weight, BmiResultState? bmiState}) {
    state = state.copyWith(
      unit: unit,
      height: height,
      weight: weight,
      bmiState: bmiState,
    );
  }

  @visibleForTesting
  void updateHeight()
  {
      var height = double.tryParse(heightTextController.text);
      if (height != state.height) update(height: (height,), bmiState: const BmiHiddenResult());
  }

  @visibleForTesting
  void updateWeight()
  {
      var weight = double.tryParse(weightTextController.text);
      if(weight != state.weight) update(weight: (weight,), bmiState: const BmiHiddenResult());
  }
}

Future<(double,)> calculate(BmiModel model) async {
    assert(model.valid);
    return Future.delayed(const Duration(seconds: 3), 
      () { 
        if(model.weight == 1) return Future.error(AssertionError("That's a lie!"));
        return ((model.weight! / (model.height! * model.height!)) * model.unit.conversionFactor,);
      });
  }

final bmiViewModelProvider = NotifierProvider<BmiViewModel, BmiModel>(() {
  return BmiViewModel();
});

final bmiResultProvider = FutureProvider<BmiResult>((ref) async {
  final state = ref.watch(bmiViewModelProvider.select((v) => v.bmiState));

  return switch (state) {
    BmiHiddenResult _ => (null,),
    BmiCalculateResult _ => calculate(ref.read(bmiViewModelProvider))
  };
});
