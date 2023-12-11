// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

Future<void> mergeAsLines(String src1, String src2, String output) async {
  final (s_f1, s_f2, o_f) = (File(src1), File(src2), File(output));
  final (c1, c2) = await (s_f1.readAsLines(), s_f2.readAsLines()).wait;

  await o_f.writeAsString([...c1, ...c2].join('\n'));
  // await o_f.writeAsString(c2.join('\n'), mode: FileMode.append);
}
