# 第三方组件及源码

虚拟运行环境以 Ubuntu Base 22.04.5 amd64 为基础，并叠加 Ubuntu 22.04 软件包。完整的包名、二进制版本、源包版本和 Ubuntu 源码页面见 [Ubuntu 组件清单](licenses/ubuntu-source-packages.tsv)。各源包页面提供相应版本的源文件和 Debian 打包文件。压缩包中的 `runtime/usr/share/doc` 保留了软件包附带的版权和许可证信息。[Ubuntu Base 22.04.5](https://cdimage.ubuntu.com/ubuntu-base/releases/22.04.5/release/)

- OpenIDEA v0.1.50 使用上游 amd64 DEB 的程序和资源。MyBatis、Checkstyle、Test Runner、Git Toolbox 插件也来自同一上游版本。 [源码](https://github.com/l0ng-ai/openidea/tree/v0.1.50) · [发布页](https://github.com/l0ng-ai/openidea/releases/tag/v0.1.50)
- 启动器使用 PRoot 5.5.0 的上游 x86_64 静态二进制。 [源码](https://github.com/proot-me/proot/tree/v5.5.0) · [源码归档副本](licenses/proot-5.5.0-src.tar.gz) · [上游构建流程](https://github.com/proot-me/proot/blob/v5.5.0/.github/workflows/release.yml)
- java-analyzer 0.3.5。 [源码](https://github.com/l0ng-ai/java-analyzer/tree/v0.3.5) · [发布页](https://github.com/l0ng-ai/java-analyzer/releases/tag/v0.3.5)
- Eclipse JDT LS 1.63.0。 [源码](https://github.com/eclipse-jdtls/eclipse.jdt.ls/tree/v1.63.0) · [发布归档](https://download.eclipse.org/jdtls/milestones/1.63.0/)
- kmp-lsp 0.27.0，附 kmp-jar-indexer。 [源码](https://github.com/Hessesian/kmp-lsp/tree/v0.27.0) · [发布页](https://github.com/Hessesian/kmp-lsp/releases/tag/v0.27.0)
- Eclipse Temurin JDK 25.0.5.1+2。 [OpenJDK 源码](https://github.com/openjdk/jdk25u/tree/jdk-25.0.5.1%2B2) · [Temurin 发布页](https://github.com/adoptium/temurin25-binaries/releases/tag/jdk-25.0.5.1%2B2)
- Apache Maven 3.9.16。 [源码归档](https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.16/apache-maven-3.9.16-src.tar.gz)
- Microsoft Java Debug 插件 JAR 来自 Open VSX 的 vscode-java-debug 0.60.0 扩展。 [扩展源码](https://github.com/microsoft/vscode-java-debug/tree/0.60.0) · [调试器源码](https://github.com/microsoft/java-debug) · [Open VSX](https://open-vsx.org/extension/vscjava/vscode-java-debug)
- Checkstyle 命令行 14.4.0。 [源码](https://github.com/checkstyle/checkstyle/tree/checkstyle-14.4.0) · [发布页](https://github.com/checkstyle/checkstyle/releases/tag/checkstyle-14.4.0)

[随包启动与自检脚本](packaging) · [许可证与声明](licenses)
