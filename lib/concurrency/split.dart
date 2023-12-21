// 尝试切分任务，然后以并发的形式执行。
// a: 总任务数，n: 线程数
// 尝试两种拆法
import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:dartlab/list/list_apis.dart';

void main(List<String> args) {
  final [a, n] = args.map((e) => int.parse(e)).toList();
  var tasks = List.filled(a, 0);
  conprocess(tasks, compute, n);
  // print('');
  // splitTasks(a, n);
}

// 第一种拆分法：每个线程处理 (seg = a ~/ n) 个任务；
// 最后一个线程处理所有剩余的任务。最后一个线程处理的任务数为 (seg+a%n) 个.
// 推荐采用此方法.
List<Future<R>> conprocess<R, T>(
    List<T> tasks, Future<R> Function(int i, Iterable<T> slice) compute,
    [int isolateNum = 8]) {
  final results = <Future<R>>[];
  var i = 0, seg = tasks.length ~/ isolateNum;
  while (i < isolateNum - 1) {
    // Important: can't use await here.
    results.add(
        Isolate.run(() => compute(i, tasks.slice(seg * i, seg * (i + 1)))));
    i++;
  }
  results.add(Isolate.run(() => compute(i, tasks.slice(seg * i))));
  return results;
}

// 实际应用中可以替换为真实函数
Future<void> compute<T>(int i, Iterable<T> slice) async {
  print('Isolate$i: $slice');
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
