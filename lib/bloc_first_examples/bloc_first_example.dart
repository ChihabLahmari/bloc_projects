// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer' as devtools show log;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/bloc_first_examples/bloc/bloc_action.dart';
import 'package:testing_bloc_course/bloc_first_examples/bloc/person.dart';
import 'package:testing_bloc_course/bloc_first_examples/bloc/persons_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

// converting data
Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    //     ⬇⬇
    .then((req) => req.close())
    //     ⬇⬇
    .then((resp) => resp.transform(utf8.decoder).join())
    //     ⬇⬇
    .then((str) => json.decode(str) as List<dynamic>)
    //     ⬇⬇
    .then((list) => list.map((e) => Person.fromJson(e)));

// Adds safe access to list elements by returning null if the index is out of bounds
extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class BlocFirstExample extends StatelessWidget {
  const BlocFirstExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                        const LoadPersonsAction(
                          url: person1Url,
                          loader: getPersons,
                        ),
                      );
                },
                child: const Text('Load json #1'),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                        const LoadPersonsAction(
                          url: person2Url,
                          loader: getPersons,
                        ),
                      );
                },
                child: const Text('Load json #2'),
              ),
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previousResult, currentResult) {
              return previousResult != currentResult;
            },
            builder: (context, fetchResult) {
              fetchResult?.log();
              final persons = fetchResult?.persons;
              if (persons == null) {
                return const SizedBox();
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: persons.length,
                    itemBuilder: (contenxt, index) {
                      final person = persons[index]!;
                      return ListTile(
                        title: Text(person.name),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
