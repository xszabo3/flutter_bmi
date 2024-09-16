import 'package:flutter_bmi/logic/bmi_logic.dart';
import 'package:flutter_bmi/model/bmi_model.dart';
import 'package:test/test.dart';

void main() {
  late final BmiViewModel viewModel;

  group('Logic tests', () {
    setUpAll(() async {
      viewModel = BmiViewModel(model: BmiModel(Unit.metric, null, null, null));
    });
    
    group('Unit-calculation tests', () {
      test('Test metric calculation', () async {
        viewModel.setUnit(Unit.metric.index);
        viewModel.heightTextController.text = '1.78';
        viewModel.weightTextController.text = '60';
      
        viewModel.calculate();

        expect(viewModel.bmi, '18.94');
      });

      test('Test imperial calculation', () async {
        viewModel.setUnit(Unit.imperial.index);
        viewModel.heightTextController.text = '70.07';
        viewModel.weightTextController.text = '132.27';
      
        viewModel.calculate();

        expect(viewModel.bmi, '18.94');
      });
    });

    group('Category tests', () {
      
    });
  });
}