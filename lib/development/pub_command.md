Dart 包管理工具 pub 常用命令解析

blog url: https://www.cnblogs.com/codexspace/p/14379363.html

update: 2024-01-03
*Now use 'dart pub' instead of 'pub'*

    Dart采用pub管理包，介绍几个常用的pub命令。

1、pub get

    获取包依赖。具体是指获取在pubspec.yaml文件中dependencies目录下指定的依赖的包。在实际运行时，pub会先到pub cache目录下该依赖项是否存在，不存在才会去获取。默认情况下，Pub 会创建一个 .packages 文件用于映射 Package 名到位置 URI。在创建 .packages 文件之前，Pub 常常还会创建一个 packages 目录。

    pub get 命令获取新依赖项后会写入一个 lockfile 文件以确保下次执行该命令时会使用相同的依赖项版本。应用型的 Package（即Application package） 应该总是签入该 lockfile 文件以控制来源，从而确保在将 Package 部署到生产环境时所有的依赖项对于所有开发者而言都是相同的版本。库类型的 Package（即Libraries package） 则不需要签入 lockfile 文件，因为它们可能需要使用到不同的依赖项版本。

    获取完毕后，就可以在代码中通过import命令导入并使用这些包了。

    当更新pubspce文件中的包依赖时（包括更新、增加、删除等），运行pub get命令，会自动更新相关内容。现在的IDE一般都不需要手动运行该命令了，比如VS CODE的dart插件，每次更新并保存pubspec文件时，会自动运行该命令。

    如果没有网络、或者你不想 Pub 去线上检查，可以使用 --offline 命令参数让该命令在离线模式下执行。在离线模式下，Pub 只会从本地缓存区查找已经下载到的可用 Package。

2、pub run

    使用该命令可以从命令行运行一个位于你 Package 中或 Package 依赖项中的脚本。注意，该命令只能运行位于你当前package或其依赖项中的脚步。如果需要运行其它package中的脚步，需要使用 global参数。比如我自己写了一个计算器，入口位于bin\calculate.dart,则在命令行可以通过如下命令运行：

d:\workspace\dart\calculate>pub run calculate
    若有指定目录，可以加上指定目录，如

pub run example\calculate

若要运行依赖项中的脚本，前面加上包名即可，比如我运行项目中依赖的表达式解析包（exp_parse）的例子parse.dart,其位于exp_parse/bin/parse.dart:

pub run exp_parse:parse

说重点：你只能运行位于其它 Package bin 目录下的脚本，其它目录下的脚本则不可运行。

3、pub global

    Pub 的 global 选项允许你在任意位置下从命令行运行 Dart 脚本。在 激活 Package 后，你可以 运行 该 Package bin 目录下的脚本。停用 Package 后你可以从全局可用的 Package 列表中将其移除。该命令的用处比较多，下面详细介绍。

3.1 激活脚本（activate）

    在使用全局命令之前，首先需要用activate参数激活package。该 Package 可以是在 pub.dev 网站、Git 仓库或者你当前的电脑上。一旦你激活了 Package，就可以运行位于 该Package bin 目录下的脚本。

3.1.1 激活 pub.dev 网站上的 Package

激活 pub.dev 网站上的一个 Package。例如激活markdown包：

 pub global activate markdown

3.1.2 激活 Git仓库中的 Package

可以使用 --source git（或 -sgit 简写）命令参数可以激活位于 Git 仓库中的 Package。示例如下：

pub global activate --source git https://github.com/dart-lang/async_await.git
pub global activate -sgit https://github.com/dart-lang/async_await.git
 3.1.3 激活本地的package

更多的时候，我们是需要激活本地的包，比如我们自己开发的一些工具，激活为全局可用，可以通过使用 activate --source path <path> 命令参数来实现。这块在实操时，有好几个坑，目前官方文档上没有说明。我的项目pubspec文件如下： 

复制代码
name: data_intel

environment:
  sdk: ^2.10.4

dependencies:
  hello_image:
    path: ../hello_image
