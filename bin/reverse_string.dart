void main() {
  var str = 'dart';
  print(invertString(str));
  print(invertString2(str));
}

String invertString(String str) {
  return str.split('').reversed.join();
}

String invertString2(String str) {
  var buff = StringBuffer();
  for (var i = str.length - 1; i >= 0; i--) {
    buff.write(str[i]);
  }
  return buff.toString();
}
