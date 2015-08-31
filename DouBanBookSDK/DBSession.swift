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
    var isAuthenticated: Bool = {

        return DouBanAccount.fetchDoubanAccount() != nil
    }()
    
    var doubanAccount: DouBanAccount? = {
        
        return DouBanAccount.fetchDoubanAccount()
    }()
    
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
    func unauthenticate() {
        
        
    }
   
    /// 登录、授权
    func authenticateWithViewController(viewController: UIViewController, success: () -> ()) {
        
        let oauthViewController = OauthLoginViewController(dictionary:DBSession.authorization_code_parameter)
        oauthViewController.complition = success
        
        let navigationController = UINavigationController(rootViewController: oauthViewController)
        
        viewController.presentViewController(navigationController, animated: true, completion: nil)
        
    }
}
