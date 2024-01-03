Dart package包目录结构示例及主要目录功能说明

blog url: https://www.cnblogs.com/codexspace/p/14377713.html

    各种语言都有自己的包默认的目录结构，dart也不例外。假设有一个名称为 enchilada 的完整的包目录（基本用到了所有的子目录），那么它的目录结构看起来像下面这样：

复制代码
enchilada/
  .dart_tool/ *
  .packages *
  pubspec.yaml
  pubspec.lock **
  LICENSE
  README.md
  CHANGELOG.md
  benchmark/
    make_lunch.dart
  bin/
    enchilada
  doc/
    api/ ***
    getting_started.md
  example/
    main.dart
  lib/
    enchilada.dart
    tortilla.dart
    guacamole.css
    src/
      beans.dart
      queso.dart
  test/
    enchilada_test.dart
    tortilla_test.dart
  tool/
    generate_docs.dart
  web/
    index.html
    main.dart
    style.css
复制代码
其中：

* .dart_tool 和 .packages 是由pub get 生成的，不需要纳入版本管理；

** pubspec.lock 也是由 pub get 命令生成的，除非你的包是应用程序包，否则也不建议纳入版本管理； 

*** doc/api 目录是有dartdoc命令运行后生成的。不要纳入版本管理。

 

重点说明一下下面几个目录：

一、public 文件夹 （Public directories）

    Public文件夹，对其它项目或引用者公开，由两个目录组成：lib 和 bin。lib存放库文件（libraries），bin存放一些工具文件。

1、Public libraries：lib

在上面的例子中，库文件夹如下，其中的文件可以被其他包导入和依赖、使用。

 

enchilada/
  lib/
    enchilada.dart
    tortilla.dart
2、Public tools：bin

    这里放置一些公共的脚本、工具。这些脚本和工具可以通过pub run 或 pub global run 进行运行。注意，项目私有的一些工具，不是放在这里的，而是放在tool文件夹下。

    对于 CLI App，程序入口文件也建议放置在bin目录下，这样当你通过pub global激活它以后，就可以在任何CLI窗口运行它。

二、Implementation files

    放置在lib/src文件夹下。如下所示：

enchilada/
  lib/
    src/
      beans.dart
      queso.dart
    该目录下的文件，对外是不可见的，除了本项目以外，其它任何项目不要引用src目录中的文件，你也不要引用任何其它包的src下的文件。src下的功能，可以通过export关键字进行导出至lib下的文件中。同时，根据dart web开发的最佳实践，dart web开发以来的dart实现文件，均建议放置在该目录下，这样性能最高。

三、Internal tools and scripts

    项目中经常有一些内部使用的工具和脚本，建议放置在tool目录下，该目录约定对外不可见或不可使用。

enchilada/
  tool/
    generate_docs.dart
 

最后，其它更为详细的信息，请参考官方文档《Package 的文件结构》：

https://dart.cn/tools/pub/package-layout