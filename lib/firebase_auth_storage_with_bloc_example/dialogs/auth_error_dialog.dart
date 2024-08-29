import 'package:flutter/material.dart';
import 'package:testing_bloc_course/dialogs/generic_dialogs.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/auth/auth_error.dart';

Future<void> showAuthErrorDialog({
  required BuildContext context,
  required AuthError authError,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogContent,
    dialogOption: () => {
      "Ok": true,
    },
  );
}
