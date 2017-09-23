//
//  APIManager.swift
//  icrush
//
//  Created by Bharath on 2017-09-23.
//  Copyright © 2017 Bharath. All rights reserved.
//

import Foundation

class APIManager:NSObject {
    
    override init() {
        
        super.init()
    }
    
    public struct apis {
        
        private let hostName = APIHOST
        private let httpProtocol = APIPROTOCOL
        private let port = APIPORT
        
        let method:String
        var endpoint:String
        var data:Dictionary<String, Any>?
        var httpURL:String?
        var isSecured:Bool = true
        
        init(method:String, endpoint:String, data:Dictionary<String, Any>?, secured:Bool) {
            
            self.method = method
            self.endpoint = endpoint
            self.data = data
            self.isSecured = secured
            self.httpURL = "\(httpProtocol)://\(hostName):\(port)/api\(self.endpoint)"
        }
    }
    
    public func getAPIFingerPrint(api:APIFINGERPRINT, endpointvars:[String]?, postdata:Dictionary<String, Any>?) -> apis? {
        
        let fingerPrintData = api.get()
        let method = fingerPrintData["method"]
        let path = fingerPrintData["path"]! as! NSString
        let secured = fingerPrintData["secured"]! as! Bool
        let replacedPath = NSMutableString.init(string: path)
        let paramCount = path.components(separatedBy: "*").count - 1
        
        if (paramCount > 0 && paramCount != endpointvars?.count) {
           
            return nil
        }
        else if (paramCount > 0) {
            
            for pathvar in endpointvars! {
                
                replacedPath.replaceCharacters(in: replacedPath.range(of: "*"), with: pathvar)
            }
        }
        
        return apis(method: method! as! String, endpoint:replacedPath as String, data: postdata, secured:secured)
    }
    
}