复制代码
 3.1.3.1 路径（文件夹）与包名

path可以使用绝对路径，也可以使用相对路径。但包名是个坑。注意，这里要使用文件夹名，而不是包名（尤其是二者不一致时），否则会提示找不到pubspec文件。比如我的文件夹名是 data_intelligence,但包名是 data_intel，第一次激活时，命令如下（相对路径）：

pub global activate --source path data_intel
 系统提示：Could not find a file named "pubspec.yaml" in "D:\Compute\Develop\Workspace\Dart\data_intel" 这说明pub 是按照文件夹名来找的。解决办法，要么将包名更改为与文件夹名一致，要么采用文件夹名作为path参数。采用文件夹名，继续运行：

 D:\Compute\Develop\Workspace\Dart> pub global activate --source path data_intelligence

 输出如下： 

Resolving dependencies...
Got dependencies!
Activated data_intel 0.0.0 at path "D:\Compute\Develop\Workspace\Dart\data_intelligence".
 发现没有，因为pubspec中定义的包名为data_intel，pub global activate激活的包名仍为data_intel。

3.1.3.2 文件位置：

pub global activate命令运行后，实际上做了什么动作？其实是在PUB_CACHE变量（参考我另一篇博文，pub环境变量配置）指定的文件夹下，创建了一个global_packages的文件夹（我是首次激活，否则该文件夹会存在且可复用），其中有一个data_intel的文件夹，注意，这里是按包名来命名的。该文件夹中又有一个pubspec.lock的文件。

3.1.3.3 运行

激活以后，理论上可以运行了。这里要注意，需要先将%PUB_CACHE%\bin加入环境变量path中。bin目录下文件名为main.dart，现在在命令行输入main，提示错误（powershell）： 

