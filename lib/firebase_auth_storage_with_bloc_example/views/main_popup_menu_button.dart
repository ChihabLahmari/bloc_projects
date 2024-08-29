import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/bloc/firebase_bloc.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/bloc/firebase_event.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/dialogs/delete_account_dialog.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/dialogs/logout_dialog.dart';

enum MenuAction {
  logout,
  deleteAccount,
}

class MainPopUpMenuButton extends StatelessWidget {
  const MainPopUpMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await showLogOutDialgo(context);
            if (shouldLogout) {
              context.read<FirebaseAppBloc>().add(
                    const UserLogOutEvent(),
                  );
            }

          case MenuAction.deleteAccount:
            final shouldDelete = await showDeleteAccountDialog(context);
            if (shouldDelete) {
              context.read<FirebaseAppBloc>().add(
                    const DeleteAccountEvent(),
                  );
            }
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text(
              'Logout',
            ),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text(
              'Delete account',
            ),
          ),
        ];
      },
    );
  }
}
