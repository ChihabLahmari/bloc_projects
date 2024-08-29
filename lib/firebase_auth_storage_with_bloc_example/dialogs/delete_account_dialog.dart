import 'package:flutter/material.dart' show BuildContext;
import 'package:testing_bloc_course/dialogs/generic_dialogs.dart';

Future<bool> showDeleteAccountDialog(
  BuildContext context,
) async {
  return await showGenericDialog<bool>(
    context: context,
    title: 'Delete account',
    content: 'Are you sure you want to delete your account? You cannot undo this operation!',
    dialogOption: () => {
      'Cancel': false,
      "Delete account": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
