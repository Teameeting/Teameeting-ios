#Teameeting iOS 客户端<br>
##编译环境<br>
Xcode 6＋<br>

##运行项目<br>
安装CocoaPods (关于CocoaPods的安装和使用，可参考[这个教程](http://code4app.com/article/cocoapods-install-usage))<br>
在终端下打开项目所在的目录，执行pod install (若是首次使用CocoaPods，需先执行pod setup)<br>
pod install命令执行成功后，通过新生成的xcworkspace文件打开工程运行项目<br>
##目录简介<br>
AppDelegate： 存放AppDelegate和API定义<br>
Model： 数据实体类<br>
Resources： 存放除图片以外的资源文件，如html、css文件（图片资源存放在images.xcassets中)<br>
Three： 存放非CocoaPods管理的第三方库<br>
ViewCons： 存放所有的view controller<br>
Views： 存放一些定制的视图<br>
Tool： 存放工具类以及一些类扩展<br>

##项目用到的开源类库、组件<br>
AFNetworking： 网络请求<br>
DxPopover： 弹出视图<br>
DZNEmpytDataSet： 空列表的提醒<br>
MBProgressHUD： 显示提示或加载进度<br>
MJRefresh： 刷新控件<br>
mp3lame-for-ios： 录音<br>
SSKeychain： 账号密码的存取<br>
TTTAttributedLabel： 支持富文本显示的label<br>

##开源协议<br>
Teameeting iOS app is under the Apache license. See the LICENSE file for more details.
