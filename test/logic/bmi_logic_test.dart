import 'package:flutter_bmi/logic/bmi_logic.dart';
import 'package:flutter_bmi/model/bmi_model.dart';
import 'package:riverpod_test/riverpod_test.dart';
import 'package:test/test.dart';

void main() {
  bmiViewModelProviderTests();
}


void bmiViewModelProviderTests(){
  testNotifier<BmiViewModel, BmiModel>(
    'Provider initialization test',
    provider: bmiViewModelProvider,
    act: (notifier) => notifier.setUnit(0),
    expect: () => const [BmiModel(Unit.metric, null, null, BmiHiddenResult())],
  );

  testNotifier<BmiViewModel, BmiModel>(
    'Test switching to imperial',
    provider: bmiViewModelProvider,
    act: (notifier) => notifier.setUnit(1),
    expect: () => const [BmiModel(Unit.imperial, null, null, BmiHiddenResult())],
  );

  testNotifier<BmiViewModel, BmiModel>(
    'Test update',
    provider: bmiViewModelProvider,
    act: (notifier) => notifier
      ..update(height: (1,))
      ..update(weight: (2,))
      ..update(weight: (5,), height: (6,), bmiState: BmiCalculateResult())
      ..update(weight: (5,), height: (6,), bmiState: BmiCalculateResult()),
    expect: () => [
      const BmiModel(Unit.metric, 1, null, BmiHiddenResult()),
      const BmiModel(Unit.metric, 1, 2, BmiHiddenResult()),
      BmiModel(Unit.metric, 6, 5, BmiCalculateResult(),),
      isNot(const BmiModel(Unit.metric, 6, 5, BmiHiddenResult(),))
    ],
  );
}

void old(){
  group('Logic tests', () {
    group('Unit-calculation tests', () {
      
        //viewModel.setUnit(Unit.metric.index);
        //viewModel.heightTextController.text = '1.78';
        //viewModel.weightTextController.text = '60';

        //expect(bmiProvider., '18.94'); TODO
      

      /*test('Test imperial calculation', () async {
        viewModel.setUnit(Unit.imperial.index);
        viewModel.heightTextController.text = '70.07';
        viewModel.weightTextController.text = '132.27';
      
        //viewModel.calculate();

        //expect(viewModel.bmi, '18.94'); TODO
      });*/
    });

    group('Category tests', () {
      /*test('Category ', () async {
        //viewModel.calculate();

        expect(viewModel.category, BmiCategory.normal);

        viewModel.heightTextController.text = '1';
        viewModel.weightTextController.text = '10';
        
        //viewModel.calculate();

        expect(viewModel.category, BmiCategory.underweight);
      
        viewModel.weightTextController.text = '25';
        
        //viewModel.calculate();

        expect(viewModel.category, BmiCategory.overweight);

        viewModel.weightTextController.text = '250';
        
        //viewModel.calculate();

        expect(viewModel.category, BmiCategory.obese);
      });*/
    });
  });
}