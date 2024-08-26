import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/bloc_first_examples/bloc/persons_bloc.dart';
import 'package:testing_bloc_course/bloc_first_examples/bloc_first_example.dart';

void main() {
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
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: const BlocFirstExample(),
      ),
      // home: const BlocFirstExample(),
    );
  }
}
