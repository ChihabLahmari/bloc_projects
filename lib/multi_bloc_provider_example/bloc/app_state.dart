import 'dart:typed_data' show Uint8List;

import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState2 {
  final bool isLoading;
  final Uint8List? data;
  final Object? error;

  const AppState2.empty()
      : isLoading = false,
        data = null,
        error = null;

  const AppState2({
    required this.isLoading,
    required this.data,
    this.error,
  });

  @override
  String toString() => {
        'isLoading': isLoading,
        'has data': data != null,
        'error': error,
      }.toString();
}
