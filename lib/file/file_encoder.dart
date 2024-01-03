// import 'dart:convert';
import 'dart:io';

main() async {
  final src = File('./lib/file/source.txt');
  final output = File('./lib/file/output.txt');

  final ins = src.openRead();
  final encoded = convert(ins, 128);
  final outs = output.openWrite();
  await encoded.pipe(outs);
  // or
  // await outs.addStream(encoded);
  outs.close();

  // the second transform.
  final output2 = File('./lib/file/output2.txt');
  final outs2 = output2.openWrite();
  await convert(output.openRead(), -128).pipe(outs2);
  outs2.close();
}

Stream<List<int>> convert(Stream<List<int>> source,
    [int key = 128, int base = 256]) async* {
  await for (final chunk in source) {
    yield chunk.map((i) => (i + key) % base).toList();
    // yield encode(chunk, key, base);
  }
}

// List<int> encode(List<int> original, [int key = 128, int base = 256]) {
//   final encoded = List<int>.filled(original.length, 0);
//   for (final i = 0; i < original.length; i++) {
//     encoded[i] = (original[i] + key) % base;
//   }
//   return encoded;
// }
