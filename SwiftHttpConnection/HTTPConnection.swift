//
//  HTTPConnection.swift
//  SocialAppTest
//
//  Created by gaomingyang1987 on 16/1/26.
//  Copyright © 2016年 gaomingyang1987. All rights reserved.
//

import UIKit

typealias RequestCallBack=(NSData?,NSError?) ->Void

class HTTPConnection: NSObject {
    var block:RequestCallBack!
    
 class func getRequest(urlStr:String,param:NSDictionary?,block:RequestCallBack){
    let connection = HTTPConnection()
    connection.getRequestConnection(urlStr, param: param, block: block)
    }
    
  class func postRequest(urlStr:String,param:NSDictionary?,block:RequestCallBack){
    let connection = HTTPConnection()
    connection .postRequestConnection(urlStr, param: param, block: block)
    }
//=====================================
    /**
       post 请求方法
    **/
    func postRequestConnection(urlStr:String,param:NSDictionary?,block:RequestCallBack){
        self.block = block
        let list = NSMutableArray()
        print("url:\(urlStr)")
        let url:NSURL! = NSURL(string: urlStr)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        if param != nil {
                    let keyList = param!.allKeys
                    let valueList = param!.allValues
            for (var i=0;i<param!.allKeys.count;i++) {
                let tmp:String = "\(keyList[i])=\(valueList[i])"
                list.addObject(tmp)
                
            }
            let paramStr:String =  list.componentsJoinedByString("&")

            let paramData:NSData = paramStr.dataUsingEncoding(NSUTF8StringEncoding)!
            request.HTTPBody = paramData
     
        }
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request) { ( data,  response,  error) -> Void in
            
            if (self.block != nil){
                self.block(data,error)
            }
        }
        
        task.resume()
    }
    
    
    /**
      get请求方法
    **/

    func getRequestConnection(urlStr:String,param:NSDictionary?,block:RequestCallBack){
        self.block = block
        var myUrlStr:String!
        
        if param != nil {
            let list = NSMutableArray()
            let keyList = param!.allKeys
            let valueList = param!.allValues
            for var i = 0; i<keyList.count ; i++ {
                let tmp:String = "\(keyList[i])=\(valueList[i])"
                list.addObject(tmp)
            }
        let paramStr =  list.componentsJoinedByString("&")
        myUrlStr = urlStr.stringByAppendingFormat("?%@", paramStr)
        }else{
        myUrlStr = urlStr
        }
        print("url:\(myUrlStr)")
       let url:NSURL! = NSURL(string: myUrlStr)
       let request = NSURLRequest(URL: url)
        
       let config = NSURLSessionConfiguration.defaultSessionConfiguration()
       let session = NSURLSession(configuration: config)
       
       let task = session.dataTaskWithRequest(request) { ( data,  response,  error) -> Void in
        
        if (self.block != nil){
        self.block(data,error)
        }
        }
        
        task.resume()
    }
   
}
