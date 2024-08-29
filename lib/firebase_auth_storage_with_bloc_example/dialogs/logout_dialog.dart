import 'package:flutter/material.dart';
import 'package:testing_bloc_course/dialogs/generic_dialogs.dart';

Future<bool> showLogOutDialgo(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    dialogOption: () => {
      "Cancel": false,
      "Log out": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
