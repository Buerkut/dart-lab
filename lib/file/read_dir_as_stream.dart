import 'dart:io';

Stream<List<int>> readDirAsStream(String path) async* {
  final dir = Directory(path);
  if (!await dir.exists()) {
    print('path does not exist');
    return;
  }

  await for (final f in dir.list()) {
    if (f is File) {
      yield* f.openRead();
    }
  }
}
