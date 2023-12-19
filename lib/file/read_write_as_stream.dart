// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

Future<void> readAndWriteAsStream(String src, String output) async {
  final s_f = File(src);
  final o_f = File(output);
  final s_s = s_f.openRead();
  final o_s = o_f.openWrite();

  // The following styles all work.
  await s_s.pipe(o_s);
  // await o_s.addStream(s_s);
}

Future<File> writeAsStream(String fpth, Stream<List<int>> stream) async {
  final file = await File(fpth).create(recursive: true);
  final sink = file.openWrite();
  try {
    await sink.addStream(stream);
    await sink.flush();
  } on Error catch (e) {
    print('Error: $e');
  } finally {
    sink.close();
  }
  return file;
}
