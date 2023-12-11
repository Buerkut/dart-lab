import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

Future<void> readAndParseJsonService(SendPort sp) async {
  print('Spawned isolate started.');

  final rp = ReceivePort();
  sp.send(rp.sendPort);

  // Wait for messages from the main isolate.
  await for (final msg in rp) {
    if (msg is String) {
      print('start parsing file: $msg');
      final contents = await File(msg).readAsString();
      sp.send(jsonDecode(contents));
    } else if (msg == null) {
      break;
    }
  }

  print('Spawned isolate finished.');
  Isolate.exit();
}
