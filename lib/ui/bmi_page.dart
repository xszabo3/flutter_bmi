import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bmi/logic/bmi_logic.dart';
import 'package:flutter_bmi/model/bmi_model.dart';

import 'package:flutter_bmi/utils/constants.dart' as constants;
import 'package:provider/provider.dart';

extension Capitalize on String{
  String capitalize() {
    return '${this[0].toUpperCase()}''${substring(1)}';
  }
}

class BmiPage extends StatelessWidget {
  const BmiPage({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BmiViewModel(model: BmiModel())),
      ],
      child: Consumer<BmiViewModel>(builder: (_, model, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(model.errorMessage != null)...[
              Text(
                key: const Key('error'),
                'Error: ${model.errorMessage}',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.apply(color: Colors.red),
              ),
            ],
            child!
          ],
        );
      },
      child: const PageContents(),)    
    );
  }
}

class PageContents extends StatelessWidget {
  const PageContents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        InputRow(label: "Weight:", textfieldWidth: constants.textfieldWidth, isHeight: false,
          textController: Provider.of<BmiViewModel>(context, listen: false).weightTextController , textKey: const Key('weight'),),
        InputRow(label: "Height:", textfieldWidth: constants.textfieldWidth, isHeight: true, 
          textController: Provider.of<BmiViewModel>(context, listen: false).heightTextController, textKey: const Key('height'),),
        const SizedBox(height: 20,),
        
        //Buttons
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: UnitToggle(),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CalculateButton(),
        ),
        //Result
        Consumer<BmiViewModel>(builder: (_, model, child) {
          if(model.bmi != null){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                key: const Key('result'),
                style: model.bmi == null || model.bmi == 'null'
                  ? TextStyle(backgroundColor: Theme.of(context).colorScheme.primary)
                  : switch(model.category) {
                      BmiCategory.underweight => const TextStyle(backgroundColor: Colors.yellow),
                      BmiCategory.obese => const TextStyle(backgroundColor: Colors.red),
                      BmiCategory.overweight => const TextStyle(backgroundColor: Colors.orange),
                      _ => const TextStyle(backgroundColor: Colors.transparent),
                    },
                'BMI = ${model.bmi}'),
            );
          }
          return Container();
        })
      ],
    );
  }
}

class CalculateButton extends StatelessWidget {
  const CalculateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BmiViewModel>(builder: (_, model, child) {
      return ElevatedButton(
        key: const Key('calculate_button'),
        onPressed: model.buttonStateHandler,
        child: const Text('Calculate')
      );
    });
  }
}

class UnitToggle extends StatefulWidget {
  const UnitToggle({
    super.key,
  });

  @override
  State<UnitToggle> createState() => _UnitToggleState();
}

class _UnitToggleState extends State<UnitToggle> {
  List<bool> isSelected = [true, false];
  late BmiViewModel viewModelSet;

  @override
  void initState() {
    viewModelSet = Provider.of<BmiViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    
    return ToggleButtons(
      isSelected: isSelected,
      selectedColor: Colors.white,
      color: primary,
      fillColor: primary,
      renderBorder: true,
      borderRadius: BorderRadius.circular(10),
      onPressed: (int newIndex) {

        viewModelSet.setUnit(newIndex);
        setState(() {
          for (int index = 0; index < isSelected.length; index++) {
            if (index == newIndex) {
              isSelected[index] = true;
            } else {
              isSelected[index] = false;
            }
          }
        });
      },
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Metric'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Imperial'),
        ),
      ],
    );
  }
}

class InputRow extends StatelessWidget {
  const InputRow({
    super.key,
    required this.label,
    required this.textfieldWidth,
    required this.isHeight,
    required this.textController,
    required this.textKey,
  });

  final String label;
  final bool isHeight;
  final double textfieldWidth;
  final TextEditingController textController;
  final Key textKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: textfieldWidth,
            child: TextField(
              key: textKey,
              controller: textController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                TextInputFormatter.withFunction((oldValue, newValue) => newValue.text.isEmpty || newValue.text == '.' || double.tryParse(newValue.text) != null ? newValue : oldValue),
              ],
            ),
          ),
        ),
        Consumer<BmiViewModel>(
          builder: (_, model, child) {
            return Text( isHeight ?  model.unit.heightUnit : model.unit.weightUnit);
          } 
        ),
      ],
    );
  }
}