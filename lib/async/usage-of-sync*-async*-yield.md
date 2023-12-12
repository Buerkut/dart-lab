async: 表示一个异步操作，返回一个 Future 对象。
await: 等待 Future 对象执行完成。

async*: 表示一个异步操作，返回一个 Stream 对象。
yield: 向 Stream 对象添加一个元素。
yield*: 向 Stream 对象添加一个 Stream 对象。
await for: 以常规形式处理 Stream 对象。

sync*: 表示一个同步操作，返回一个 Iterable 对象。
yield: 向 Iterable 对象添加一个元素。
yield*: 向 Iterable 对象添加一个 Iterable 对象。


In short, sync* creates an Iterable , and async* creates a Stream , 
and both use yield to add one element, and yield* to splice an existing iterable or stream into the result. 

The Future class, part of dart:async, is used for getting the result of a computation after an asynchronous task has completed.
