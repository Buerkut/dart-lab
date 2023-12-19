import 'dart:io';
// import 'dart:convert';

void main(List<String> args) async {
  final url = Uri.https('dart.dev', '/f/packages/http.json');
  final client = HttpClient();
  IOSink? sink;
  try {
    // final request = await client.openUrl('GET', url);
    final request = await client.getUrl(url);
    final response = await request.close();
    // Process the response
    // final data = await response.transform(utf8.decoder).join();
    // var data = await utf8.decoder.bind(response).join();
    // print(data);
    sink = File('./lib/http/downloads/test.txt').openWrite();
    await sink.addStream(response);
    await sink.flush();
  } finally {
    client.close();
    sink?.close();
  }
}
