// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

Future<void> mergeAsString(String src1, String src2, String output) async {
  final (s_f1, s_f2, o_f) = (File(src1), File(src2), File(output));
  final (c1, c2) = await (s_f1.readAsString(), s_f2.readAsString()).wait;

  await o_f.writeAsString(c1);
  await o_f.writeAsString(c2, mode: FileMode.append);
}
