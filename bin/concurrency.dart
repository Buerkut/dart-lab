// ignore_for_file: non_constant_identifier_names

import 'dart:isolate';

void main() async {
  final n = 10;

  var st = DateTime.now();
  final r = fib(n);
  final s_cost = DateTime.now().difference(st).inMilliseconds;
  print('s-cost: $s_cost');
  print('r: $r\n');

  st = DateTime.now();
  final sr = await Isolate.run(() => fib(n));
  final s_cost2 = DateTime.now().difference(st).inMilliseconds;
  print('s-cost2: $s_cost2');
  print('sr: $sr\n');

  st = DateTime.now();
  final cr = await c_fib(n);
  final c_cost = DateTime.now().difference(st).inMilliseconds;
  print('c-cost: $c_cost');
  print('cr: $cr');
}

int fib(int n) {
  if (n <= 1) return n;
  return fib(n - 1) + fib(n - 2);
}

Future<int> c_fib(int n) async {
  if (n <= 1) return n;
  var x = await Isolate.run(() => c_fib(n - 1));
  var y = await c_fib(n - 2);
  return x + y;
}
