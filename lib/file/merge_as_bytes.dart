// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

Future<void> mergeAsBytes(String src1, String src2, String output) async {
  // The following styles are all acceptable.
  // final s_f1 = File(src1), s_f2 = File(src2), t_f = File(target);
  // final [s_f1, s_f2, t_f] = [File(src1), File(src2), File(target)];
  final (s_f1, s_f2, t_f) = (File(src1), File(src2), File(output));

  // The following styles are all acceptable.
  // final c1 = await s_f1.readAsBytes(), c2 = await s_f2.readAsBytes();
  // var arr = await [s_f1.readAsBytes(), s_f2.readAsBytes()].wait;
  final (c1, c2) = await (s_f1.readAsBytes(), s_f2.readAsBytes()).wait;

  // 传统但正确的写法
  await t_f.writeAsBytes(c1);
  await t_f.writeAsBytes(c2, mode: FileMode.append);

  // 非同步写入，可能会造成内容顺序混乱
  // t_f
  //   ..writeAsBytes(c1)
  //   ..writeAsBytes(c2, mode: FileMode.append);

  // Future.wait: 这种写法有问题，造成数据错乱
  // await Future.wait([
  //   t_f.writeAsBytes(c1),
  //   t_f.writeAsBytes(c2, mode: FileMode.append),
  // ]);

  // 这种写法也有问题，即使设置 flush 为 true
  // await [
  //   t_f.writeAsBytes(c1, flush: true),
  //   t_f.writeAsBytes(c2, mode: FileMode.append, flush: true),
  // ].wait;

  // 这种写法也有问题，内容可能不全或混乱
  // await (
  //   t_f.writeAsBytes(c1),
  //   t_f.writeAsBytes(c2, mode: FileMode.append),
  // ).wait;
}
