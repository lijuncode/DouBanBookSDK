# DouBanBookSDK

简单封装的豆瓣SDK，实现登录授权、注销登录，以及部分图书API

## 使用：

所有方法都已经封装在DBSession类里，直接使用单例调用方法即可。

**注意** 使用登录授权前，请在`AppDelegate.swfit`文件中的`func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool`方法里的`DBSession.setDoubanAPIKey`方法里填入相关参数
