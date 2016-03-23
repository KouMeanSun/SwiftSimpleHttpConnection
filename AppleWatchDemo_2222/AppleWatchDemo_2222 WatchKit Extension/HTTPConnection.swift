//
//  HTTPConnection.swift
//  HTTPConnection__222
//
//  Created by gaomingyang1987 on 16/3/17.
//  Copyright © 2016年 gaomingyang1987. All rights reserved.
//

import UIKit

//声明一个闭包

typealias RequestCallBack = (NSData? ,NSError?) -> Void

//声明一个协议
protocol HTTPConnectionDelegate:NSObjectProtocol {
//连接成功调用的方法
    func finishConnection(data:NSData)
//连接失败调用的方法
    func failedConnection(error:NSError)
}

class HTTPConnection: NSObject {

    //声明一个用于回传数据的block
    var  block:RequestCallBack!
    //声明一个用于回传数据的代理属性
    var  delegate:HTTPConnectionDelegate!
    
  
//暴露一个方法给外界调用,有class 修饰的方法就是类方法
/**
参数1 请求url
参数2 http请求参数
参数3 闭包回调
*/
class  func getRequestWithUrlStr(urlStr:String,param:NSDictionary?,block:RequestCallBack){
    
    HTTPConnection().getRequest(urlStr, param: param, block: block)
//    let connection = HTTPConnection()
//    connection.getRequest(urlStr, param: param, block: block)
    
    }
/**
代理回传值
参数1 请求url
参数2 http请求参数
参数3 回调的delegate
**/
class func postRequestWithUrlStr(urlStr:String,param:NSDictionary?,delegate:HTTPConnectionDelegate){
    HTTPConnection().postRequest(urlStr, param: param, delegate: delegate)
    }
//===================以下是对象方法
    
    func  postRequest(urlStr:String,param:NSDictionary?,delegate:HTTPConnectionDelegate){
    self.delegate  = delegate
        let url:NSURL = NSURL(string: urlStr)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        //修改请求方式为POST
        request.HTTPMethod = "POST"
        
    let list:NSMutableArray = NSMutableArray()
        if param != nil {
            let keyList = param!.allKeys
            let valueList = param!.allValues
            for var i = 0 ; i<keyList.count; i++ {
                let tmp:String = "\(keyList[i])=\(valueList[i])"
                list.addObject(tmp)
            }
            let paramStr:String = list.componentsJoinedByString("&")

            let paramData:NSData = paramStr.dataUsingEncoding(NSUTF8StringEncoding)!
        
       //把nsdata类型的参数放到http请求体里
        request.HTTPBody = paramData
        }
let config = NSURLSessionConfiguration.defaultSessionConfiguration()
let session = NSURLSession(configuration: config)
let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
    if error == nil {//请求成功
        let canDo:Bool = self.delegate.respondsToSelector(Selector.init("finishConnection:"))
        if  canDo {
        self.delegate.finishConnection(data!)
        }
    
    }else {//请求失败
    let canDo:Bool = self.delegate.respondsToSelector(Selector.init("failedConnection:"))
        if canDo  {
        self.delegate.failedConnection(error!)
        }
    }
    
    }
dataTask.resume()
}
    
    
    func getRequest(urlStr:String,param:NSDictionary?,block:RequestCallBack){
        self.block = block
        var myUrlStr = urlStr
        let list:NSMutableArray = NSMutableArray()
        
        if param != nil {
            let keyList = param!.allKeys
            let valueList = param!.allValues
            for var i = 0 ; i<keyList.count; i++ {
            let tmp:String = "\(keyList[i])=\(valueList[i])"
            list.addObject(tmp)
            }
            let paramStr:String = list.componentsJoinedByString("&")
//        myUrlStr = myUrlStr.stringByAppendingFormat("?%@", paramStr)
        myUrlStr = myUrlStr.stringByAppendingString("?\(paramStr)")
        }
        print("HTTPConnection-url:\(myUrlStr)")
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: config)
    let url:NSURL = NSURL(string: myUrlStr)!
        
    let request:NSURLRequest = NSURLRequest(URL: url)
    let dataTask:NSURLSessionDataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
        
        if self.block != nil {
        self.block(data,error)
        }
    }
    dataTask.resume()
  
    
}

}
