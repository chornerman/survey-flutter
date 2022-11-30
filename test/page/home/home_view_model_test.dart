import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey/page/home/home_page.dart';
import 'package:survey/page/home/home_view_model.dart';

void main() {
  group('HomeViewModelTest', () {
    late ProviderContainer providerContainer;
    late HomeViewModel homeViewModel;

    setUp(() {
      providerContainer = ProviderContainer(
        overrides: [
          homeViewModelProvider.overrideWithValue(HomeViewModel()),
        ],
      );
      addTearDown(providerContainer.dispose);
      homeViewModel = providerContainer.read(homeViewModelProvider.notifier);
    });

    test(
        'When getting current date, it returns formatted current date correctly',
        () {
      withClock(Clock.fixed(DateTime(2000)), () {
        expect(homeViewModel.getCurrentDate(), "SATURDAY, JANUARY 01");
      });
    });
  });
}
