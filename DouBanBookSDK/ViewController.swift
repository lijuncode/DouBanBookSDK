//
//  ViewController.swift
//  DouBanBookSDK
//
//  Created by  李俊 on 15/8/31.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginbarbutton: UIBarButtonItem!
    @IBAction func loginDouBan(sender: AnyObject) {
        
        DBSession.sharedSession.authenticateWithViewController(self, success: { () -> () in
            
            self.loginbarbutton.title = DBSession.sharedSession.doubanAccount?.douban_user_name
            
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginbarbutton.title = DBSession.sharedSession.isAuthenticated ? DBSession.sharedSession.doubanAccount?.douban_user_name : "登录豆瓣"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

