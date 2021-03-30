# add_to_app_demo

#跳转到Flutter module下
cd build_flutter_module

#下载一些依赖，生成.android文件，会在 .gradle/caches/modules-2/files-2.1/io.flutter下生成所有版本的flutter.jar
#和flutter.so, 生成 .flutter-plugins 文件标示所有三方插件的本地依赖地址，其中 some_plugin_path/android 即为插件原生代码
flutter pub get

#打包 --no-release --no-debug 等模式 --build-number指定版本号
flutter build aar --no-profile --build-number=1.0.0

cd ..
#gradle.properties 文件中配置 IS_SOURCE=false 代表为资源依赖，而不是源代码依赖
./gradlew build 或者 sync 一下
1.debug模式运行
2. ./gradlew assembleRelease打包


#日常开发 修改IS_SOURCE=true，
./gradlew build 或者 sync 一下
debug模式运行


flutter_module添加了一个 engine.version 的文件，远程下载依赖，不需要导入flutter.jar 和 flutter.so