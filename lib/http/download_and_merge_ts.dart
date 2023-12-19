import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import '../file/merge_as_stream.dart';
import '../file/read_write_as_stream.dart';

void main(List<String> args) async {
  final lines = File('./lib/http/downloads/gear2/prog_index.m3u8')
      .openRead() // open for reading as stream.
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(const LineSplitter()); // Convert stream to individual lines.

  final fpths = <String>[], mn = 13;
  var c = 0;
  await for (var line in lines) {
    if (line.startsWith('#')) continue;
    if (c > mn) break;
    fpths.add(line);
    c++;
  }

  final n = 4;
  // final tfs = await lineProcess(fpths, n);
  final tfs = await conprocess(fpths, n).wait;
  // 将多个isolate合并的临时文件再次合并为最终文件，完成后删除临时文件。
  final merged = await mergeFilesIntoOne(
      tfs, './lib/http/downloads/gear2/ts/merged/merged.ts');
  for (final f in tfs) {
    f.delete();
  }
  print(
      'All download and merged task finished. The merged file is ${merged.path}');
}

// Note: 因为这里在 Isolate.run 前 使用了 await，那么每次等 run 执行完，才会执行下一个迭代，
// 阻塞了后面的循环，将并行变成了串行。
Future<List<File>> lineProcess(List<String> fpths, int n) async {
  // final sn = (fpths.length / n).ceil();
  final sn = fpths.length ~/ n + 1;
  final files = <File>[];
  for (var i = 0; i < sn; i++) {
    files.add(await Isolate.run(() => downloadAndMerge(fpths, i, n)));
  }
  return files;
}

// Note: 这才是真正的并行，从输出顺序中可以看出来各 isolate 是并行执行的。
List<Future<File>> conprocess(List<String> fpths, int n) {
  // final sn = (fpths.length / n).ceil();
  final sn = fpths.length ~/ n + 1;
  final futrFiles = <Future<File>>[];
  for (var i = 0; i < sn; i++) {
    // Important: can't use await here.
    futrFiles.add(Isolate.run(() => downloadAndMerge(fpths, i, n)));
  }
  return futrFiles;
}

Future<File> downloadAndMerge(List<String> fpths, int i, int n) async {
  final pdir = './lib/http/downloads/gear2/ts/';
  final files = <Future<File>>[], client = HttpClient();

  print('Isolate$i download start.');
  try {
    for (var k = i * n; k < min((i + 1) * n, fpths.length); k++) {
      print('${fpths[k]} download start');
      final url = Uri.http(
          'devimages.apple.com', '/iphone/samples/bipbop/gear2/${fpths[k]}');
      final request = await client.getUrl(url);
      final response = await request.close();

      // 这里不使用await，因为每个文件的读写没必要按顺序依次执行。
      final file = writeAsStream('$pdir${fpths[k]}', response);
      files.add(file);
      // print('${fpths[k]} download finished');
    }
  } on Error catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
  print('Isolate$i download completed.');

  print('Isolate$i merge start.');
  final outpath = 'merged/merged$i.ts';
  var merged = await mergeFilesIntoOne(await files.wait, '$pdir$outpath');
  print('Isolate$i merge completed.');
  return merged;
}
