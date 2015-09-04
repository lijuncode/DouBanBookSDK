//
//  DBSession.swift
//  DouBanBookSDK
//
//  Created by  李俊 on 15/8/31.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

class DBSession: NSObject {
    
    /// 单例
    static let sharedSession = DBSession()
    
    /// 是否授权
    var isAuthenticated: Bool = DouBanAccount.fetchDoubanAccount() != nil

    var doubanAccount = DouBanAccount.fetchDoubanAccount()
    
    var client_id: String?
    var client_secret: String?
    var redirect_uri: String?
    
    static var authorization_code_parameter = [String: AnyObject]()
    
    /// 设置参数
    class func setDoubanAPIKey(client_id: String, client_secret: String, redirect_uri: String) {
    
        authorization_code_parameter["client_id"] = client_id
        authorization_code_parameter["client_secret"] = client_secret
        authorization_code_parameter["redirect_uri"] = redirect_uri
        
    }
    
    /// 取消授权、退出登录
    func unauthenticate(complition: (() -> Void)?) {
        
        DouBanAccount.deleteAccount()
       
        changeAuthenticated()
        
        complition?()
        
    }
   
    /// 登录、授权
    func authenticateWithViewController(viewController: UIViewController, success: () -> ()) {
        
        let oauthViewController = OauthLoginViewController(dictionary:DBSession.authorization_code_parameter)
        oauthViewController.complition = success
        
        let navigationController = UINavigationController(rootViewController: oauthViewController)
        
        viewController.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    typealias successCallBack = (result: [String: AnyObject]?, error: NSError?) -> Void

    
    /// 创建读书笔记
    func creatDoubanNote(note: DBAnnotation, success: successCallBack){
        
        let urlPath = "https://api.douban.com/v2/book/\(note.bookId!)/annotations"
        
        let url = NSURL(string: urlPath)!
        
        var parameter = [String : AnyObject]()
        
        parameter["content"] = note.content!
        
        if note.page != nil {
            parameter["page"] = note.page!
        }
        
        if note.chapter != nil {
            
            parameter["chapter"] = note.chapter!
        }
        
        NetworkTool.sharedNetworkTool.request(.POST, url: url, parameter: parameter, successStatus: 201, success: success, fail: nil)
        
    }
    
    /// 修改读书笔记
    func changeDoubanNote(note: DBAnnotation, success: successCallBack){
        
        deleteDoubanNote(note, success: { (result, error) -> Void in
            
        })
        
        creatDoubanNote(note, success: success)
        
    }
    
    /// 删除笔记
    func deleteDoubanNote(note: DBAnnotation, success: successCallBack){
        
        let urlPath = "https://api.douban.com/v2/book/annotation/\(note.id!)"
        let url = NSURL(string: urlPath)!
        
        NetworkTool.sharedNetworkTool.request(.DELETE, url: url, parameter: nil, successStatus: 204, success: success, fail: nil)
        
    }
    
    /// 获取谋篇笔记的信息
    func fetchDoubanNote(noteId: String, success: successCallBack) {
        
        let urlPath = "https://api.douban.com/v2/book/annotation/\(noteId)"
        let url = NSURL(string: urlPath)!
        
        NetworkTool.sharedNetworkTool.request(.GET, url: url, parameter: nil, successStatus: 200, success: success, fail: nil)
        
        
    }

    /// 修改登录状态
    func changeAuthenticated() {
        
        isAuthenticated = DouBanAccount.fetchDoubanAccount() != nil
        doubanAccount = DouBanAccount.fetchDoubanAccount()
        
        if isAuthenticated {
            NetworkTool.sharedNetworkTool.configuration.HTTPAdditionalHeaders = ["Authorization": "Bearer \(DBSession.sharedSession.doubanAccount!.access_token!)" ]
        }else {
            
            NetworkTool.sharedNetworkTool.configuration.HTTPAdditionalHeaders = nil
        }
        
    }
    
    /// 收藏图书（在读状态）
    func collectionBook(bookId: String, success: successCallBack){
        
        let urlPath = "https://api.douban.com/v2/book/\(bookId)/collection"
        let url = NSURL(string: urlPath)!
        
        var parameter = [String : AnyObject]()
        // 在读状态
        parameter["status"] = "reading"
        
        NetworkTool.sharedNetworkTool.request(.POST, url: url, parameter: parameter, successStatus: 201, success: success, fail: nil)
        
    }
    
    /// 根据ISBN搜索图书
    func searchBookByISBN(isbn: String, success: successCallBack, fail: successCallBack) {
        
        client_secret = DBSession.authorization_code_parameter["client_secret"] as? String
        
        let urlPath = "https://api.douban.com/v2/book/isbn/\(isbn)?apikey=\(client_secret!)"
        
        let url = NSURL(string: urlPath)!
        
        NetworkTool.sharedNetworkTool.request(.GET, url: url, parameter: nil, successStatus: 200, success: success, fail: fail)
    }

}
