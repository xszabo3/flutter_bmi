import 'package:flutter_bmi/logic/bmi_logic.dart';
import 'package:flutter_bmi/model/bmi_model.dart';
import 'package:test/test.dart';

void main() {
  group('Unit-switching tests', () {
    late final BmiViewModel viewModel;

    setUpAll(() async {
      viewModel = BmiViewModel(model: BmiModel());
    });

    test('Test 0 division', () async {
      viewModel.weightTextController.text = '60';
      viewModel.heightTextController.text = '0';
    
      viewModel.calculate();

      expect(viewModel.bmi, null);
    });
    
    test('Test metric calculation', () async {
      viewModel.unit = Unit.metric;
      viewModel.heightTextController.text = '1.78';
      viewModel.weightTextController.text = '60';
    
      viewModel.calculate();

      expect(viewModel.bmi, '18.94');
    });

    test('Test imperial calculation', () async {
      viewModel.unit = Unit.imperial;
      viewModel.heightTextController.text = '70.07';
      viewModel.weightTextController.text = '132.27';
    
      viewModel.calculate();

      expect(viewModel.bmi, '18.94');
    });
  });
}