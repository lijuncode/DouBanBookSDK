//
//  DBAnnotation.swift
//  DouBanBookSDK
//
//  Created by  李俊 on 15/8/31.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

class DBAnnotation: NSObject {
    
    var content: String?
    var page: String?
    var chapter: String?
    var id: String?
    var bookId: String?
    
    convenience init(content: String, page: String?, chapter: String?){
        
        self.init()
       
        self.content = content
        self.page = page
        self.chapter = chapter
        
    }
    
    
   
}
