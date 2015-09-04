//
//  OauthLoginViewController.swift
//  DouBanBookSDK
//
//  Created by  李俊 on 15/8/31.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

class OauthLoginViewController: UIViewController, UIWebViewDelegate {

    private var webView: UIWebView!
    
    var parameter: [String: AnyObject]!
    
    var client_id: String!
    var client_secret: String!
    var redirect_uri: String!
    
    var complition: (() -> ())?
    
    init(dictionary: [String: AnyObject]) {
        
        super.init(nibName: nil, bundle: nil)
        
        parameter = dictionary
        
        setValuesForKeysWithDictionary(dictionary)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        
        setWebView()
        
        loadWeb()
    
    }
    
    /// 设置网页视图
    private func setWebView() {
        
        webView = UIWebView()
        
        webView.delegate = self
        
        view.addSubview(webView)
        
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    
    }
    
    /// 加载授权页面
    private func loadWeb(){
        
        let urlPath = "https://www.douban.com/service/auth2/auth?client_id=\(client_id)&redirect_uri=\(redirect_uri)&response_type=code"
        
        let url = NSURL(string: urlPath)
        
        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
        
    }

    // MARK: - webViewDelegate
    
    /// 拦截网页，获取code
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlPath = request.URL!.absoluteString
        
        
        let range = urlPath!.rangeOfString("code=")
        
        let errorRange = urlPath!.rangeOfString("error=")
        
        if let codeRange = range {
            
            
            let codeString = urlPath!.substringFromIndex(codeRange.endIndex)
            
                
            loadAccessToken(codeString)
            
            return false
        }

        if errorRange != nil {
            
            close()
            
            return false
        }
        
        return true
    }
    
    /// 获取token
    private func loadAccessToken(code: String) {
        
        let urlPath = "https://www.douban.com/service/auth2/token"
        
        let url = NSURL(string: urlPath)!
        
        var parameters = parameter
        parameters["grant_type"] = "authorization_code"
        parameters["code"] = code
        
        NetworkTool.sharedNetworkTool.request(.POST, url: url, parameter: parameters, successStatus: 200, success: { (result, error) -> Void in
            
            DouBanAccount.doubanAccount = DouBanAccount(dictionary: result!)
            
            DBSession.sharedSession.changeAuthenticated()
            
            self.complition?()
            
            self.close()
            
        }, fail: nil)
        
    }
    
    
    func close(){
        
        webView.endEditing(true)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
