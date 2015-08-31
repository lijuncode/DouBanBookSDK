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
        
        if DBSession.sharedSession.isAuthenticated {
            
            DBSession.sharedSession.unauthenticate({ () -> Void in
                
                self.loginbarbutton.title = "登录豆瓣"
                
            })
        } else {
        // 登录授权
            DBSession.sharedSession.authenticateWithViewController(self, success: { () -> () in
            
                self.loginbarbutton.title = DBSession.sharedSession.doubanAccount?.douban_user_name
            
            })
        }
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
            changeDoubanNote()
            
        case 2:
            deleteDoubanNote()
        default:
            break
            
        }
        
    }
    
    func creatDoubanNote(){
        
        if !DBSession.sharedSession.isAuthenticated {
            
            presentAlert(nil, message: "请先登录豆瓣", handle: nil)
            
            return
            
        }
        
        let note = DBAnnotation(content: "测试删除笔记，凑满15个字完工", page: "1", chapter: nil)
        
        // 《小王子》id
        note.bookId = "1003078"
        
        DBSession.sharedSession.creatDoubanNote(note, success: { (result, error) -> Void in
            
            let id = result!["id"] as! String
            
           note.id = id
            
            self.note = note
            
            self.presentAlert(nil, message: "创建成功", handle: nil)
        })
    }
    
    func changeDoubanNote(){
       
        if note == nil {
            presentAlert(nil, message: "先创建一条笔记", handle: nil)
            
            return
        }
        
        note?.content = "这是一条测试修改笔记，凑满15个字完工"
        
        DBSession.sharedSession.changeDoubanNote(note!, success: { (result, error) -> Void in
            
            let id = result!["id"] as! String
            
            self.note!.id = id
            
            self.presentAlert(nil, message: "修改成功", handle: nil)
        })
        
    }
    
    func deleteDoubanNote(){
        
        if note == nil {
            presentAlert(nil, message: "先创建一条笔记", handle: nil)
            
            return
        }
        
        DBSession.sharedSession.deleteDoubanNote(note!, success: { (result, error) -> Void in
            self.presentAlert(nil, message: "删除成功", handle: nil)
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



