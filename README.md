[如果你觉得能帮助到你，请给一颗小星星。谢谢！(If you think it can help you, please give it a star. Thanks!)](https://github.com/dgynfi/ios-sdk-dev-demo)

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;

# ios-sdk-dev-demo

一个简单封装的iOS SDK，编写于2015年3月23日。ExamSdk为SDK源码，ExamSdkDemo为集成SDK的demo，代码有点旧，勿喷！当需要制作自己的SDK时，可以参考本项目或者下面的[制作方法](#制作方法)。

## 技术交流群(群号:155353383)

欢迎加入技术交流群 ，一起探讨技术问题。<br />
![](https://github.com/dgynfi/ios-sdk-dev-demo/raw/master/images/qq155353383.jpg)

## 预览图

- SDK Library

![](https://github.com/dgynfi/ios-sdk-dev-demo/raw/master/images/SimpleSDK_Lib.png)

- 实现功能

![](https://github.com/dgynfi/ios-sdk-dev-demo/raw/master/images/simple_sdk_preview.gif)

## 制作方法

1. 创建模板

![](https://github.com/dgynfi/ios-sdk-dev-demo/raw/master/images/lib_templete_create.png)

①是创建.framework模板，②是创建.a模板。

2. Project -> Target -> Build Settings 搜索 iOS Deployment Target

选择SDK的最小兼容部署，如iOS 8.0。

3. Project -> Target -> Build Settings 搜索 Valid Architectures

目前支持的架构：真机(arm64 armv7s)、模拟器(i386 x86_64)。不用再支持armv7架构，以后也不需要支持armv7s架构。

4. Project -> Target -> Build Settings 搜索 Mach-O Type

Mach-O Type选项有Dynamic Library, Static Library, Bundle, Executable等，选择Dynamic Library制作动态库，Static Library制作静态库，Bundle存储资源文件。

补充知识：

- 库是共享程序代码的方式，一般分为静态库和动态库。
    - 静态库：链接时完整地拷贝至可执行文件中，被多次使用就有多份冗余拷贝。
    - 动态库：链接时不复制，程序运行时由系统动态加载到内存，供程序调用，系统只加载一次，多个程序共用，节省内存。
    - iOS里静态库形式：.a和.framework 
    - iOS里动态库形式：.dylib, .tbd和.framework 

- framework为什么既有静态库又有动态库：
    - 系统的.framework是动态库，我们自己建立的.framework一般设置成静态库，也可以设置成动态库。

- .a与.framework有什么区别：
    - .a是一个纯二进制文件，.framework中除了有二进制文件之外还有资源文件。
    - .a文件不能直接使用，至少要有.h文件配合，.framework文件可以直接使用。
    - .a + .h + sourceFile = .framework。
    - 建议用.framework.。

- 为什么要使用静态库：
    - 方便共享代码，便于合理使用。
    - 实现iOS程序的模块化。可以把固定的业务模块化成静态库。
    - 和别人分享你的代码库，但不想让别人看到你代码的实现。
    - 开发第三方SDK的需要。

5. Project -> Target -> Build Settings 搜索 Dead Code Stripping
在Link选项中将Dead Code Stripping改为NO（默认是YES）。确定 Dead Code（代码被定义但从未被调用）被剥离，去掉冗余的代码，即使一点冗余代码，编译后体积也是很可观的。

6. Project -> Target -> Build Settings 搜索 Debug Information Format

在Debug Information Format选项中将DWARF with dSYM File修改成DWARF，不生成dSYM文件。

7. Project -> Target -> Build Phases -> Complie Sources

添加要编译.h .m文件，Xcode自动将.m文件添加到Complie Sources中，同时可以使用-fno-objc-arc, fobjc-arc分别针对特定的.m文件进行MRC，ARC内存管理。

8. Project -> Target -> Build Phases -> Headers

将工程Project要暴露的接口.h头文件拖到Public中。framework支持模块化，SDK命名尽量不要头文件重名，以便集成SDK时模块(@import xxx)不能使用。SDK资源放到一个bundle下，统一进行管理与调用。

9. Project -> Edit Scheme -> Run -> Build Configuration

在Build Configuration选择Release，通过快捷键command+R 或者 command+B 和选择真机或模拟器输出Release版本SDK。然后在Products右击Show in Finder找到SDK。

10. 合并库和查看库信息

- 查看架构：使用 lipo -info 查看可执行文件(.a  .framework的可执行文件)架构。
```
lipo -info ExamSimpleSdk.framework/ExamSimpleSdk

lipo -info xxx.a
```

- 合并架构：使用 lipo -create  模拟器可执行文件绝对路径  真机可执行文件绝对路径  -output 输出目录/可执行文件。
```
lipo -create /Users/xxx/Library/Developer/Xcode/DerivedData/dgfkluumuexoxhcapzidtsmdgqcj/Build/Products/Release-iphonesimulator/ExamSimpleSdk.framework/ExamSimpleSdk /Users/xxx/Library/Developer/Xcode/DerivedData/dgfkluumuexoxhcapzidtsmdgqcj/Build/Products/Release-iphoneos/ExamSimpleSdk.framework/ExamSimpleSdk -output /Users/xxx/Desktop/ExamSimpleSdk 

lipo -create /Users/xxx/Library/Developer/Xcode/DerivedData/dgfkluumuexoxhcapzidtsmdgqcj/Build/Products/Release-iphonesimulator/xxx.a /Users/xxx/Library/Developer/Xcode/DerivedData/dgfkluumuexoxhcapzidtsmdgqcj/Build/Products/Release-iphoneos/xxx.a -output /Users/xxx/Desktop/xxx.a 
```

- 移除架构，如:
```
lipo -remove x86_64 ExamSimpleSdk.framework/ExamSimpleSdk -output ExamSimpleSdk.framework/ExamSimpleSdk
```
