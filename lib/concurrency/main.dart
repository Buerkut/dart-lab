import 'dart:isolate';

import 'package:async/async.dart' show StreamQueue;

import 'child_isolate.dart';

void main() async {
  const filenames = ['json_01.json', 'json_02.json', 'json_03.json'];
  await for (final jsondata in _sendAndReceive(filenames)) {
    print(jsondata);
  }
}

Stream<Map<String, dynamic>> _sendAndReceive(List<String> filenames) async* {
  final rp = ReceivePort();
  final isl = await Isolate.spawn(readAndParseJsonService, rp.sendPort);

  final events = StreamQueue(rp);
  final sp = await events.next as SendPort;

  for (final filename in filenames) {
    sp.send(filename);
    final msg = await events.next as Map<String, dynamic>;
    yield msg;
  }

  sp.send(null);
  await events.cancel();
  isl.kill();
}
