The following code shows the differences between the usage between pipe and addStream

```dart

import 'dart:io';

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

Why doesn't pipe work but addStream do? The official documents are as follows：

### pipe method

url: <https://api.dart.dev/stable/3.2.3/dart-async/Stream/pipe.html>
```dart
Future pipe(
  StreamConsumer<T> streamConsumer
)
```

> Pipes the events of this stream into streamConsumer.
> 
> All events of this stream are added to streamConsumer using StreamConsumer.addStream. > **The streamConsumer is closed when this stream has been successfully added to it** - > when the future returned by addStream completes without an error.
> 
> Returns a future which completes when this stream has been consumed and the consumer > has been closed.
> 
> **The returned future completes with the same result as the future returned by StreamConsumer.close**. If the call to StreamConsumer.addStream fails in some way,  this method fails in the same way.

**Note: after pipe is called and completes without an error, the stream and the streamConsumer are closed. Any further operation on the stream or streamConsumer will fail.**

### addStream abstract method
url: <https://api.dart.dev/stable/3.2.3/dart-io/IOSink/addStream.html>

```dart
Future addStream(
  Stream<List<int>> stream
)
```
> Adds all elements of the given stream.
> 
> Returns a Future that completes when all elements of the given stream have been added.
> 
> **This method must not be called when a stream is currently being added using this method.**

**Note: This method must not be called when a stream is currently being added using this method. *That means it can be called when the previous stream added to it finished.***
