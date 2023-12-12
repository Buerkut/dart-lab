// An example from dart standard library:
// https://api.dart.dev/stable/3.2.3/dart-io/File-class.html

import 'dart:io';
import 'dart:convert';

void main(List<String> args) async {
  final file = File(args[0]);

  // The following two styles all run.
  // final lines =
  //     utf8.decoder.bind(file.openRead()).transform(const LineSplitter());
  final lines = file
      .openRead() // open for reading as stream.
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(LineSplitter()); // Convert stream to individual lines.
  try {
    await for (var line in lines) {
      // print('$line: ${line.length} characters');
      print(line);
    }
    // print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }
}
