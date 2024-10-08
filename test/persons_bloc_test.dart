import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_bloc_course/bloc_first_examples/bloc/bloc_action.dart';
import 'package:testing_bloc_course/bloc_first_examples/bloc/person.dart';
import 'package:testing_bloc_course/bloc_first_examples/bloc/persons_bloc.dart';

const mockedPersons1 = [
  Person(
    age: 20,
    name: 'Foo',
  ),
  Person(
    age: 30,
    name: 'Bar',
  ),
];

const mockedPersons2 = [
  Person(
    age: 20,
    name: 'Foo',
  ),
  Person(
    age: 30,
    name: 'Bar',
  ),
];

Future<Iterable<Person>> mockGetPersons1(String _) => Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) => Future.value(mockedPersons2);

void main() {
  group(
    'Testing bloc',
    () {
      // write our tests
      late PersonsBloc bloc;

      setUp(() {
        bloc = PersonsBloc();
      });

      blocTest<PersonsBloc, FetchResult?>(
        'Test initial state',
        build: () => bloc,
        verify: (bloc) => expect(bloc.state, null),
      );

      // fetch mock data (persons1) and compare it with FetchResult
      blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPersons1,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPersons1,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons1,
            isRetrivedFromCash: false,
          ),
          const FetchResult(
            persons: mockedPersons1,
            isRetrivedFromCash: true,
          ),
        ],
      );

      // fetch mock data (persons2) and compare it with FetchResult
      blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from second iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_2',
              loader: mockGetPersons2,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_2',
              loader: mockGetPersons2,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons2,
            isRetrivedFromCash: false,
          ),
          const FetchResult(
            persons: mockedPersons2,
            isRetrivedFromCash: true,
          ),
        ],
      );
    },
  );
}
