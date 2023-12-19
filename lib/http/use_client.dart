import 'dart:io';
import 'package:http/http.dart' as http;

void main(List<String> args) async {
  // await clientRead();
  // final uri =
  // Uri.http('devimages.apple.com', '/iphone/samples/bipbop/bipbopall.m3u8');
  final uri = Uri.http(args[0], args[1]);
  // final outpath = './lib/http/downloads/bipbopall.m3u8';
  final output = await File(args[2]).create(recursive: true);
  // await clientGet(uri);
  await clientReadBytes(uri, output);
}

Future<void> clientRead() async {
  // final httpPackageUrl = Uri.parse('https://dart.dev/f/packages/http.json');
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  final client = http.Client();
  try {
    final httpPackageInfo = await client.read(httpPackageUrl);
    print(httpPackageInfo);
  } finally {
    client.close();
  }
}

Future<void> clientGet(Uri uri) async {
  final client = http.Client();
  final outpath = './lib/http/downloads/bipbopall.m3u8';
  try {
    final output = await File(outpath).create(recursive: true);
    final res = await client.get(uri);
    await output.writeAsString(res.body);
    print(res.body);
  } on Error catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}

Future<void> clientReadBytes(Uri uri, File output) async {
  final client = http.Client();
  try {
    // final bytes = await client.readBytes(uri);
    await output.writeAsBytes(await client.readBytes(uri));
  } on Error catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}
