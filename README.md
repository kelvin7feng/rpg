#IOS build(Mac OS):安装unity ios support
1.切换IOS
2.build,生成路径为：Builds下面ios
3.执行ios_copy.sh

#Android build: 安装unity android support
工具下载地址：https://www.androiddevtools.cn/
1.下载安装jdk1.8.0
2.下载Android Studio
3.打开Android Studio下载对应版本的SDK(platform 28.0.3)
4.下载配置Gradle(2019.1.8f1版本使用的是5.4.1
5.打开Unity->Edit->Preferences->External Tools
	1.设置JDK路径
	2.设置Android SDK路径
	3.设置Gradle路径
6.build asset bundle
7.执行copy_android.bat
8.build