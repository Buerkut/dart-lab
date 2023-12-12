// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

Future<void> mergeAsLines(String src1, String src2, String output) async {
  final (s_f1, s_f2, o_f) = (File(src1), File(src2), File(output));

  // This can work.
  // final (c1, c2) = await (s_f1.readAsLines(), s_f2.readAsLines()).wait;
  // await o_f.writeAsString([...c1, ...c2].join('\n'));
  // await o_f.writeAsString(c2.join('\n'), mode: FileMode.append);

  // Or written in IOSink
  final o_s = o_f.openWrite();
  for (final line in await s_f1.readAsLines()) {
    o_s.writeln(line);
  }
  for (final line in await s_f2.readAsLines()) {
    o_s.writeln(line);
  }

  // when file is big, use stream to read it.
  // final lines =
  //     utf8.decoder.bind(file.openRead()).transform(const LineSplitter());
  // await for (var line in lines) {
  //   o_s.writeln(line);
  // }

  o_s.close();
}
