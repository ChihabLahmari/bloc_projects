// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:testing_bloc_course/bloc_second_example/strings.dart';
import 'package:testing_bloc_course/dialogs/generic_dialogs.dart';

typedef OnLogginTapped = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLogginTapped onLogginTapped;
  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLogginTapped,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final email = emailController.text;
        final password = passwordController.text;
        if (email.isEmpty || password.isEmpty) {
          showGenericDialog<bool>(
            context: context,
            title: AppStrings.emailOrPasswordEmptyDialogTitle,
            content: AppStrings.emailOrPasswordEmptyDescription,
            dialogOption: () => {
              'ok': true,
            },
          );
        } else {
          onLogginTapped(
            email,
            password,
          );
        }
      },
      child: const Text(AppStrings.login),
    );
  }
}
