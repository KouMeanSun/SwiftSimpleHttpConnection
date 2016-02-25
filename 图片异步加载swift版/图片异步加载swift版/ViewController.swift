//
//  ViewController.swift
//  图片异步加载swift版
//
//  Created by gaomingyang1987 on 16/1/28.
//  Copyright © 2016年 gaomingyang1987. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.getNetDatas()
        
    }

    func initUI(){
    let imageIV = UIImageView(frame: CGRectMake(100, 100, 200, 200))
    //imageIV.image = UIImage(imageLiteral: "boy")
        imageIV.tag = 8888
    self.view.addSubview(imageIV)
        
        let button:UIButton = UIButton(type: UIButtonType.Custom)
        button.frame = CGRect.init(x: 100, y: 350, width: 100, height: 50)
        button.setTitle("确定", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.lightGrayColor()
        button.addTarget(self, action: Selector.init("click"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    //======
        let button2:UIButton = UIButton(type: UIButtonType.Custom)
        button2.frame = CGRect.init(x: 100, y: 450, width: 100, height: 50)
        button2.setTitle("清除", forState: UIControlState.Normal)
        button2.backgroundColor = UIColor.lightGrayColor()
        button2.addTarget(self, action: Selector.init("clear"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button2)
    }
    
    func clear(){
    WebCache.clearCache()
    print("清除了图片缓存！")
    }
    
    func click(){
//        let num:UInt64 =  WebCache.getDownLoadFileSize()
        print("文件大小num:\( WebCache.getDownLoadFileSize())")
    }
    
    func getNetDatas(){
        
        //=====get 请求
    HTTPConnection .getRequest("http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite", param: nil) { (data, error) -> Void in
        if (error != nil ){
        print("error:\(error )")
        }else{
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            let songArr:Array<NSDictionary> = jsonData["song"] as! Array<NSDictionary>
            
            let songModel:NSDictionary = songArr[0]
            
            let picture:String = songModel.objectForKey("picture") as! String
            let imageIV:UIImageView = self.view.viewWithTag(8888) as! UIImageView
         
        
            WebCache.setImageViewImageCache(imageIV, urlStr: picture, placeHolder:  "boy")
        
        }
        }
        //post 请求
//        let param:NSDictionary = ["type":"n","channel":"0","from":"mainsite"]
//        
//    HTTPConnection.postRequest("http://douban.fm/j/mine/playlist", param: param) { (data, error) -> Void in
//                if (error != nil ){
//                print("error:\(error )")
//                }else{
//                let jsonData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//        
//                    let songArr:Array<NSDictionary> = jsonData["song"] as! Array<NSDictionary>
//        
//                    let songModel:NSDictionary = songArr[0]
//        
//                    let picture:String = songModel.objectForKey("picture") as! String
//                    let imageIV:UIImageView = self.view.viewWithTag(8888) as! UIImageView
//        
//        
//                    WebCache.setImageViewImageCache(imageIV, urlStr: picture, placeHolder:  "boy")
//                
//                }
//
//        }
    }

}

