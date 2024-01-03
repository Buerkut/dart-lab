Dart开发环境搭建之pub环境变量配置——包镜像地址配置

blog url: https://www.cnblogs.com/codexspace/p/14377368.html

    在搭建Dart开发环境时，包管理工具pub有两个关键的环境变量，可以进行配置。尤其是包依赖的URL变量配置，可以解决外部官网pub.dev经常被封上不去的情况。

一、PUB_CACHE

    这个变量决定了pub get 下载的那些包依赖资源放到何处。默认情况下，PUB_CACHE 存储在你的用户目录（Mac 和 Linux）或 %APPDATA%\Pub\Cache 目录（Windows，不同版本的 Windows 操作系统可能会不一样）下的子目录中。如果你想更改地址，可以配置该环境变量设置为新的地址。如我将其配置在开发环境目录下（windows）,以方便查找：

二、PUB_HOSTED_URL

    该变量指定了pub get从哪里下载依赖包的资源。默认为 pub.dev. 但在国内，（很）经常出现下载不了的情况，因此可以通过设置该变量指定镜像地址。国内镜像地址有很多，这里推荐一个我自己经常用的清华大学TUNA协会的镜像地址（感谢清华TUNA协会）：

https://mirrors.tuna.tsinghua.edu.cn/dart-pub/

当然，也可以不设置系统级的环境变量，可以编辑一个pubmir.bat的文件，每次运行pub get前，运行一次该文件即可。

pubmir.bat代码：

@echo off
rem set pub packages mirrors by using 'https://mirrors.tuna.tsinghua.edu.cn/dart-pub' to replace offical site 'https://pub.dev/'

set PUB_HOSTED_URL=https://mirrors.tuna.tsinghua.edu.cn/dart-pub/
 