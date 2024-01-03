import 'dart:convert';
import 'dart:io';

// cli args: ./res/m3u8_url.json
void main(List<String> args) async {
  final jspath = args[0];
  final (authority, unencodedPath) = await getUriInfo(jspath);
  print('authority: $authority');
  print('unencodedPath: $unencodedPath');
}

Future<(String, String)> getUriInfo(String jspath) async {
  final content = await File(jspath).readAsString();
  final urlJson = json.decode(content) as Map<String, dynamic>;
  return (urlJson['authority'] as String, urlJson['unencodedPath'] as String);
}
