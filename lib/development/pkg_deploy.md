Dart pub如何部署或发布package和应用

blog url: https://www.cnblogs.com/codexspace/p/14380008.html

上篇博文介绍了几个常用的pub命令，我们了解了可以通过pub run 或 pub global来运行命令行的脚本。那么，如何发布一个包，或者部署一个应用呢？

1、发布package

    可以使用 pub publish 命令将 Package 上传至 Pub 网站（pub.dev）以分享给全世界的开发者使用。 pub uploader 命令则可以允许指定用户修改 Package 和上传新版本的 Package。如果有发布的定制化需求，可以在pubspec中配置 publish_to 参数,同时dart也支持发布至私有服务器，具体可以参考 

https://github.com/dart-lang/pub-dev。

2、部署或发布命令行应用

    通常我们开发的工具，或者服务端的系统，均需要本地化的部署或发布。在dart中，任何包含脚本（即在 bin/ 目录下有任意文件）的 Package，可以在 pubspec 文件中添加上 executables 标签。当一个脚本标识为 executables 时，用户可以直接从命令行使用 pub global activate 命令激活（也即部署）它，然后就可以在全局通过命令行窗口运行它。这个在上篇博文介绍

pub global 

命令时，已经有过详细的介绍.
