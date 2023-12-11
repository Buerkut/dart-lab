void main() {
  var a = 15;
  print(dec2bin(a));
  print(dec2bin2(a));
  print(dec2bin3(a));
  var b = [];
  b.reversed;
}

String dec2bin(int a, [int? width]) {
  var b = a.toRadixString(2);
  if (width != null) b = b.padLeft(width, '0');
  // print('in dec2bin : $b');
  return b;
}

String dec2bin2(int a, [int? width]) {
  var b = a == 0 ? '0' : '';
  while (a > 0) {
    b = '${(a % 2 == 0 ? '0' : '1')}$b';
    a >>= 1;
  }

  if (width != null) b = b.padLeft(width, '0');
  // print('in dec2bin2: $b');
  return b;
}

String dec2bin3(int a, [int? width]) {
  var b = a == 0 ? '0' : '';
  for (var i = 1; i <= a; i <<= 1) {
    b = '${a & i == 0 ? '0' : '1'}$b';
  }

  if (width != null) b = b.padLeft(width, '0');
  // print('in dec2bin3: $b');
  return b;
}
