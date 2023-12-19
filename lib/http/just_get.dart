// download a m3u8 file from internet
// use isolate

import 'package:http/http.dart' as http;

void main() async {
  // https://dart.dev/f/packages/http.json
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  final httpPackageResponse = await http.get(httpPackageUrl);
  if (httpPackageResponse.statusCode != 200) {
    print('Failed to retrieve the http package!');
    return;
  }
  print(httpPackageResponse.body);
}
