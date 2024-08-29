import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/auth/auth_error.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/bloc/firebase_event.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/bloc/firebase_state.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/utils/upload_image.dart';

class FirebaseAppBloc extends Bloc<FirebaseAppEvent, FirebaseAppState> {
  FirebaseAppBloc()
      : super(
          const LoggedOutState(
            isLoading: false,
          ),
        ) {
    // go to register button
    on<GoToRegistrationEvent>(
      (event, emit) {
        emit(
          const IsInRegistrationViewState(
            isLoading: false,
          ),
        );
      },
    );

    // login
    on<UserLogInEvent>(
      (event, emit) async {
        // loading
        emit(
          const LoggedOutState(isLoading: true),
        );

        // log the user in with firebase
        try {
          final email = event.email;
          final password = event.password;
          final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final user = userCredential.user!;

          // get images
          final images = await getImages(user.uid);

          emit(
            LoggedInState(
              isLoading: false,
              user: user,
              images: images,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            LoggedOutState(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    // go to login button
    on<GoToLoginEvent>(
      (event, emit) {
        emit(
          const LoggedOutState(
            isLoading: false,
          ),
        );
      },
    );

    // registration
    on<UserRegisterEvent>(
      (event, emit) async {
        // loading
        emit(
          const IsInRegistrationViewState(
            isLoading: true,
          ),
        );

        final email = event.email;
        final password = event.password;
        try {
          // create the user
          final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          emit(
            LoggedInState(
              isLoading: false,
              user: credentials.user!,
              images: const [],
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            IsInRegistrationViewState(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    // Initial app
    on<InitializeEvent>(
      (event, emit) async {
        // get the current user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            const LoggedOutState(isLoading: false),
          );
          return;
        }

        // grab the user images
        final images = await getImages(user.uid);
        emit(
          LoggedInState(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      },
    );

    // log the user out
    on<UserLogOutEvent>(
      (event, emit) async {
        // start loading
        emit(
          const LoggedOutState(
            isLoading: true,
          ),
        );

        // Log the user out
        await FirebaseAuth.instance.signOut();

        // log the user out in the UI
        emit(
          const LoggedOutState(
            isLoading: false,
          ),
        );
      },
    );

    // handle account deletion
    on<DeleteAccountEvent>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          emit(
            const LoggedOutState(isLoading: false),
          );
          return;
        }

        // start loading
        emit(
          LoggedInState(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );

        // delete user account
        try {
          // delete user images
          final folderImages = await FirebaseStorage.instance.ref(user.uid).listAll();
          for (var image in folderImages.items) {
            await image.delete().catchError((_) {});
          }
          // delete user folder
          await FirebaseStorage.instance.ref(user.uid).delete().catchError((_) {});

          // delete user
          await user.delete();

          // Log the user out
          await FirebaseAuth.instance.signOut();

          // log the user out in the UI
          emit(
            const LoggedOutState(
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            LoggedInState(
              isLoading: false,
              user: user,
              images: state.images ?? [],
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          // log the user out
          emit(
            const LoggedOutState(
              isLoading: false,
            ),
          );
        }
      },
    );

    // handle uploading images
    on<UploadImageEvent>((event, emit) async {
      final user = state.user;

      if (user == null) {
        emit(
          const LoggedOutState(isLoading: false),
        );
        return;
      }

      emit(
        LoggedInState(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );

      final file = File(event.filePathToUpload);
      await uploadImage(
        file: file,
        userId: user.uid,
      );

      // after upload is complete , grab the latest images
      final images = await getImages(user.uid);
      emit(
        LoggedInState(
          isLoading: false,
          user: user,
          images: images,
        ),
      );
    });
  }

  Future<Iterable<Reference>> getImages(String userId) async {
    return await FirebaseStorage.instance.ref(userId).list().then(
          (listResutl) => listResutl.items,
        );
  }
}
