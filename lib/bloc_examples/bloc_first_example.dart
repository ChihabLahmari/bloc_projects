// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer' as devtools show log;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final PersonUrl url;
  const LoadPersonAction({required this.url}) : super();
}

enum PersonUrl {
  person1,
  person2,
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return 'http://127.0.0.1:5500/api/persons1.json';
      case PersonUrl.person2:
        return 'http://127.0.0.1:5500/api/persons2.json';
    }
  }
}

@immutable
class Person {
  final String name;
  final int age;
  const Person({
    required this.name,
    required this.age,
  });

  factory Person.fromJson(Map<String, dynamic> map) {
    return Person(
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }

  @override
  String toString() => 'Person(name: $name, age: $age)';
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

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrivedFromCash;
  const FetchResult({
    required this.persons,
    required this.isRetrivedFromCash,
  });
  @override
  String toString() => 'Fetch result isRetrivedFromCash = $isRetrivedFromCash \n persons: $persons';
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cashe = {};
  PersonsBloc() : super(null) {
    on<LoadPersonAction>(
      (event, emit) async {
        final url = event.url;
        if (_cashe.containsKey(url)) {
          // we have the value in our cashe
          final cashePersons = _cashe[url]!;
          final result = FetchResult(
            persons: cashePersons,
            isRetrivedFromCash: true,
          );
          emit(result);
        } else {
          final persons = await getPersons(url.urlString);
          _cashe[url] = persons;
          final result = FetchResult(
            persons: persons,
            isRetrivedFromCash: false,
          );
          emit(result);
        }
      },
    );
  }
}

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
                        const LoadPersonAction(
                          url: PersonUrl.person1,
                        ),
                      );
                },
                child: const Text('Load json #1'),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                        const LoadPersonAction(
                          url: PersonUrl.person2,
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
