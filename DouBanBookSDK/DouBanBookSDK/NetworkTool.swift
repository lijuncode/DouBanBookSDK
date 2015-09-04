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
    
    
    func request(method: HTTPMethod, url: NSURL, parameter: [String : AnyObject]?, successStatus: Int, success: finishCallBack?, fail: finishCallBack?) {
        
        let request = NSMutableURLRequest(URL: url)
        var data: NSData?
        if parameter != nil {
            let parameterString = buildParams(parameter!)
        
            data = parameterString.dataUsingEncoding(NSUTF8StringEncoding)!
    
        }
        
        request.HTTPMethod = method.rawValue
        
        switch method {
        case .GET:
            dataTaskWithRequest(request, successStatus: successStatus, success: success, fail: fail)
            
        case .POST:
            uploadTaskWithRequest(request, fromData: data, successStatus: successStatus, success: success, fail: fail)
        case .DELETE:
            dataTaskWithRequest(request, successStatus: successStatus, success: success, fail: fail)
            
        default:
            break
            
        }
        
    }
    
    
    private func dataTaskWithRequest(request: NSURLRequest,successStatus: Int, success: finishCallBack?, fail: finishCallBack?) {
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0), error: nil) as? [String : AnyObject]
            
            let httpResp = response as? NSHTTPURLResponse
            
            if httpResp?.statusCode == successStatus {
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    success?(result: result, error: nil)
                })
                
            }else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    fail?(result: result, error: error)
                })
            }
            
        })
        
        task.resume()
        
        
    }
    
    private func uploadTaskWithRequest(request: NSURLRequest, fromData: NSData?, successStatus: Int, success: finishCallBack?, fail: finishCallBack?) {
        
       let task = session.uploadTaskWithRequest(request, fromData: fromData) { (data, response, error) -> Void in
        
            let httpResp = response as? NSHTTPURLResponse
        
            let result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0), error: nil) as? [String : AnyObject]
        
            if httpResp?.statusCode == successStatus {
            
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    success?(result: result, error: nil)
                })
            
            }else {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    fail?(result: result, error: error)
                })
        }
        
        }
        
        task.resume()
        
    }
    
    // 从 Alamofire 偷了三个函数，目前只用了第一个
    private func buildParams(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in sorted(Array(parameters.keys), <) {
            let value: AnyObject! = parameters[key]
            components += self.queryComponents(key, value)
        }
        
        return join("&", components.map{"\($0)=\($1)"} as [String])
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
            components.extend([(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    private func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
   
}
