// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/widgets.dart';

@immutable
abstract class FirebaseAppEvent {
  const FirebaseAppEvent();
}

@immutable
class UploadImageEvent extends FirebaseAppEvent {
  final String filePathToUpload;
  const UploadImageEvent({
    required this.filePathToUpload,
  });
}

@immutable
class DeleteAccountEvent extends FirebaseAppEvent {
  const DeleteAccountEvent();
}

@immutable
class UserLogOutEvent extends FirebaseAppEvent {
  const UserLogOutEvent();
}

@immutable
class InitializeEvent extends FirebaseAppEvent {
  const InitializeEvent();
}

class UserLogInEvent extends FirebaseAppEvent {
  final String email;
  final String password;
  const UserLogInEvent({
    required this.email,
    required this.password,
  });
}

class UserRegisterEvent extends FirebaseAppEvent {
  final String email;
  final String password;
  const UserRegisterEvent({
    required this.email,
    required this.password,
  });
}

@immutable
class GoToRegistrationEvent extends FirebaseAppEvent {
  const GoToRegistrationEvent();
}

@immutable
class GoToLoginEvent extends FirebaseAppEvent {
  const GoToLoginEvent();
}
