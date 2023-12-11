import 'dart:io';

// rename 可以更改路径，不仅仅是文件名。前提是路径必须存在。
Future<bool> rename(String oldpath, String newpath) async {
  final file = File(oldpath);
  if (await file.exists()) {
    print('path is right');
    await file.rename(newpath);
    return true;
  } else {
    print('path is wrong');
    return false;
  }
}
