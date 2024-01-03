Dart library 可见性及 library part / part of 命令详解—库的组合及可见性

blog url: https://www.cnblogs.com/codexspace/p/14381906.html

一、库与可见性的概念

    首先说明一个概念，在dart中，默认一个dart文件就是一个库，称为Mini Library.而不是在pubspec中用name关键字定义的包名下的lib目录下的所有的文件是一个库。理解了这个概念以后，再理解可见性就简单多了。官方文档说的“Every Dart app is a library”，实际上很多翻译过来都是不对的（实际上我觉得官方原文说的也有歧义）。因为如果每一个dart App都是一个库的话，那么如果这个App由多个dart文件组成，你会发现以‘_’开头的库成员（变量/方法等）在多个dart文件之间仍然不用复用，这也给我造成了很久的困惑。

    总之：dart默认一个dart文件就是一个库，该库中以‘_’开头的库成员，仅在库内可见，库外不可见。

二、library、part、part of 关键字说明

2.1 多个文件组成一个库

    虽然在官方文档和effective dart中，均不推荐使用library 和part 关键字，但一直想弄明白这两个关键字是怎么使用的，以及又对前面提到的可见性有什么影响。

    前面提到，dart默认一个dart文件就是一个库，那么如何将多个文件组成一个库呢？这就需要使用library和part关键字了。比如，我们做一个测试项目，文件目录结构如下：



 我们将visib/visib1/visib2三个dart文件组成一个库。

1、首先，指定一个主库文件，我们用visib.dart。在visib.dart中，使用library关键字定义库名（visib）：

library visib;

 2、然后分别在visib1/visib2 两个分库文件中，使用part of 关键字，声明是库的一部分：

part of visib;

特别说明的一点是，1、2、步骤的两句声明，一定要放在文件的第一行，否则会出错。

3、在visib.dart中，采用 part 关键字建立关联：

part 'visib1.dart';
part 'visib2.dart';
 这样，这三个dart文件就组成了一个库 library visib。

2.2 上述库的可见性及使用方法

2.2.1 库内可见性

    上面3个文件组成一个库以后，这3个文件内以‘_’开头的成员，在库内（3个文件内）可见，可互相调用，比如visib1.dart可以随意调用visib.dart 或 visib2.dart的所有成员，就像它们是在同一个dart文件中一样。且文件头部不再需要使用import指令导入库内的文件。当然，不以‘_’开头的更可见了。

2.2.2 外部库导入注意点

    特别强调的一点是，如果需要使用import导入其它的库，则该指令只能放在主库文件中，不能放在分库文件中。主库文件中导入的外部库，分库不用重复导入即可直接引用。同时，import指令位置也有要求，只能放在 library 和 part指令行之间，否则也会报错。示例代码如下：

复制代码
library visib;

import 'dart:math';

part 'visib1.dart';
part 'visib2.dart';

void visib() {
  visib1();
  visib2();
  _vis1();
  _vis2();
}

void _visi() {}
复制代码
 2.2.3 其它库如何使用多个文件组成的库

    其它库或脚本如果需要上述visib库，则只需要/也只能导入主库文件即可。该库内位于多个文件内的不以‘_’开头的成员，均可被调用。以‘_’开头的成员则不可见。示例代码如下：

复制代码
import 'package:hello_lib/visibility/visib.dart';

void main() {
  visib();
  // var vv = _Visib1();
  visib1(); // in visib1.dart
}
复制代码
 如上述代码中的visib1()方法，就是定义在分库文件visib1.dart中。如果导入分库文件visib1.dart，则编译器直接提示错误：

The imported library ''package:hello_lib/visibility/visib1.dart'' can't have a part-of directive.
Try importing the library that the part is a part of.dart(import_of_non_library)
 意思就是说你导入的是个分库文件，请导入主库。

 
    以上就是关于库、library、part、可见性的说明，其中参考了：

http://www.5imoban.net/jiaocheng/dart/2020/0929/4002.html

文档，向原作者致敬。