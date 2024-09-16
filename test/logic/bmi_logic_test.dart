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

    group('Input tests', () {

      test('Test 0 division', () async {
        viewModel.weightTextController.text = '60';
        viewModel.heightTextController.text = '0';
      
        viewModel.calculate();

        expect(viewModel.bmi, null);
      });

      /*test('Test wrong input format: height', () async {
        viewModel.unit = Unit.imperial;
        viewModel.heightTextController.text = '70.07.4';
        viewModel.weightTextController.text = '132.27';
      
        viewModel.calculate();

        expect(viewModel.bmi, null);
        expect(viewModel.errorMessage, 'The input is not a valid number. Use "." for decimal delimeter');
      });*/

      /*test('Test wrong input format: weight', () async {
        viewModel.unit = Unit.imperial;
        viewModel.heightTextController.text = '704';
        viewModel.weightTextController.text = '132.27.4';
      
        viewModel.calculate();

        expect(viewModel.bmi, null);
        expect(viewModel.errorMessage, 'The input is not a valid number. Use "." for decimal delimeter');
      });*/
    });
  });

  // TODO colortests


}