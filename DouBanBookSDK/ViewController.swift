//
//  ViewController.swift
//  DouBanBookSDK
//
//  Created by  李俊 on 15/8/31.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var note: DBAnnotation?
   
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        switch indexPath.row {
            
        case 0:
            creatDoubanNote()
            
        case 1:
            updateDoubanNote()
            
        case 2:
            deleteDoubanNote()
        default:
            break
            
        }
        
    }
    
    func creatDoubanNote(){
        
        let note = DBAnnotation(content: "这是一条测试笔记，凑满15个字完工", page: "1", chapter: nil)
        
        self.note = note
        
        DBSession.sharedSession.creatDoubanNote(note)
        
        println("创建")
    }
    
    func updateDoubanNote(){
       
        println("更新")
    }
    
    func deleteDoubanNote(){
        
        println("删除")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

