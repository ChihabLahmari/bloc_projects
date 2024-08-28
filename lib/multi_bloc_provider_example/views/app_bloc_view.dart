import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/multi_bloc_provider_example/bloc/app_bloc.dart';
import 'package:testing_bloc_course/multi_bloc_provider_example/bloc/app_events.dart';
import 'package:testing_bloc_course/multi_bloc_provider_example/bloc/app_state.dart';
import 'package:testing_bloc_course/multi_bloc_provider_example/extensions/stream/start_with.dart';

class AppBlocView<T extends AppBloc2> extends StatelessWidget {
  const AppBlocView({super.key});

  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState2>(
        builder: (context, appState) {
          if (appState.error != null) {
            // we have an error
            return const Text(
              'An error occurred. Try again in a moment!',
            );
          } else if (appState.data != null) {
            // we have data
            return Image.memory(
              appState.data!,
              fit: BoxFit.cover,
              width: double.infinity,
            );
          } else {
            // loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
