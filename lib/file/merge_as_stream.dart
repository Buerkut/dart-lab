// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

import 'package:dartlab/async/stream/join_stream.dart';

Future<void> mergeFilesIntoOne(List<File> files, String outpath) async {
  final output = await File(outpath).create(recursive: true);
  final sink = output.openWrite();
  try {
    for (final f in files) {
      await sink.addStream(f.openRead());
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    sink.close();
  }
}

Future<void> mergeFileStreamIntoOne(Stream<File> files, String outpath) async {
  final output = await File(outpath).create(recursive: true);
  final sink = output.openWrite();
  try {
    await for (final f in files) {
      await sink.addStream(f.openRead());
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await sink.close();
  }
}

Future<void> mergeTwoFiles(String src1, String src2, String output) async {
  final (f1, f2, o_f) = (File(src1), File(src2), File(output));
  final r_s = joinStreams([f1.openRead(), f2.openRead()]);
  final o_s = o_f.openWrite();

  // The following styles all work.
  // await r_s.pipe(o_s);
  await o_s.addStream(r_s);
  await o_s.close();
}
