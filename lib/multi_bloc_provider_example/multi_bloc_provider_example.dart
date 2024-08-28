import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/multi_bloc_provider_example/bloc/bottom_bloc.dart';
import 'package:testing_bloc_course/multi_bloc_provider_example/bloc/top_bloc.dart';
import 'package:testing_bloc_course/multi_bloc_provider_example/models/constants.dart';
import 'package:testing_bloc_course/multi_bloc_provider_example/views/app_bloc_view.dart';

class MultiBlocProviderExample extends StatelessWidget {
  const MultiBlocProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // make the status bar dark
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TopBloc>(
              create: (context) => TopBloc(
                urls: images,
                waitBeforeLoading: const Duration(seconds: 10),
              ),
            ),
            BlocProvider<BottomBloc>(
              create: (context) => BottomBloc(
                urls: images,
                waitBeforeLoading: const Duration(seconds: 10),
              ),
            ),
          ],
          child: const Center(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  AppBlocView<TopBloc>(),
                  AppBlocView<BottomBloc>(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
