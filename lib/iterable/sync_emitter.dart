Iterable<int> emit(int n) sync* {
  var i = 0;
  while (i < n) {
    yield i++;
  }
}

Iterable<int> joinIterables(Iterable<Iterable<int>> iterables) sync* {
  for (final iter in iterables) {
    yield* iter;
  }
}
