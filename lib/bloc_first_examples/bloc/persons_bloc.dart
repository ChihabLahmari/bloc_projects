import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/bloc_first_examples/bloc/bloc_action.dart';
import 'package:testing_bloc_course/bloc_first_examples/bloc/person.dart';

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length && {...this}.intersection({...other}).length == length;
}

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

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoringOrdering(other.persons) && isRetrivedFromCash == other.isRetrivedFromCash;

  @override
  int get hashCode => Object.hash(
        persons,
        isRetrivedFromCash,
      );
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cashe = {};
  PersonsBloc() : super(null) {
    on<LoadPersonsAction>(
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
          final loader = event.loader;
          final persons = await loader(url);
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
