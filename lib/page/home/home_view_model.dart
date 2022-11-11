import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:survey/page/home/home_state.dart';

const String _homeCurrentDatePattern = 'EEEE, MMMM dd';

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(const HomeState.init());

  String getCurrentDate() =>
      DateFormat(_homeCurrentDatePattern).format(clock.now()).toUpperCase();
}
