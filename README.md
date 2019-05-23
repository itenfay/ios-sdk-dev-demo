# ios-sdk-dev-demo

此项目在2015年3月23日编写，一个简单封装的ios sdk。ExamSdk为sdk源码，ExamSdkDemo为集成sdk后的demo，代码有点旧，勿喷！当制作自己的SDK时，可以参考本项目或者下面的制作方法。

## QQ技术群交流

欢迎加入QQ技术群(155353383) ，一起探讨技术问题。<br>
![QQ技术群：155353383](https://github.com/dgynfi/ios-sdk-dev-demo/raw/master/images/qq155353383.jpg)

## 制作方法

1. 创建模板

![创建模板](https://github.com/dgynfi/ios-sdk-dev-demo/raw/master/images/lib-create.png)

①是创建.framework模板，②是创建.a模板。

2. Project -> Target -> Build Settings 搜索 iOS Deployment Target

选择SDK的最小兼容部署，如iOS 8.0。

3. Project -> Target -> Build Settings 搜索 Valid Architectures

目前支持架构真机(arm64 armv7s)、模拟器(i386 x86_64)就可以，armv7架构不用再支持。

4. Project -> Target -> Build Settings 搜索 Mach-O Type

Mach-O Type选项有Dynamic Library, Static Library, Bundle, Executable等，选择Dynamic Library制作动态库，Static Library制作静态库，Bundled存储资源文件。

补充：
库是共享程序代码的方式，一般分为静态库和动态库。<br>
静态库：链接时完整地拷贝至可执行文件中，被多次使用就有多份冗余拷贝。<br>
动态库：链接时不复制，程序运行时由系统动态加载到内存，供程序调用，系统只加载一次，多个程序共用，节省内存。 <br>
iOS里静态库形式：.a和.framework <br>
iOS里动态库形式：.dylib, .tbd和.framework <br>
framework为什么既是静态库又是动态库：系统的.framework是动态库，我们自己建立的.framework是静态库。<br>
a与.framework有什么区别： <br>
•    .a是一个纯二进制文件，.framework中除了有二进制文件之外还有资源文件。<br>
•    .a文件不能直接使用，至少要有.h文件配合，.framework文件可以直接使用。<br>
•    .a + .h + sourceFile = .framework。<br>
•    建议用.framework. <br>
为什么要使用静态库： <br>
•    方便共享代码，便于合理使用。<br>
•    实现iOS程序的模块化。可以把固定的业务模块化成静态库。<br>
•    和别人分享你的代码库，但不想让别人看到你代码的实现。 <br>
•    开发第三方sdk的需要。 <br>

5. Project -> Target -> Build Settings 搜索 Debug Information Format

在Debug Information Format选项中将DWARF with dSYM File修改成DWARF，不生成dSYM文件。

6. Project -> Target -> Build Phases -> Complie Sources

添加要编译.h .m文件，Xcode自动将.m文件添加到Complie Sources中，同时可以使用-fno-objc-arc, fobjc-arc分别针对r特定的.m文件进行MRC，ARC内存管理。

7. Project -> Target -> Build Phases -> Headers

将工程Project要暴露的接口.h文件拖到Public中。framework支持模块化，SDK命名尽量不要头文件重名，以便集成SDK时模块化不能使用。SDK资源放到一个bundle下，统一进行管理与调用。

8. Project -> Edit Scheme -> Run -> Build Configuration

在Build Configuration选择Release，通过快捷键command+R 或者 command+B 和选择真机或模拟器输出Release版本SDK。然后在Products右击Show in Finder找到SDK。

9. 合并库和查看库信息

查看架构：使用 lipo -info 查看可执行文件(.a .framework的可执行文件)架构。<br>
合并架构：使用 lipo -create 真机可执行文件 模拟器可执行文件 -output 输出目录。<br>
移除架构：使用 lipo -remove x86_64 ExamSimpleSdk.framework/ExamSimpleSdk -o ExamSimpleSdk.framework/ExamSimpleSdk