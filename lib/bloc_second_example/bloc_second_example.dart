import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/bloc_second_example/Views/iterable_list_view.dart';
import 'package:testing_bloc_course/bloc_second_example/Views/login_view.dart';
import 'package:testing_bloc_course/bloc_second_example/apis/login_api.dart';
import 'package:testing_bloc_course/bloc_second_example/apis/notes_api.dart';
import 'package:testing_bloc_course/bloc_second_example/bloc/actions.dart';
import 'package:testing_bloc_course/bloc_second_example/bloc/app_bloc.dart';
import 'package:testing_bloc_course/bloc_second_example/bloc/app_state.dart';
import 'package:testing_bloc_course/bloc_second_example/models.dart';
import 'package:testing_bloc_course/bloc_second_example/strings.dart';
import 'package:testing_bloc_course/dialogs/generic_dialogs.dart';
import 'package:testing_bloc_course/dialogs/loading_screen.dart';

class BlocSecondExample extends StatelessWidget {
  const BlocSecondExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // loading screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: AppStrings.pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            // display errors
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog<bool>(
                context: context,
                title: AppStrings.loginErrorDialogTitle,
                content: AppStrings.loginErrorDialogContent,
                dialogOption: () => {
                  'ok': true,
                },
              );
            }

            // if we are logged in, but we have no fetched notes, fetch them now
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(onLogginTapped: (email, password) {
                context.read<AppBloc>().add(
                      LoginAction(
                        email: email,
                        password: password,
                      ),
                    );
              });
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
