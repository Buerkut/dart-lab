import 'dart:async';

Stream<int> buildAStream(int n) async* {
  var i = 0;
  while (i < n) {
    // 延迟一秒钟。注意这个延迟一定要用 await, 否则就异步了。
    // 该句也可以注释掉，那样就没有延迟了，会一次生成所有的 i 到 stream 中。
    await Future.delayed(Duration(seconds: 1));
    yield i++;
  }
}
