import 'dart:io';

void main(List<String> args) async {
  // Or you can read args from cli input.
  final url = Uri.http(
      'devimages.apple.com', '/iphone/samples/bipbop/gear2/fileSequence0.ts');
  final path = './lib/http/downloads/gear2/fileSequence0.ts';
  await download(url, path);
}

// 试试单个下载。
Future<File> download(Uri url, String path) async {
  final file = await File(path).create(recursive: true);
  final client = HttpClient();
  IOSink? sink;
  try {
    // final request = await client.openUrl('GET', url); // It's OK, too.
    final request = await client.getUrl(url);
    final response = await request.close();
    // Process the response
    // final data = await response.transform(utf8.decoder).join();
    // var data = await utf8.decoder.bind(response).join();
    // print(data);
    sink = file.openWrite();
    // 以下两行必须依次执行，所以依次使用 await。
    await sink.addStream(response);
    await sink.flush();
  } finally {
    client.close();
    sink?.close();
  }
  return file;
}
