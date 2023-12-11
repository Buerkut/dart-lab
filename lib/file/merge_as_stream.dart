// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

Future<void> mergeAsStream(String src1, String src2, String output) async {
  // final (s_f1, s_f2, o_f) = (File(src1), File(src2), File(output));
  // final (s1, s2) = (s_f1.openRead(), s_f2.openRead());
  // final o_s = o_f.openWrite();

  final s_f1 = File(src1);
  final o_f = File(output);
  final s1 = s_f1.openRead();
  final o_s = o_f.openWrite();

  // The following styles all work.
  await s1.pipe(o_s);
  // await o_s.addStream(s1);

  // await o_s.flush();
  // await o_s.close();
}
