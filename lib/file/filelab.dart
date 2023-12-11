// ignore_for_file: non_constant_identifier_names, constant_identifier_names

// done: readAsBytes() -> utf8list; 尝试二进制读写; -- ok
// done: 测试创建文件后，直接写入是否可以; -- ok

// 用多种方式读写文件
// 按stream读写（stream pipe / streamcontroller)
// 文件合并
// use isolate

// import 'dart:convert';
// import 'dart:async';
import 'dart:io';

// import 'merge_as_bytes.dart';
// import 'merge_as_lines.dart';
// import 'merge_as_string.dart';
import 'merge_as_stream.dart';

void main(List<String> args) async {
  final [src1, src2, output, ...] = args;
  final o_f = File(output);

  // await mergeAsBytes(src1, src2, output);
  // print(await o_f.readAsString());

  // await mergeAsString(src1, src2, output);
  // print(await o_f.readAsString());

  // await mergeAsLines(src1, src2, output);
  // print(await o_f.readAsString());

  await mergeAsStream(src1, src2, output);
  print(await o_f.readAsString());
}
