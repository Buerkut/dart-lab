import 'list_apis.dart';

void main() {
  var list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  print(-list);
  var [list1, list2] = list.split(5);
  print(list1);
  print(list2);
  print(list.slice(3, 6));
  print(list.slice(8));
}
