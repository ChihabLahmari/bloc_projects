import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/bloc/firebase_bloc.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/bloc/firebase_event.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/extensions/if_debugging.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
      text: 'chihab@gmail.com'.ifDebugging,
    );
    final passwordController = useTextEditingController(
      text: 'password'.ifDebugging,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log in',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email here....',
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your password here....',
              ),
              keyboardType: TextInputType.visiblePassword,
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              obscuringCharacter: '✧',
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                context.read<FirebaseAppBloc>().add(
                      UserLogInEvent(
                        email: email,
                        password: password,
                      ),
                    );
              },
              child: const Text(
                'Login',
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<FirebaseAppBloc>().add(
                      const GoToRegistrationEvent(),
                    );
              },
              child: const Text(
                'Not registered yet? Register here!',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
