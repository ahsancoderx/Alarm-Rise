import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Har second phone ka system time deta hai.
final clockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});