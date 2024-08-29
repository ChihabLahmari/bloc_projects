// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/auth/auth_error.dart';

@immutable
class FirebaseAppState {
  final bool isLoading;
  final AuthError? authError;

  const FirebaseAppState({
    required this.isLoading,
    this.authError,
  });
}

@immutable
class LoggedInState extends FirebaseAppState {
  final User user;
  final Iterable<Reference> images;

  const LoggedInState({
    required super.isLoading,
    required this.user,
    required this.images,
    super.authError,
  });

  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is LoggedInState) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(
        user.uid,
        images,
      );

  @override
  String toString() => 'LoggedInState(user name: ${user.displayName}, images length: ${images.length})';
}

@immutable
class LoggedOutState extends FirebaseAppState {
  const LoggedOutState({
    required super.isLoading,
    super.authError,
  });

  @override
  String toString() => 'LoggedInState(is loading: $isLoading, auth error: $authError)';
}

@immutable
class IsInRegistrationViewState extends FirebaseAppState {
  const IsInRegistrationViewState({
    required super.isLoading,
    super.authError,
  });
}

extension GetUser on FirebaseAppState {
  User? get user {
    final cls = this;
    if (cls is LoggedInState) {
      return cls.user;
    }
    return null;
  }
}

extension GetImages on FirebaseAppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is LoggedInState) {
      return cls.images;
    }
    return null;
  }
}
