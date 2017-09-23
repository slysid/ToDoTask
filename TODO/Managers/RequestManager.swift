//
//  RequestManager.swift
//  icrush
//
//  Created by Bharath on 2017-09-23.
//  Copyright © 2017 Bharath. All rights reserved.
//

import Foundation
import UIKit

@objc protocol RequestManagerProtocol {
    
    @objc optional func responseTrue(response:Dictionary<String, Any>)
    @objc optional func responseTrueFalse(response:Dictionary<String, Any>)
    @objc optional func responseFalse(response:Dictionary<String, Any>)
}

class RequestManager:NSObject {
    
    private var session = URLSession(configuration: URLSessionConfiguration.default)
    let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var requestManagerDelegate:RequestManagerProtocol?
    
    override init() {
        super.init()
        
    }
    
    private func formHTTPRequest(url:String, method:String, body:Data?, headers:Dictionary<String, String>?, addSessionHeader:Bool) -> URLRequest {
        
        var urlRequest = URLRequest(url: URL(string:url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
        
        urlRequest.httpMethod = method
        
        if (addSessionHeader == true) {
            urlRequest.addValue("key", forHTTPHeaderField:"X-SESSION")
        }
        if (headers == nil) {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        else {
            for (key, value) in headers! {
                
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        
        if (body != nil) {
            
            urlRequest.httpBody = body!
        }
        
        return urlRequest
        
    }
    
    private func request(url: String,
                         method: String,
                         addSessionHeader:Bool,
                         body : Dictionary<String, Any>?,
                         completion:@ escaping((_ result:Bool,_ response:Dictionary<String, Any>?)->())) {
        
        var dataBody:Data? = nil
        let headers:Dictionary<String,String>? = nil
        
        if(body != nil) {
            
            dataBody = try? JSONSerialization.data(withJSONObject: body!, options: .prettyPrinted)
        }
        
        let urlRequest = formHTTPRequest(url: url, method: method, body: dataBody, headers:headers, addSessionHeader:addSessionHeader)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            
            guard error == nil else {
                
                completion(false, ["code":400, "description": error!.localizedDescription])
                return
            }
            
            if ((response! as! HTTPURLResponse).statusCode != 200) {
                
                completion(false, ["code":(response! as! HTTPURLResponse).statusCode, "description": "HTTP Error"])
            }
            else {
                
                guard let json = try? JSONSerialization.jsonObject(with: data!) as? [String: Any] else {
                    
                    completion(false, ["code":500, "description": "Parse Error"])
                    return
                }
                
                completion(true, json)
            }
        }
        
        task.resume()
    }
    
    private func startActivityIndicator(vc:UIViewController) {
        
        self.activity.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y:200)
        vc.view.addSubview(activity)
        self.activity.startAnimating()
    }
    
    private func stopActivityIndicator() {
        
        if (self.activity.isAnimating == true) {
            
            self.activity.stopAnimating()
            self.activity.removeFromSuperview()
        }
    }
    
    public func postRequest(apifingerprint:APIFINGERPRINT,
                            vc:UIViewController?,
                            showLoadingIndicator:Bool,
                            endpointvars:[String]?,
                            body:Dictionary<String, Any>?,
                            responseTrue:@escaping((_ result:Dictionary<String, Any>)->()),
                            responseTrueFalse:@escaping((_ result:Dictionary<String, Any>)->()),
                            responseFalse:@escaping((_ result:Dictionary<String, Any>)->())
        
        ) {
        
        if (vc != nil && showLoadingIndicator == true) {
            
            self.startActivityIndicator(vc: vc!)
        }
        
        let api = APIManager().getAPIFingerPrint(api:apifingerprint, endpointvars: endpointvars, postdata: body)
        
        self.request(url: api!.httpURL!,
                     method: api!.method,
                     addSessionHeader: api!.isSecured, body: body) { (result, response) in
                        
                        if (vc != nil) {
                            DispatchQueue.main.async {
                                self.stopActivityIndicator()
                            }
                        }
                        
                        if (result == true) {
                            
                            if (response?["code"] as! Int == 200) {
                                
                                responseTrue(response!)
                            }
                            else {
                                
                                responseTrueFalse(response!)
                            }
                        }
                        else {
                            
                            responseFalse(response!)
                            
                        }
        }
        
    }
}

