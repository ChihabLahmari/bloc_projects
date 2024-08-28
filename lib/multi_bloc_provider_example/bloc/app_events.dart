import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent2 {
  const AppEvent2();
}

@immutable
class LoadNextUrlEvent implements AppEvent2 {
  const LoadNextUrlEvent();
}
