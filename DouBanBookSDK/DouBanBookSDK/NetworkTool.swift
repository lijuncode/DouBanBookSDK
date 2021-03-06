//
//  NetworkTool.swift
//  DouBanBookSDK
//
//  Created by  李俊 on 15/8/31.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

class NetworkTool: NSObject {
    
    /// 单例
    static let sharedNetworkTool = NetworkTool()
    
    enum HTTPMethod: String {
        
        case POST = "POST"
        case GET = "GET"
        case PUT = "PUT"
        case DELETE = "DELETE"
        
    }
    
    var session: NSURLSession!
    
    var configuration: NSURLSessionConfiguration!
    
    var parameter: [String : AnyObject]?
    
    typealias finishCallBack = (result: [String: AnyObject]?, error: NSError?) -> Void
    
    override init() {
        super.init()
        
        configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        if DBSession.sharedSession.isAuthenticated{
            configuration.HTTPAdditionalHeaders = ["Authorization": "Bearer \(DBSession.sharedSession.doubanAccount!.access_token!)" ]
        }
        session = NSURLSession(configuration: configuration)
        
    }
    
    
    func upload(method: HTTPMethod, url: NSURL, parameter: [String : AnyObject]?, complition: finishCallBack) {
        
        let request = NSMutableURLRequest(URL: url)
        var data: NSData?
        if parameter != nil {
            let parameterString = buildParams(parameter!)
        
            data = parameterString.dataUsingEncoding(NSUTF8StringEncoding)!
    
        }
        
        request.HTTPMethod = method.rawValue
        
        switch method {
            
        case .POST:
            uploadTaskWithRequest(request, fromData: data, success: complition)
        case .DELETE:
            dataTaskWithRequest(request, success: complition)
            
        default:
            break
            
        }
        
    }
    
    // success的判定太死了，目前只适用于删除笔记，必须得再改进
    private func dataTaskWithRequest(request: NSURLRequest, success: finishCallBack) {
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let httpResp = response as? NSHTTPURLResponse
            
            if httpResp?.statusCode == 204 {
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    success(result: nil, error: nil)
                })
                
            }
            
        })
        
        task.resume()
        
        
    }
    
    private func uploadTaskWithRequest(request: NSURLRequest, fromData: NSData?, success: finishCallBack) {
        
       let task = session.uploadTaskWithRequest(request, fromData: fromData) { (data, response, error) -> Void in
            
            if data != nil && error == nil {
                
                let result = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))) as! [String : AnyObject]
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    success(result: result, error: nil)
                })
                
            }
        }
        
        task.resume()
        
    }
    
    // 从 Alamofire 偷了三个函数，目前只用了第一个
    private func buildParams(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sort(<) {
            let value: AnyObject! = parameters[key]
            components += self.queryComponents(key, value)
        }
        
        return (components.map{"\($0)=\($1)"} as [String]).joinWithSeparator("&")
    }
    private func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.appendContentsOf([(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    private func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
   
}
