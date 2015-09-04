# DouBanBookSDK

简单封装的豆瓣SDK，实现登录授权、注销登录，以及部分图书API

## 使用：

所有方法都已经封装在DBSession类里，直接使用单例调用方法即可。

**注意** 使用登录授权前，请在`AppDelegate.swfit`文件中的`func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool`方法里的`DBSession.setDoubanAPIKey`方法里填入相关参数

## 方法：
```
/// 取消授权、退出登录
    func unauthenticate(complition: (() -> Void)?)
```
```
/// 登录、授权
    func authenticateWithViewController(viewController: UIViewController, success: () -> ())
```
```
/// 创建读书笔记
    func creatDoubanNote(note: DBAnnotation, success: successCallBack)
```
```
/// 修改某条读书笔记
    func changeDoubanNote(note: DBAnnotation, success: successCallBack)
```
```
/// 删除某条笔记
    func deleteDoubanNote(note: DBAnnotation, success: successCallBack)
```
```
/// 获取谋篇笔记的信息
    func fetchDoubanNote(noteId: String, success: successCallBack)
```
```
/// 收藏图书（在读状态）
    func collectionBook(bookId: String, success: successCallBack)
```
```
/// 根据ISBN搜索图书
    func searchBookByISBN(isbn: String, success: successCallBack, fail: successCallBack)
```
