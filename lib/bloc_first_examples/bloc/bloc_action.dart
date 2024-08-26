import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_course/bloc_first_examples/bloc/person.dart';

// enum PersonUrl {
//   person1,
//   person2,
// }

// extension UrlString on PersonUrl {
//   String get urlString {
//     switch (this) {
//       case PersonUrl.person1:
//         return 'http://127.0.0.1:5500/api/persons1.json';
//       case PersonUrl.person2:
//         return 'http://127.0.0.1:5500/api/persons2.json';
//     }
//   }
// }

const String person1Url = 'http://127.0.0.1:5500/api/persons1.json';
const String person2Url = 'http://127.0.0.1:5500/api/persons2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonsLoader loader;
  const LoadPersonsAction({required this.url, required this.loader}) : super();
}
