await: 等待 Future 对象执行完成。

**Important**
### 不要轻易使用 await
不要轻易使用 await，除非必须等待当前步骤执行完毕后才能执行后续的语句。
await 会阻塞当前的 isolate，将本来可以并行或异步处理的任务变成串行执行。
如果当多个任务没有先后执行顺序的要求时，不要使用 await。尤其是在 for/while 循环中，如果使用了 await，可能会导致程序执行变为线性执行（即使使用isolate并发也不行）。
for example:

```dart
// part of 'lib/http/download_and_merge_ts.dart'

// 下面的代码，虽然使用了isolate，但仍然会变成线性执行
// Note: 因为这里在 Isolate.run 前 使用了 await，那么每次等 run 执行完，才会执行下一个迭代，
// 阻塞了后面的循环，将并行变成了串行。
Future<List<File>> lineProcess(List<String> fpths, int n) async {
  // final sn = (fpths.length / n).ceil();
  final sn = fpths.length ~/ n + 1;
  final files = <File>[];
  for (var i = 0; i < sn; i++) {
    files.add(await Isolate.run(() => downloadAndMerge(fpths, i, n)));
  }
  return files;
}

// 正确的写法：
// Note: 这才是真正的并行，从输出顺序中可以看出来各 isolate 是并行执行的。
List<Future<File>> conprocess(List<String> fpths, int n) {
  // final sn = (fpths.length / n).ceil();
  final sn = fpths.length ~/ n + 1;
  final futrFiles = <Future<File>>[];
  for (var i = 0; i < sn; i++) {
    // Important: can't use await here.
    futrFiles.add(Isolate.run(() => downloadAndMerge(fpths, i, n)));
  }
  return futrFiles;
}

// 上面函数 返回值为 List<Future<File>>，如果要等待全部完成，可以使用如下方法：
// await List<Future>.wait

```

### 等待多个Future完成的方法
如果要等待多个Future一起执行完毕，可以采用如下几种方法：
- await Future.wait(List<Future>)
- await List<Future>.wait
- await Record<Future>.wait
**注意：这些多 Future 的等待方法不保证每个Future执行顺序，如果多个Future之间有先后依赖或执行顺序，不要使用这些方法。要依次使用 await**

### 必须使用 await 的场景
但当如果需要等待当前执行的 Future 对象执行完毕后，才能执行后续的语句时，必须使用 await。且：
- 不能使用 await Future.wait(List<Future>)
- 不能使用 await List<Future>.wait
- 不能使用 await Record<Future>.wait
**因为 这些多 Future 的等待方法不保证执行顺序。**
  
for example:

```dart

void main(List<String> args) async {
  final f1 = File('file1.txt').openRead();
  final f2 = File('file2.txt').openRead();
  final out = File('out.txt').openWrite();

  // 依次调用两个 pipe 不行，第一个调用完后，会把 out 关闭，出现下面错误：
  // FileSystemException: File closed, path = 'out.json'
  // await f1.pipe(out);
  // await f2.pipe(out);

  // 但 先后调用 addStream 可以，但一定要用 await. 否则会有下面错误：
  // Bad state: StreamSink is already bound to a stream
  await out.addStream(f1);
  await out.addStream(f2);
  out.close();
}
```
或者如：
```dart
Future<File> writeAsStream(String fpth, Stream<List<int>> stream) async {
  final file = await File(fpth).create(recursive: true);
  final sink = file.openWrite();

  // 以下三行必须依次执行，且必须使用 await. 
  // 不能使用 Future.wait([sink.addStream(), sink.flush(), sink.close()])
  // 不能使用 await [sink.addStream(), sink.flush(), sink.close()].wait
  // 或 await (sink.addStream(), sink.flush(), sink.close()).wait
  // 因为 这些多 Future 的等待方法不保证执行顺序。
  await sink.addStream(stream);
  await sink.flush();
  await sink.close();

  return file;
}
```