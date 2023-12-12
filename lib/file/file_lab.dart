// ignore_for_file: non_constant_identifier_names, constant_identifier_names

// done: readAsBytes() -> utf8list; 尝试二进制读写; -- ok
// done: 测试创建文件后，直接写入是否可以; -- ok
// done: 用多种方式读写文件
// done: 按stream读写（stream pipe / addStream)
// done: use isolate

// import 'dart:async';
// import 'dart:convert';
import 'dart:io';
// import 'dart:isolate';

// import 'merge_as_bytes.dart';
// import 'dart:io';

// import 'merge_as_lines.dart';
// import 'merge_as_string.dart';
// import 'merge_as_stream.dart';
import 'merge_dir_into_a_file.dart';

// command line input:
// dart run ./lib/file/file_lab.dart ./lib/file/res/ ./lib/file/output/output.txt
void main(List<String> args) async {
  // final [src1, src2, output] = args;

  // await mergeAsBytes(src1, src2, output);
  // print(await o_f.readAsString());

  // await mergeAsString(src1, src2, output);
  // print(await o_f.readAsString());

  // await mergeAsLines(src1, src2, output);
  // print(await File(output).readAsString());

  // await mergeAsStream(src1, src2, output);
  // await Isolate.run(() => mergeAsStream(src1, src2, output));

  // final [path, output] = args;
  // // You can use isolate.
  // // await Isolate.run(() => mergeDirIntoOneFile(path, output));
  // mergeDirIntoOneFile(path, output);

  final [dirPath, output] = args;
  await mergeDirIntoAFile(dirPath, output);

  print(await File(output).readAsString());
}
