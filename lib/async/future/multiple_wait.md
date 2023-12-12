### Waiting for multiple futures

Sometimes your algorithm needs to invoke many asynchronous functions and wait for them all to complete before continuing. Use the Future.wait() static method to manage multiple Futures and wait for them to complete:

```dart
Future<void> deleteLotsOfFiles() async =>  ...
Future<void> copyLotsOfFiles() async =>  ...
Future<void> checksumLotsOfOtherFiles() async =>  ...

await Future.wait([
  deleteLotsOfFiles(),
  copyLotsOfFiles(),
  checksumLotsOfOtherFiles(),
]);
print('Done with all the long steps!');
```

Future.wait() returns a future which completes once all the provided futures have completed. It completes either with their results, or with an error if any of the provided futures fail.

Handling errors for multiple futures
You can also wait for parallel operations on an iterable or record of futures.

These extensions return a future with the resulting values of all provided futures. Unlike Future.wait, they also let you handle errors.

If any future in the collection completes with an error, wait completes with a ParallelWaitError. This allows the caller to handle individual errors and dispose successful results if necessary.

**When you don’t need the result values from each individual future, use wait on an iterable of futures:**

```dart
void main() async {
  Future<void> delete() async =>  ...
  Future<void> copy() async =>  ...
  Future<void> errorResult() async =>  ...
  
  try {
    // Wait for each future in a list, returns a list of futures:
    var results = await [delete(), copy(), errorResult()].wait;

    } on ParallelWaitError<List<bool?>, List<AsyncError?>> catch (e) {

    print(e.values[0]);    // Prints successful future
    print(e.values[1]);    // Prints successful future
    print(e.values[2]);    // Prints null when the result is an error

    print(e.errors[0]);    // Prints null when the result is successful
    print(e.errors[1]);    // Prints null when the result is successful
    print(e.errors[2]);    // Prints error
  }
}
```

**When you do need the individual result values from each future, use wait on a record of futures.** This provides the additional benefit that the futures can be of different types:

```dart
void main() async {
  Future<int> delete() async =>  ...
  Future<String> copy() async =>  ...
  Future<bool> errorResult() async =>  ...

  try {    
    // Wait for each future in a record, returns a record of futures:
    (int, String, bool) result = await (delete(), copy(), errorResult()).wait;
  
  } on ParallelWaitError<(int?, String?, bool?),
      (AsyncError?, AsyncError?, AsyncError?)> catch (e) {
    // ...
    }

  // Do something with the results:
  var deleteInt  = result.$1;
  var copyString = result.$2;
  var errorBool  = result.$3;
}
```