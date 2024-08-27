import 'package:flutter/material.dart';
import 'package:testing_bloc_course/bloc_second_example/strings.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController emailController;
  const EmailTextField({required this.emailController, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: AppStrings.enterYourEmailHere,
      ),
    );
  }
}
