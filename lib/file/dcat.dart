import 'dart:io';

void dcat(File file) {
  stdout.addStream(file.openRead());
}
