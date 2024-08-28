import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testing_bloc_course/firebase_auth_storage_with_bloc_example/firebase_auth_storage_with_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.light),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const FirebaseAuthStorageWithBloc(),
    );
  }
}
