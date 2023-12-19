import 'package:http/http.dart' as http;

void main() async {
  // https://dart.dev/f/packages/http.json
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  final httpPackageInfo = await http.read(httpPackageUrl);
  print(httpPackageInfo);
}
