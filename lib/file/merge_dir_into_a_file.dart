// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

import 'read_dir_as_stream.dart';

// More simple and direct implement.
Future<void> mergeDirIntoAFile(String dirPath, String outpath) async {
  final dir = Directory(dirPath);
  if (!await dir.exists()) {
    print('path does not exist');
    return;
  }

  // It is inefficient for cast checks each data event at run-time.
  // Even if used 'where' to filter file event, the result type is still
  // Stream<FileSystemEntity> which is not eligible.
  // var files = dir
  //     .list(recursive: false, followLinks: false)
  //     .where((f) => f is File)
  //     .cast<File>();

  final output = await File(outpath).create(recursive: true);
  final sink = output.openWrite();
  final fs_entities = dir.list(recursive: false, followLinks: false);

  try {
    await for (final entity in fs_entities) {
      if (entity is File) {
        await sink.addStream(entity.openRead());
      }
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await sink.close();
  }
}

// another way: using 'readDirAsStream' to read the dir as a whole stream.
Future<void> mergeDirIntoAFile2(String path, String output) async {
  final dir = Directory(path);
  if (!await dir.exists()) return;

  // final inputs = <Stream<List<int>>>[];
  // // 这里不能这样写，因为当dir下有很多文件时，将会同时打开所有文件。还是要改成流的形式
  // await for (final f in dir.list()) {
  //   if (f is File) inputs.add(f.openRead());
  // }

  // create the file first
  final o_f = await File(output).create(recursive: true);
  final o_s = o_f.openWrite();
  final r_s = readDirAsStream(path);

  // await o_s.addStream(joinStreams(inputs));
  // await joinStreams(inputs).pipe(o_s);

  // The following styles all work.
  await r_s.pipe(o_s);
  // await o_s.addStream(r_s);
  o_s.close();
}
