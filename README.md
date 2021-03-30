# add_to_app_demo

##### 跳转到Flutter module下
 `cd build_flutter_module`
##### 下载一些依赖，生成.android文件，会在 .gradle/caches/modules-2/files-2.1/io.flutter下生成所有版本的flutter.jar和flutter.so, 生成 .flutter-plugins 文件标示所有三方插件的本地依赖地址，其中 some_plugin_path/android 即为插件原生代码
`flutter pub get`

##### 打包 --no-release --no-debug 等模式 --build-number指定版本号
`flutter build aar --no-profile --build-number=1.0.0`

`cd ..`
##### gradle.properties 文件中配置 IS_SOURCE=false 代表为资源依赖，而不是源代码依赖
`./gradlew build 或者 sync 一下`

* debug模式运行
* ./gradlew assembleRelease打包


##### 日常开发 修改IS_SOURCE=true，
`./gradlew build 或者 sync 一下
debug模式运行`


##### flutter_module添加了一个 engine.version 的文件，远程下载依赖，不需要导入flutter.jar 和 flutter.so 源文件
>     可以再添加一个 aar-version ，标记当前flutter工程的build版本

**build_flutter_module flutter 项目完全没有改动，完美**

##### 当打包时资源引入方式：
1. flutter 工程 build aar --no-debug --no-profile --build-number=xxx
2. IS_SOURCE=false
3. ./gradlew build
4. ./gradlew assembleRelease

##### 当打包时源码引入方式：
1. IS_SOURCE=true
2. ./gradlew build
3. ./gradlew assembleRelease


##### TODO:
当flutter-plugin不是以 io.flutter.plugin.xxx 包名开头时，源码依赖方式下，插件的原生代码库需要单独进行依赖
将 mj-embed项目拿进来测试一下