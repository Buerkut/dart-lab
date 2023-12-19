// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

import 'package:dartlab/async/stream/join_stream.dart';

Future<File> mergeFilesIntoOne(Iterable<File> files, String outpath) async {
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
  return output;
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

// The following code shows the usage differences between pipe and addStream
void mergeTwoFiles2() async {
  final f1 = File('file1.txt').openRead();
  final f2 = File('file2.txt').openRead();
  final out = File('out.txt').openWrite();

  // 依次调用两个 pipe 不行，第一个调用完后，会把 out 关闭，出现下面错误：
  // FileSystemException: File closed, path = 'out.json'
  // await f1.pipe(out);
  // await f2.pipe(out);

  // 但 先后调用 addStream 可以，但一定要用 await. 否则会有下面错误：
  // Bad state: StreamSink is already bound to a stream
  await out.addStream(f1);
  await out.addStream(f2);
  out.close();
}
