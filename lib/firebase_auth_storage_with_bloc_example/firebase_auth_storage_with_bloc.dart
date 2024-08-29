import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/dialogs/loading_screen.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/bloc/firebase_bloc.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/bloc/firebase_state.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/dialogs/auth_error_dialog.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/views/login_view.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/views/photo_galery_view.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/views/register_view.dart';

class FirebaseAuthStorageWithBloc extends StatelessWidget {
  const FirebaseAuthStorageWithBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FirebaseAppBloc, FirebaseAppState>(
      listener: (context, appState) {
        if (appState.isLoading) {
          LoadingScreen.instance().show(
            context: context,
            text: 'Loading...',
          );
        } else {
          LoadingScreen.instance().hide();
        }
        final authError = appState.authError;
        if (authError != null) {
          showAuthErrorDialog(
            context: context,
            authError: authError,
          );
        }
      },
      builder: (context, appState) {
        if (appState is LoggedOutState) {
          return const LoginView();
        }
        if (appState is LoggedInState) {
          return const PhotoGaleryView();
        }
        if (appState is IsInRegistrationViewState) {
          return const RegisterView();
        }
        // this should never hapen
        return const SizedBox();
      },
    );
  }
}
