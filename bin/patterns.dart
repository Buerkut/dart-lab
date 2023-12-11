import 'dart:math' as math;

void main() {
  const a = 'a';
  const b = 'b';
  var list = ['c', 'd'];
  switch (list) {
    // List pattern [a, b] matches obj first if obj is a list with two fields,
    // then if its fields match the constant subpatterns 'a' and 'b'.
    case [a, b]:
      print('$a, $b');
  }

  switch (list) {
    case ['a' || 'c', var d]:
      print(d);
  }
  // var arr = [1, 2, 3];
  // var [x, y, z] = arr;
  // print(x + y + z);
  var pair = (3, 2);
  switch (pair) {
    case (int a, int b) when a == b:
      print('a == b');
    case (int a, int b) when a > b:
      print('First element greater');
    case (int a, int b) when a < b:
      print('Second element greater');
  }

  Map<String, int> hist = {
    'a': 23,
    'b': 100,
  };

  for (var MapEntry(:key, value: count) in hist.entries) {
    print('$key occurred $count times');
  }

  (int?, int?) position = (2, 3);
  var (x!, _) = position;
  print(x.toInt());
  print(math.pi);

  Record r = (1, 2);
  print(r.runtimeType);
  r.toString();

  var lang = (front: 'dart', back: 'rust');
  var (front: dart, back: rust) = lang;
  // var (:front, :back) = lang;
  print((dart, rust));
  print(lang.front + lang.back);
  var arr = [1];
  try {
    print(arr[2]);
  } catch (e) {
    print(e);
  }
}

sealed class Shape {}

class Square implements Shape {
  final double length;
  Square(this.length);
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
}

double calculateArea(Shape shape) => switch (shape) {
      Square(length: var l) => l * l,
      Circle(radius: var r) => math.pi * r * r
    };
