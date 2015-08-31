//
//  DouBanAccount.swift
//  DouBanBookSDK
//
//  Created by  李俊 on 15/8/31.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

class DouBanAccount: NSObject {
    
    var access_token: String?
    /// 过期时间
    var expires_in: NSTimeInterval = 0
    
    var refesh_token: String?
    
    var douban_user_id: String?
    
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dictionary)
        
    }
    
//    // 重写这个方法,可以处理模型的属性不能一一对应key的情况
//    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
   
}
