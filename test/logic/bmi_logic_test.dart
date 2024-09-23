import 'package:flutter_bmi/logic/bmi_logic.dart';
import 'package:flutter_bmi/model/bmi_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_test/riverpod_test.dart';
import 'package:test/test.dart';

class CategoryMatcher extends Matcher {

  const CategoryMatcher(this.expected);

  final BmiCategory expected;

  @override
  Description describe(Description description) {
    return description.add('Matches the bmi category in the model');
  }

  @override
  bool matches(item, Map matchState) {
    if(item is! AsyncData<(double?,)> || !item.hasValue){
      return false;
    }
    
    return ResultCategory(item.value).category == expected;
  }
}

void main() {
  bmiViewModelProviderTests();
  bmiProviderTests();
  categoryTests();
}

void bmiViewModelProviderTests(){
  group('bmiViewModelProviderTests', () {
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
  });
}

void bmiProviderTests(){
  group('bmiProviderTests', () {
    group('Unit-calculation tests', () {
      testProvider(
        'Test hidden state', 
        provider: bmiResultProvider,
        overrides: [bmiViewModelProvider.overrideWith(() => BmiViewModel(initial: const BmiModel(Unit.metric, 1.78, 60, BmiHiddenResult())))],
        wait: const Duration(seconds: 4),
        expect: () => [
          const AsyncLoading<BmiResult>(),
          const AsyncValue<BmiResult>.data((null,))
        ]
      );

      testProvider(
        'Test metric calculation', 
        provider: bmiResultProvider,
        overrides: [bmiViewModelProvider.overrideWith(() => BmiViewModel(initial: BmiModel(Unit.metric, 1.78, 60, BmiCalculateResult())))],
        wait: const Duration(seconds: 4),
        expect: () => [
          const AsyncLoading<BmiResult>(),
          const AsyncValue<BmiResult>.data((18.93700290367378,))
        ]
      );

      testProvider(
        'Test imperial calculation', 
        provider: bmiResultProvider,
        overrides: [bmiViewModelProvider.overrideWith(() => BmiViewModel(initial: BmiModel(Unit.imperial, 70.07, 132.27, BmiCalculateResult())))],
        wait: const Duration(seconds: 4),
        expect: () => [
          const AsyncLoading<BmiResult>(),
          const AsyncValue<BmiResult>.data((18.93879938080636,))
        ]
      );
    });
  });
}

void categoryTests(){
  group('Category tests', () {
    testProvider(
      'Test category - normal', 
      provider: bmiResultProvider,
      overrides: [bmiViewModelProvider.overrideWith(() => BmiViewModel(initial: BmiModel(Unit.imperial, 70.07, 132.27, BmiCalculateResult())))],
      wait: const Duration(seconds: 4),
      expect: () => [
        const AsyncLoading<BmiResult>(),
        const CategoryMatcher(BmiCategory.normal)
      ]
    );

    testProvider(
      'Test category - underweight', 
      provider: bmiResultProvider,
      overrides: [bmiViewModelProvider.overrideWith(() => BmiViewModel(initial: BmiModel(Unit.metric, 1, 10, BmiCalculateResult())))],
      wait: const Duration(seconds: 4),
      expect: () => [
        const AsyncLoading<BmiResult>(),
        const CategoryMatcher(BmiCategory.underweight)
      ]
    );

    testProvider(
      'Test category - overweight', 
      provider: bmiResultProvider,
      overrides: [bmiViewModelProvider.overrideWith(() => BmiViewModel(initial: BmiModel(Unit.metric, 1, 25, BmiCalculateResult())))],
      wait: const Duration(seconds: 4),
      expect: () => [
        const AsyncLoading<BmiResult>(),
        const CategoryMatcher(BmiCategory.overweight)
      ]
    );

    testProvider(
      'Test category - obese', 
      provider: bmiResultProvider,
      overrides: [bmiViewModelProvider.overrideWith(() => BmiViewModel(initial: BmiModel(Unit.metric, 1, 250, BmiCalculateResult())))],
      wait: const Duration(seconds: 4),
      expect: () => [
        const AsyncLoading<BmiResult>(),
        const CategoryMatcher(BmiCategory.obese)
      ]
    );
  });
}