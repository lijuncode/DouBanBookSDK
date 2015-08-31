//
//  DouBanAccount.swift
//  DouBanBookSDK
//
//  Created by  李俊 on 15/8/31.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import Foundation

let doubanPath: String = {
    
    let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last as! String
    
    return path.stringByAppendingPathComponent("DoubanAcount.plist")
    
    }()

class DouBanAccount: NSObject, NSCoding {
    
    var access_token: String?
    /// 过期时间
    var expires_in: NSTimeInterval = 0 {
        didSet{
            expireDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    var refresh_token: String?
    
    var douban_user_id: String?
    
    var douban_user_name: String?
    
    // 过期日期
    var expireDate: NSDate?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dictionary)
        
        save()
        
    }
    
//    // 重写这个方法,可以处理模型的属性不能一一对应key的情况
//    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    static var doubanAccount: DouBanAccount?
    
    class func fetchDoubanAccount() -> DouBanAccount? {
        
        if doubanAccount == nil {
        
            let result: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(doubanPath)
        
            if let userAccount = result as? DouBanAccount  {
            
                if userAccount.expireDate!.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                
                    doubanAccount = userAccount
                }
            }
        }
        return doubanAccount
    }
    
    
    
    
    /// 保存账号
    private func save(){
        
        NSKeyedArchiver.archiveRootObject(self, toFile: doubanPath)
        
    }
    
    override  var description: String {
        
        let dict = ["access_token","douban_user_id","douban_user_name", "expires_in", "expireDate"]
        
        return "\(dictionaryWithValuesForKeys(dict))"
    }
    
    
    required init(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        refresh_token = aDecoder.decodeObjectForKey("refresh_token") as? String
        douban_user_id = aDecoder.decodeObjectForKey("douban_user_id") as? String
        douban_user_name = aDecoder.decodeObjectForKey("douban_user_name") as? String
        expireDate = aDecoder.decodeObjectForKey("expireDate") as? NSDate
        expires_in = aDecoder.decodeDoubleForKey("expires_in")

    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(refresh_token, forKey: "refresh_token")
        aCoder.encodeObject(douban_user_name, forKey: "douban_user_name")
        aCoder.encodeObject(douban_user_id, forKey: "douban_user_id")
        aCoder.encodeObject(expireDate, forKey: "expireDate")
        
    }
   
}
