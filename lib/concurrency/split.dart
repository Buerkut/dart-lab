// 尝试切分任务，然后以并发的形式执行。
// a: 总任务数，n: 线程数
// 尝试两种拆法
import 'dart:async';
// import 'dart:io';
import 'dart:isolate';
import 'dart:math';

void main(List<String> args) {
  final [a, n] = args.map((e) => int.parse(e)).toList();
  var tasks = List.filled(a, 0);
  conprocess(tasks, n, handle);
  // print('');
  // splitTasks(a, n);
}

// 第一种拆分法：每个线程处理 (seg = a ~/ n) 个任务；
// 最后一个线程处理所有剩余的任务。最后一个线程处理的任务数为 (seg+a%n) 个.
// 推荐采用此方法.
List<Future<R>> conprocess<R, T>(List<T> tasks, int n,
    Future<R> Function(List<T> tasks, int i, int begin, int end) compute) {
  final seg = tasks.length ~/ n;
  // print('Each isolate handle $seg tasks.');

  var i = 0, results = <Future<R>>[];
  while (i < n - 1) {
    results.add(Isolate.run(() => compute(tasks, i, seg * i, seg * (i + 1))));
    i++;
  }
  results.add(Isolate.run(() => compute(tasks, i, seg * i, tasks.length)));

  return results;
}

// 实际应用中可以替换为真实函数
Future<void> handle<T>(List<T> tasks, int i, int begin, int end) async {
  print('Isolate$i: $begin - ${end - 1}');
  // return null;
}

// 第二种拆分法：每个线程处理 (seg = a ~/ n).ceil() 个任务；
// 这种拆分方法，可能会浪费最后一个线程. 比如当 a=49, n=8时，拆分如下：
// 0: 0 - 6
// 1: 7 - 13
// 2: 14 - 20
// 3: 21 - 27
// 4: 28 - 34
// 5: 35 - 41
// 6: 42 - 48
void splitTasks(int a, int n) {
  final seg = (a / n).ceil();
  print('Each isolate handle $seg tasks.');
  for (var i = 0; i < n && seg * i < a; i++) {
    Isolate.run(() => handle2(i, seg, a));
  }
}

void handle2(int i, int seg, int a) {
  print('Isolate$i: ${seg * i} - ${min(seg * (i + 1) - 1, a - 1)}');
}
