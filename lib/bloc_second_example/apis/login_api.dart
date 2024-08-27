import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_course/bloc_second_example/models.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  // // Singleton pattern "one instance of the class can exist at any time during the program’s execution"
  // // Private constructor
  // const LoginApi._sharedInstance();
  // // The single instance of the class
  // static const LoginApi _shared = LoginApi._sharedInstance();
  // // Method to access the instance
  // factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => email == 'foo@bar.com' && password == 'foobar',
      ).then(
        (isLoggedIn) => isLoggedIn ? const LoginHandle.fooBar() : null,
      );
}
