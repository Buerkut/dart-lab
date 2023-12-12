Stream<T> joinStreams<T>(Iterable<Stream<T>> streams) async* {
  for (final stream in streams) {
    yield* stream;
  }
}
