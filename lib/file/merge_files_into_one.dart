// to-do: 写个仅合并文件的并发程序
// merge ts files into one in concurrency

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'merge_as_stream.dart';
import 'read_write_as_stream.dart';
import '../list/list_apis.dart';

void main(List<String> args) async {
  final lines = File('./lib/http/downloads/gear2/prog_index.m3u8')
      .openRead() // open for reading as stream.
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(const LineSplitter()); // Convert stream to individual lines.

  final fpths = <String>[], mn = 21;
  var c = 0;
  await for (var line in lines) {
    if (line.startsWith('#')) continue;
    if (c > mn) break;
    fpths.add(line);
    c++;
  }

  final isolateNum = 8;
  // final tfs = await lineProcess(fpths, n);
  final tfs = await conprocess(fpths, isolateNum, downloadAndMerge).wait;
  // 将多个isolate合并的临时文件再次合并为最终文件，完成后删除临时文件。
  final merged = await mergeFilesIntoOne(
      tfs, './lib/http/downloads/gear2/ts/merged/merged.ts');
  for (final f in tfs) {
    f.delete();
  }
  print(
      'All download and merged task finished. The merged file is ${merged.path}');
}

List<Future<R>> conprocess<R, T>(List<T> tasks, int isolateNum,
    Future<R> Function(List<T> tasks, int i, int begin, int end) compute) {
  final seg = tasks.length ~/ isolateNum;
  var i = 0, results = <Future<R>>[];
  while (i < isolateNum - 1) {
    // Important: can't use await here.
    results.add(Isolate.run(() => compute(tasks, i, seg * i, seg * (i + 1))));
    i++;
  }
  results.add(Isolate.run(() => compute(tasks, i, seg * i, tasks.length)));
  return results;
}

Future<File> downloadAndMerge(
    List<String> fpths, int i, int begin, int end) async {
  final pdir = './lib/http/downloads/gear2/ts/';
  final files = <Future<File>>[], client = HttpClient();

  print('Isolate$i download start.');
  try {
    for (final fpth in fpths.slice(begin, end)) {
      print('$fpth download start');
      final url =
          Uri.http('devimages.apple.com', '/iphone/samples/bipbop/gear2/$fpth');
      final request = await client.getUrl(url);
      final response = await request.close();

      // 这里不使用await，因为每个文件的读写没必要按顺序依次执行。
      final file = writeAsStream('$pdir$fpth', response);
      files.add(file);
    }
  } on Error catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
  // print('Isolate$i download completed.');

  print('Isolate$i merge start.');
  final outpath = 'merged/merged$i.ts';
  var merged = await mergeFilesIntoOne(await files.wait, '$pdir$outpath');
  print('Isolate$i merge completed.');
  return merged;
}
