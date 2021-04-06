### Demo包含
##### 项目结构
   build_flutter_android Android 主工程
      --flutter_module Android Library 包含flutter运行环境和dart代码
   build_flutter_module Flutter Module 工程
   app 依赖 flutter_module
    
##### 要解决的问题and方案

###### 问题
* 主工程用AAR的方式嵌入Flutter，以解决组件化拆分，主工程只需简单的引入一个module，module打包并上传至maven，可实现AAR引入。
* 组内不做Flutter开发的人员无需Flutter环境，同时可以解决开发人员环境不一致问题
* 打包接入CI/CD，简化流程
* 开发和打包时最好无需改动Flutter工程
* 参考了一些例子，使用fat-aar的方式，将flutter工程中android项目从application改为library，需要改动第三个地方。每次切换的时候改动太大。


###### 方案
* 将Flutter运行环境（flutter.jar flutter.so）依赖进flutter_module中
* app 依赖 flutter_module
* 主工程提供一个切换模式的变量，标记 开发/打包
* * *
### 实验
##### 1. 跳转到Flutter module下
```
 cd build_flutter_module
```
##### 2. 下载一些依赖，生成.android文件，会在 .gradle/caches/modules-2/files-2.1/io.flutter下生成所有版本的flutter.jar和flutter.so, 生成 .flutter-plugins 文件标示所有三方插件的本地依赖地址，其中 some_plugin_path/android 即为插件原生代码
```
flutter pub get
```
##### 3. 打包 --no-release --no-debug 等模式 --build-number指定版本号
```
flutter build aar --no-profile --build-number=1.0.0

```
##### 4. gradle.properties 文件中配置 IS_SOURCE=false 代表为资源依赖，而不是源代码依赖
```
cd ..
cd build_flutter_android
./gradlew build 或者 sync 一下
直接运行 or
./gradlew assembleRelease打包
```
![c7ff56beae0e62dce355bd6f8aee2294.png](evernotecid://F49851C3-93D9-4371-8A45-19BC07DE408C/appyinxiangcom/23203925/ENResource/p10)

##### 日常开发
```
修改gradle.properties IS_SOURCE=true
./gradlew build 或者 sync 一下
debug模式运行
```
**build_flutter_module flutter 项目完全没有改动，完美**
* * *

### 说明

##### flutter_module添加了一个 engine.version 的文件，远程下载依赖，不需要导入flutter.jar 和 flutter.so 源文件
>     可以再添加一个 aar-version ，标记当前flutter工程的build版本


##### 当打包时资源引入方式：
1. flutter 工程 build aar --no-debug --no-profile --build-number=xxx
2. IS_SOURCE=false
3. ./gradlew build
4. ./gradlew assembleRelease

##### 当打包时源码引入方式：
1. IS_SOURCE=true
2. ./gradlew build
3. ./gradlew assembleRelease

##### 主工程的maven配置需添加
```
//一些三方的plugin原生代码在这里
maven {
      url "https://storage.flutter-io.cn/download.flutter.io"
    }
    //dart代码打包产物，和自定义的 flutter plugin 原生代码
    maven {
      url '../add_to_app_demo/build_flutter_module/build/host/outputs/repo'
    }
```

##### Flutter engine.version 位置

```
flutterSDKPath/bin/internal/engine.version
//获取版本号
```

##### 最关键的Flutter资源依赖
```
String engineVersion = "1.0.0-"
File engineVersionFile = file("engine.version")
engineVersionFile.eachLine { line ->
  engineVersion += line
}
dependencies {
//flutter so
  debugApi "io.flutter:armeabi_v7a_debug:$engineVersion"
  debugApi "io.flutter:arm64_v8a_debug:$engineVersion"
  releaseApi "io.flutter:armeabi_v7a_release:$engineVersion"
  releaseApi "io.flutter:arm64_v8a_release:$engineVersion"

  //flutter embed
  releaseApi "io.flutter:flutter_embedding_release:$engineVersion"
  debugApi "io.flutter:flutter_embedding_debug:$engineVersion"

  //other native module
  debugImplementation 'com.sia.build_flutter_module:flutter_debug:1.0.0'
  releaseImplementation 'com.sia.build_flutter_module:flutter_release:1.0.0'
  debugImplementation 'io.flutter.plugins.deviceinfo:device_info_debug:1.0.0'
  releaseImplementation 'io.flutter.plugins.deviceinfo:device_info_release:1.0.0'
}
```

##### TODO:
当flutter-plugin不是以 io.flutter.plugin.xxx 包名开头时，源码依赖方式下，插件的原生代码库需要单独进行依赖
自定义一个Flutter plugin 拿进来测试一下