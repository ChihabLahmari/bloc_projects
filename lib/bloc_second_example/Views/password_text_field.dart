import 'package:flutter/material.dart';
import 'package:testing_bloc_course/bloc_second_example/strings.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;
  const PasswordTextField({required this.passwordController, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      // obscuringCharacter: 'd',
      decoration: const InputDecoration(
        hintText: AppStrings.enterYourPasswordHere,
      ),
    );
  }
}
