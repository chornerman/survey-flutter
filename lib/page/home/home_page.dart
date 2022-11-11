import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/page/home/home_header_widget.dart';
import 'package:survey/page/home/home_state.dart';
import 'package:survey/page/home/home_view_model.dart';
import 'package:survey/resource/dimens.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) {
  return HomeViewModel();
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.space20),
      child: SafeArea(
        child: Column(
          children: [
            HomeHeaderWidget(
                currentDate:
                    ref.read(homeViewModelProvider.notifier).getCurrentDate()),
          ],
        ),
      ),
    );
  }
}
