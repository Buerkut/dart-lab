import 'dart:convert';
import 'dart:io';

import 'merge_as_stream.dart';
import 'package:dartlab/concurrency/split.dart';

// 一个只合并文件的例子。
void main(List<String> args) async {
  final fpth = './lib/http/downloads/gear2/prog_index.m3u8';
  final dirpath = './lib/http/downloads/gear2/ts/';
  final files = getFiles(dirpath, await getFilenames(fpth));
  final isolateNum = 4;
  final tfs = await conprocess(files, merge, isolateNum).wait;

  // 将多个isolate合并的临时文件再次合并为最终文件，完成后删除临时文件。
  final merged = await mergeFilesIntoOne(tfs, '${dirpath}merged/merged.ts');
  for (final tf in tfs) {
    tf.delete();
  }
  print('All files are merged. The merged file is ${merged.path}');
}

List<File> getFiles(String dirpath, List<String> filenames) =>
    filenames.map((filename) => File('$dirpath$filename')).toList();

Future<List<String>> getFilenames(String fpth) async {
  final file = File(fpth);
  final lines =
      file.openRead().transform(utf8.decoder).transform(const LineSplitter());

  final fns = <String>[];
  await for (var line in lines) {
    if (line.startsWith('#')) continue;
    fns.add(line);
  }
  return fns;
}

Future<File> merge(int i, Iterable<File> parts) async {
  final outpath = '${parts.first.parent}/merged/merged$i.ts';
  var merged = await mergeFilesIntoOne(parts, outpath);
  return merged;
}
