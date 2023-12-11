typedef Person = ({
  String name,
  int age,
  String Function(String name, int age) string
});

void main() {
  // var rec = (2, 'a', (int a) => a + 1);
  // print(rec);
  ({int a, int b, int Function(int a, int b) func}) rec;
  rec = (
    a: 2,
    b: 3,
    func: (a, b) {
      return a + b;
    }
  );
  var rst = rec.func(rec.a, rec.b);
  print(rst);

  rec = (a: 2, b: 3, func: multi);
  rst = rec.func(rec.a, rec.b);
  print(rst);
  // var (a, b) = (1, 2);
  var rt = (a: 2, b: 3);
  var (:a, :b) = rt;
  print((a, b));
  Person p = (name: 'bob', age: 20, string: toString);
  print(p.string(p.name, p.age));
}

int multi(int a, int b) => a * b;
String toString(String name, int age) {
  return 'name: $name, age: $age';
}
