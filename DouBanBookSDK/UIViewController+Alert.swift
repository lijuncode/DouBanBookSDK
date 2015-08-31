//
//  UIViewController+Alert.swift
//  ReadMark
//
//  Created by  李俊 on 15/8/26.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    /// 显示弹框消息
    func presentAlert(title: String?, message: String?, handle: ((UIAlertAction!) -> Void)? ){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: handle))
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
}
