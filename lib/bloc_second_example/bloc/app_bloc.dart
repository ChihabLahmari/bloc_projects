import 'package:bloc/bloc.dart';
import 'package:testing_bloc_course/bloc_second_example/apis/login_api.dart';
import 'package:testing_bloc_course/bloc_second_example/apis/notes_api.dart';
import 'package:testing_bloc_course/bloc_second_example/bloc/actions.dart';
import 'package:testing_bloc_course/bloc_second_example/bloc/app_state.dart';
import 'package:testing_bloc_course/bloc_second_example/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        // loading
        emit(const AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchedNotes: null,
        ));
        // log the user in
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );
        emit(AppState(
          isLoading: false,
          loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ));
      },
    );
    on<LoadNotesAction>(
      (event, emit) async {
        // loading
        emit(AppState(
          isLoading: true,
          loginError: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null,
        ));
        // get the login handle
        final loginHandle = state.loginHandle;
        if (loginHandle != const LoginHandle.fooBar()) {
          // invalid login handle can not fetch notes
          emit(AppState(
            isLoading: false,
            loginError: LoginErrors.invalidHandle,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ));
          return;
        }
        // we have a valid login handle and want to fetch notes
        final fetchedNotes = await notesApi.getNotes(loginHandle: loginHandle!);
        emit(AppState(
          isLoading: false,
          loginError: null,
          loginHandle: loginHandle,
          fetchedNotes: fetchedNotes,
        ));
      },
    );
  }
}
