import 'package:language_basics/enum_syntax.dart';

void main() {
  print(Color.values);
  print(Color.blue);
  print(Color.values[0]);
  print(Color.blue.index);
  print(Color.blue.name);
  var record = ('first', a: 2, b: true, 'last');
  print(record.$1);
  (int, {int a}) r;
  r = (a: 9, 2);
  print(r.a);
  print(r.$1);
  print(r.a.hashCode);
  print(r.$1.hashCode);
  print(r.hashCode);
  var s = {1, 2};
  print(s.length);
  s.clear();
  print(s.length);
  var ss = ['aa'];
  var str = ss[0];
  ss.clear();
  print(str);
}
