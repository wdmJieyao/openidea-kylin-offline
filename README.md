# OpenIDEA 麒麟 V10 离线包

面向麒麟 V10 x86_64 和 glibc 2.31 的 OpenIDEA v0.1.50 便携包。包内提供 OpenIDEA 运行所需的 glibc 2.35、GTK 3 和 WebKitGTK 4.1，以及 Java 开发工具。使用普通桌面账号解压并启动即可。上游项目为 [l0ng-ai/openidea](https://github.com/l0ng-ai/openidea)。

## 下载

- [x86_64 离线包（610 MiB）](https://github.com/wdmJieyao/openidea-kylin-offline/releases/download/v0.1.50-kylin.1/OpenIDEA-0.1.50-KylinV10-x86_64.tar.gz)
- [SHA-256 校验文件](https://github.com/wdmJieyao/openidea-kylin-offline/releases/download/v0.1.50-kylin.1/OpenIDEA-0.1.50-KylinV10-x86_64.tar.gz.sha256)
- [发布说明](https://github.com/wdmJieyao/openidea-kylin-offline/releases/tag/v0.1.50-kylin.1)

## 启动

把压缩包和校验文件放到同一目录，在图形桌面终端运行以下命令。

```bash
sha256sum -c OpenIDEA-0.1.50-KylinV10-x86_64.tar.gz.sha256
tar -xzf OpenIDEA-0.1.50-KylinV10-x86_64.tar.gz
cd OpenIDEA-0.1.50-KylinV10-x86_64
bash 启动-OpenIDEA.sh
```

启动器为 OpenIDEA 及其子进程加载包里的运行库。首次启动会配置 java-analyzer、Eclipse JDT LS 和 kmp-lsp。包内还提供 Temurin JDK 25、Maven、Java Debug，以及可选安装的 MyBatis、Checkstyle、Test Runner 和 Git Toolbox 插件。项目构建依赖可从内网仓库或本地缓存获取。

断网的 x86_64 Linux 5.4、glibc 2.31 虚拟机已验证图形界面和三个语言服务器的初始化。目标麒麟 V10 实机仍需试跑。启动需要图形桌面的 X11 或 XWayland，以及普通账号可用的 `ptrace`。

[离线使用说明](使用说明.md) · [第三方组件与源码](SOURCES.md)
