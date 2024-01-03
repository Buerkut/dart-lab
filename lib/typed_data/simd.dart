import 'dart:typed_data';

void main() {
  var arr = Int32x4(1, 2, 3, 4);
  var brr = Int16List.fromList([4, 5, 6, 7]);
  var ma2 = arr + arr;
  var mb2 = brr + brr;
  print(ma2);
  print(mb2);
  multip();
}

void multip() {
  final a = Float32x4(1, 2, 3, 4);
  final b = Float32x4(2, 3, 4, 5);
  final c = a * b;
  print(c);
}
