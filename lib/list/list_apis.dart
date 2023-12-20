extension ListAPIs<T> on List<T> {
  List<T> operator -() => reversed.toList();

  List<List<T>> split(int at) => [sublist(0, at), sublist(at)];

  Iterable<T> slice(int begin, [int? end]) sync* {
    end ??= length;
    for (var i = begin; i < end; i++) {
      yield this[i];
    }
  }
}
