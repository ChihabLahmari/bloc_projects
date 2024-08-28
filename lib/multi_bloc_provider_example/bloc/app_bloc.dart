import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/multi_bloc_provider_example/bloc/app_events.dart';
import 'package:testing_bloc_course/multi_bloc_provider_example/bloc/app_state.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);

extension Randomelement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc2 extends Bloc<AppEvent2, AppState2> {
  String _pickRandomurl(Iterable<String> allUrls) => allUrls.getRandomElement();

  AppBloc2({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
  }) : super(
          const AppState2.empty(),
        ) {
    on<LoadNextUrlEvent>(
      (event, emit) async {
        // loading
        emit(
          const AppState2(
            isLoading: true,
            data: null,
            error: null,
          ),
        );

        final url = (urlPicker ?? _pickRandomurl)(urls);
        try {
          if (waitBeforeLoading != null) {
            await Future.delayed(waitBeforeLoading);
          }
          final bundle = NetworkAssetBundle(Uri.parse(url));
          final data = (await bundle.load(url)).buffer.asUint8List();
          emit(
            AppState2(
              isLoading: false,
              data: data,
              error: null,
            ),
          );
        } catch (e) {
          emit(
            AppState2(
              isLoading: false,
              data: null,
              error: e,
            ),
          );
        }
      },
    );
  }
}
