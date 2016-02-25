//
//  WebCache.swift
//  图片异步加载swift版
//  
//  注意！使用该框架，需要创建桥街头文件，然后引入如下头文件
//  #import <CommonCrypto/CommonDigest.h>

//  Created by gaomingyang1987 on 16/1/28.
//  Copyright © 2016年 gaomingyang1987. All rights reserved.
//

import UIKit

class WebCache: NSObject {
    //缓存文件名
    let myCacheDir = "GMYDownLoadCache"
    
    //用来接收传入进来的UIImageView
    var myImageView:UIImageView!
    
/**
暴露给外界调用的图片缓存的类方法
**/
 class  func setImageViewImageCache(imageIV:UIImageView,urlStr:String,placeHolder:String){
    let cache = WebCache()
    cache.setIVCache(imageIV, urlStr: urlStr, placeHolder: placeHolder)
    }
    
    /**
    实现具体功能的对象方法
     **/
    func setIVCache(imageIV:UIImageView,urlStr:String,placeHolder:String){
        self.myImageView = imageIV
        if (!placeHolder.isEmpty){
        imageIV.image = UIImage(imageLiteral: placeHolder)
        }
        if (!urlStr.isEmpty){
        //下载图片
           self.downLoadImageForUrl(urlStr)
        }
    }
    /**
     根据url下载图片
    **/
    func downLoadImageForUrl(url:String){
    //获取图片缓存路径
        let path:String = self.getDownImageCachePath().stringByAppendingString("/\(self.md5String(url))")
        
   //判断文件是否存在，存在直接获取，不存在，异步下载
        if (NSFileManager.defaultManager().fileExistsAtPath(path)){
        self.myImageView.image = UIImage(contentsOfFile: path)
        }else{
        //下载网络图片并且存储到本地
            self.downloadNetImage(url,path: path)
        }
        
    }
    /**
     下载网络图片并且存储到沙盒
     **/
    func downloadNetImage(url:String,path:String){
        let config:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: config)
        
        let request:NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
        let dowloadTask:NSURLSessionDownloadTask = session.downloadTaskWithRequest(request) { (location, response, error) -> Void in
            //输出下载文件原来的存放目录
            //print("location:\(location)")
            
            if (error != nil ){
            print("error:\(error)")
            }else{
           try!  NSFileManager.defaultManager().moveItemAtPath(location!.path!, toPath: path)
            self.myImageView.image = UIImage(contentsOfFile: path)
                
            }
        }
        dowloadTask.resume()
    }

    /**
获取图片缓存路径
    **/
    func getDownImageCachePath()->String{
        var path:String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        //拼接一个下载缓存时的路径
        path = path.stringByAppendingString("/\(myCacheDir)")
        //判断路径是否存在，不存在则创建
        if (!NSFileManager.defaultManager().fileExistsAtPath(path)){
       try!  NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        }
        print("图片缓存路径为:\(path)")
        
        return path
    }

    func md5String(str:String) -> String{
        let cStr = (str as NSString).UTF8String
        let buffer = UnsafeMutablePointer<CUnsignedChar>.alloc(16)
        CC_MD5(cStr,(CC_LONG)(strlen(cStr)), buffer)
        let md5String = NSMutableString()
        for var i = 0; i < 16; ++i{
            md5String.appendFormat("%02x", buffer[i])
        }
        
        free(buffer)
        return md5String as String
    }
//=============读取缓存文件夹大小
    /**
     读取WebCache框架的图片缓存文件夹的大小    
    **/

    class func getDownLoadFileSize() ->String {
    let cache = WebCache()
    let length =  cache.getDownLoadCacheSize()
    let size:Double = Double(length)
        if (size<1024.0){
        return "\(String(format: "%.2f", size))B"
        }else if(size>1024.0 && size<1024.0*1024.0){
            return "\(String(format:"%.2f",size/1024.0))KB"
        }else if(size>1024.0*1024.0 && size<1024.0*1024.0*1024.0){
            let totalSize:String = "\(String(format:"%.2f",size/1024.0/1024.0))MB"
            return totalSize
        }else {
            let totalSize:String = "\(String(format:"%.2f",size/1024.0/1024.0/1024.0))GB"
            return totalSize
        }
    }
    
    
 func getDownLoadCacheSize() -> UInt64{
    var totalSize:UInt64 = 0
    let fileEnumerator = NSFileManager.defaultManager().enumeratorAtPath(self.getDownImageCachePath())
    
    for  fileName in fileEnumerator! {
    let filepath = self.getDownImageCachePath().stringByAppendingString("/\(fileName)")
       //print("filepath:\(filepath)")
    let atts:NSDictionary = try! NSFileManager.defaultManager().attributesOfItemAtPath(filepath)
        
    let length = atts.fileSize()
   // print("length:\(length)")
    totalSize += length
    
    }
    
    return totalSize
    }
//===========清除图片缓存
    
    /**
      清除图片缓存
    **/

    class func clearCache(){
    let cache = WebCache()
    cache.clearDownLoadCache()
    }
    
    
    func clearDownLoadCache(){
    let fileEnumerator = NSFileManager.defaultManager().enumeratorAtPath(self.getDownImageCachePath())
        for  fileName in fileEnumerator! {
            let filepath = self.getDownImageCachePath().stringByAppendingString("/\(fileName)")
            //print("filepath:\(filepath)")
    try!  NSFileManager.defaultManager().removeItemAtPath(filepath)
        }
   
    }
}
