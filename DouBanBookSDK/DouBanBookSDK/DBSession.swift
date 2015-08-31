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
    class func setSharedSession(client_id: String, client_secret: String, redirect_uri: String) {
    
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
        parameter["page"] = note.page!
        
        NetworkTool.sharedNetworkTool.upload(.POST, url: url, parameter: parameter, complition: success)
        
        
    }
    
    /// 修改读书笔记
    func changeDoubanNote(note: DBAnnotation, success: successCallBack){
        
        deleteDoubanNote(note, success: { (result, error) -> Void in
            self.creatDoubanNote(note, success: success)
        })
        
    }
    
    func deleteDoubanNote(note: DBAnnotation, success: successCallBack){
        
        let urlPath = "https://api.douban.com/v2/book/annotation/\(note.id!)"
        let url = NSURL(string: urlPath)!
        
        let request = NSMutableURLRequest(URL: url)
        
        NetworkTool.sharedNetworkTool.upload(.DELETE, url: url, parameter: nil, complition: success)
        
    }

    
    func changeAuthenticated() {
        
        isAuthenticated = DouBanAccount.fetchDoubanAccount() != nil
        doubanAccount = DouBanAccount.fetchDoubanAccount()
        
        if isAuthenticated {
            NetworkTool.sharedNetworkTool.configuration.HTTPAdditionalHeaders = ["Authorization": "Bearer \(DBSession.sharedSession.doubanAccount!.access_token!)" ]
        }else {
            
            NetworkTool.sharedNetworkTool.configuration.HTTPAdditionalHeaders = nil
        }
        
    }

}