复制代码
无法将“main”项识别为 cmdlet、函数、脚本文件或可运行程序的名称。请检查名称的拼写，如果包括路径，请确保
路径正确，然后重试。
所在位置 行:1 字符: 5
+ main <<<< 
    + CategoryInfo          : ObjectNotFound: (main:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
复制代码
  更换命令如下，仍提示错误： 

PS C:\> pub global run main
No active package main.
PS C:\> pub global run data_intel
Could not find bin\data_intel.dart.
 这里的坑在于没有在pubspec.yaml文件中指定可运行的脚本。修改pubspec，增加如下代码：

executables:
  main:
 然后重新激活，即重新运行命令：

pub global activate --source path data_intelligence
输出如下： 

复制代码
Resolving dependencies...
Got dependencies!
Package data_intel is currently active at path "D:\Compute\Develop\Workspace\Dart\data_intelligence".
Installed executable main.
Activated data_intel 0.0.0 at path "D:\Compute\Develop\Workspace\Dart\data_intelligence".
复制代码
 发现没有，此时增加了两行蓝色的输出，重要的是 Installed executable main. 安装了可执行的main。那么到底发生了什么呢？我们继续到PUB_CACHE中看，发现cache目录下增加了一个bin目录，其中有一个文件：main.bat（之前没有）,内容为：

复制代码
@echo off
rem This file was created by pub v2.10.4.
rem Package: data_intel
rem Version: 0.0.0
rem Executable: main
rem Script: main
pub global run data_intel:main %*
复制代码
 如上，其实是做了一个命令的快捷方式。这时再在命令行执行main，即可执行。但执行时又发现一个坑，项目中有读写文件，用的都是相对路径，均报错。后来又改成绝对路径（或者和PUB_CACHE/bin相对的相对路径也可），执行正常。

关于这点，最后补充一下，可以在bin文件夹中包含多个脚本，同样也可以在pubspec中配置多个可执行脚本名称。pubspec中配置的数量<=bin目录下脚本的数量。

3.1.3.4 pubspec中可执行命令名称与bin目录下文件的对应：

继续折腾，main这个名称太笼统，我将pubspec中的代码改为： 

executables:
  dtree:
  如然后重新运行

pub global activate --source path data_intelligence
结果输出如下： 

复制代码
Resolving dependencies...
Got dependencies!
Package data_intel is currently active at path "D:\Compute\Develop\Workspace\Dart\data_intelligence".
Installed executable dtree.
Warning: Executable "dtree" runs "bin\dtree.dart", which was not found in data_intel.
Activated data_intel 0.0.0 at path "D:\Compute\Develop\Workspace\Dart\data_intelligence".
复制代码
 增加了一条红色的警告信息。尝试在命令行运行 dtree，输出如下： 

PS D:\Compute\Develop\Workspace\Dart> dtree
Could not find bin\dtree.dart.
 看来pub 寻址是按在pubspec中配置的“executables:”的名称来寻找脚本的。

3.1.4 更新已经激活的package

这个前面其实已经提到了，重复运行pub global activate 命令即可。可以对比cache目录下的文件，你会发现文件是最新生成的。

3.2 运行脚本

    其实前面已经提到，采用pub global activate激活后，并将%PUB_CACHE%\bin添加进系统path，即可从命令行运行该脚步。如果还有问题，可以参考前面的坑，看是否在pubspec中配置了executables参数，或者是否修改了path环境变量。

如果在pubspec中没有配置executables参数，激活后（注意，仍然需要先运行pub global activate命令），仍然可以通过 pub global run 命令进行运行。如先反激活（或称为卸载）刚才的data_intel包，然后在pubspec中删除executables参数配置，然后重新运行：

PS D:\Compute\Develop\Workspace\Dart> pub global run data_intel:main
No active package data_intel.
 这时候提示没有激活。运行pub global activate --source path data_intelligence进行激活，然后运行： 

PS D:\Compute\Develop\Workspace\Dart> pub global run main
No active package main.
 提示没有激活main，这告诉我们需要在脚本名称前加上包名，如前文main.bat中最后一行所示。如果只有包名，没有脚本名，则也会提示错误： 

PS D:\Compute\Develop\Workspace\Dart> pub global run data_intel
Could not find bin\data_intel.dart.
 运行 

pub global run data_intel:main 
则正确。但继续测试，发现，如果脚本名和包名一致，则可运行正确。执行如下步骤测试：

a. 反激活data_intel；

b. 删除pubspec中executables参数；

c. 重新激活data_intel；

此时运行，结果正常~！ 

PS E:\> pub global run data_intel
hello pub!
 结合前面的错误，总结如下：  当执行 

pub global run pkg_name 
命令，不带脚本名称时，其实会到pkg_name\bin目录下寻找与pkg_name同名的dart文件,即pkg_name.dart，如无则报错。

3.3 配置package为可执行

这个前面已经提到，在pubspec中配置executables参数即可，注意参数名要和bin目录下的脚本名称要保持一致。

3.4 停用（卸载、反激活）package

可以使用 deactivate参数来停用（卸载）已经激活的package。此时不需要指定path参数路径，示例： 

PS E:\> pub global deactivate data_intel
Deactivated package data_intel 0.0.0 at path "D:\Compute\Develop\Workspace\Dart\data_intelligence".
 查看cache目录，发现pub删除了bin目录下的bat文件和global_packages文件夹下的对应的包文件。

3.5 列出已激活的所有的包

可以使用命令 

 pub global list
 
列出所有已激活的包。

4、pub upgrade

可以通过pub upgrade更新包依赖。pub upgrade 命令与 pub get 命令一样，都是用于获取依赖项的。不同的是 pub upgrade 命令会忽略掉任何已存在的 lockfile 文件，因此 Pub 可以获取所有依赖项的最新版本。

 

在没有指定其它参数的情况下，pub upgrade 命令会获取当前工作目录下 pubspec.yaml 文件中所列出的所有依赖项的最新版本，包括这些依赖项中内部依赖的其它依赖项。当然，也可以指定package的名称，仅更新指定的包（依赖会一起更新）。其余的功能与pub get类似。

 

5、最后：其它命令

pub还有一些其它的命令，如deps、cache等，用法相对简单，这里不再赘述，详情可参考官网文档：

https://dart.cn/tools/pub/cmd

