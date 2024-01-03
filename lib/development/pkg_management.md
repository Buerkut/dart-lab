dart开发环境搭建之包依赖

blog url: https://www.cnblogs.com/codexspace/p/14376494.html

    dart的设计哲学鼓励代码复用和共享。因此，dart项目可以方便的复用各种公有或私有的代码，dart将这种可复用的代码称为包（package），并通过pub工具来管理这些复用的包。flutter也类似。flutter不能称为一个语言，它只是dart在App领域的一个框架，其后台语言还是dart。但这也为前端同学走向后端、全栈提供了一条新的道路。

一、概述

    dart 项目中，如果要使用包依赖，有两种情况：

1、使用系统自带的包，直接在代码中导入即可，如：

import 'dart:io'
2、使用第三方的包。此时 需要配置pubspec.yaml文件。详细的pubspec文件格式可以参考官网介绍：

https://dart.cn/tools/pub/pubspec

对于包的依赖，可以如下实现： 

name: my_app
dependencies:
  js: ^0.6.0
  intl: ^0.15.8
     通过dependencies关键声明需要依赖的包，以及版本约束。^表示版本约束。例如, ^1.2.3 等于 '>=1.2.3 <2.0.0', 后者是dart之前比较传统的版本约束表达方式。

二、各种依赖方式配置详述

dart目前支持4中依赖方式：

SDK
Hosted packages
Git packages
Path packages
1、SDK的依赖方式

    SDK的依赖方式，目前主要适用于flutter，格式如下：

dependencies:
  flutter_driver:
    sdk: flutter
    version: ^0.0.1
2、Hosted packages

    Hosted packages 是发布并托管到服务器上的包，dart官方包的服务器为 pub.dev ,当然，也支持私有服务器。如果是pub.dev上的包，不需要指定地址，pub get 命令默认会去获取。常见格式为：

dependencies:
  transmogrify: ^1.4.0
 如果是私有服务器，可以指定host的名称和地址：

 

复制代码
dependencies:
  transmogrify:
    hosted:
      name: transmogrify
      url: http://your-package-server.com
    version: ^1.4.0
复制代码
 

3、Git packages / Git包依赖

    有时候我们需要直接依赖Git上的包，可以通过如下方式直接描述依赖：

 

dependencies:
  my_git_app:
    git: https://github.com/munificent/my_git_app.git
 

Git关键字告诉pub 通过git命令及后面的URL去获取这个包。同样，这种方式也支持私有库、Git私服、分支或标签包、相对路径等方式，详情可以参考官方更详细的文档。

4、Path packages

    最后一种常见的情况，就是本地包依赖，即在本地环境中多个项目之间的依赖。dart支持相对路径、绝对路径对其它包的依赖。比如，我之前文中的一个例子，写了一个ASCII Image的工具，包的pubspec.yaml描述为：

name: hello_image

environment:
  sdk: ^2.10.4
    在另一个项目data intelligence中，现在需要依赖hello_image包，用来打印ASCII图形话的数据分析结果，如决策树，则对hello_image的依赖描述为：

复制代码
name: data_intel

environment:
  sdk: ^2.10.4

dependencies:
  hello_image:
    path: ../hello_image

    此时，pub会直接到指定的包路径中去查找lib目录，并且根据官网的介绍，被依赖包（如hello_image）的任何改变，都会及时的反映，不需要每次都运行pub命令。推荐使用相对路径。

    在实际配置中，遇到了无法解析本地依赖的情况，后来网上也没找到原因，重启了vs code后就自己好了。

    注意，使用本地依赖的项目，不要发布到pub.dev上，因为你的本地依赖是私有的。

 

    其它还有包依赖版本约束、开发包依赖、重载等更详细的内容，这里不啰嗦了，具体可以参考官网文档：

    https://dart.cn/tools/pub/dependencies