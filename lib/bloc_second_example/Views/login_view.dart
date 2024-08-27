import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:testing_bloc_course/bloc_second_example/Views/email_text_field.dart';
import 'package:testing_bloc_course/bloc_second_example/Views/login_button.dart';
import 'package:testing_bloc_course/bloc_second_example/Views/password_text_field.dart';

class LoginView extends HookWidget {
  final OnLogginTapped onLogginTapped;
  const LoginView({
    super.key,
    required this.onLogginTapped,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          EmailTextField(emailController: emailController),
          PasswordTextField(passwordController: passwordController),
          LoginButton(
            emailController: emailController,
            passwordController: passwordController,
            onLogginTapped: onLogginTapped,
          ),
        ],
      ),
    );
  }
}
