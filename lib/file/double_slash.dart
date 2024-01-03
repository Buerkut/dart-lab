import 'dart:io';

void main() async {
  final dirpath = './lib/file/res/';
  final file = await File('$dirpath/doubslash.txt').create();
  print(file.path);
}
