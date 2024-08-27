// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_course/bloc_second_example/models.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note?>? fetchedNotes;

  // Initial app state
  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchedNotes = null;

  const AppState({
    required this.isLoading,
    this.loginError,
    this.loginHandle,
    this.fetchedNotes,
  });

  @override
  String toString() => {
        'Application State ': {
          'isLoading': isLoading,
          'loginError': loginError,
          'loginHandle': loginHandle,
          'fetchedNotes': fetchedNotes,
        }
      }.toString();
}
