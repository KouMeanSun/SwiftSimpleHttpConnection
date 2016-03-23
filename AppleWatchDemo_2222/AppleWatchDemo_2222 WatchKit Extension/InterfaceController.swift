//
//  InterfaceController.swift
//  AppleWatchDemo_2222 WatchKit Extension
//
//  Created by gaomingyang1987 on 16/3/22.
//  Copyright © 2016年 gaomingyang1987. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var bgGroup: WKInterfaceGroup!
    
    @IBOutlet var temperLbl: WKInterfaceLabel!
    
    
    let ak = "59daba8e508bb690ad65b053d917fe56"
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
       print("进入第一个界面!!!!!")
//        self.getNetDatas()
        // Configure interface objects here.
    }

    func getNetDatas(){
    let testUrl:String = "http://api.map.baidu.com/telematics/v3/weather?location=\(cityName)&output=json&ak=\(ak)"
        
    HTTPConnection.getRequestWithUrlStr(testUrl, param: nil) { (data, error) -> Void in
        
        if error != nil {
        print("error:\(error)")
        }else{
//            let str:String = String(data: data!, encoding: NSUTF8StringEncoding)!
//        
//    print("str:\(str)")
            let jsonData:NSDictionary =  try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
      
            let resultsArr:Array<NSDictionary> = jsonData["results"] as! Array
            
            let result = resultsArr[0]
            
            let currentCity:String = result["currentCity"] as! String
            
            let weather_dataArr:Array<NSDictionary> = result["weather_data"] as! Array
            
           let weatherDic = weather_dataArr[0]
            
            let date:String = weatherDic["date"] as! String
            
            let weather:String = weatherDic["weather"] as! String
            
            let wind:String  = weatherDic["wind"] as! String
            let temperature:String = weatherDic["temperature"] as! String
            
         self.bgGroup.setBackgroundImage(UIImage(imageLiteral: "中雨"))
            
         self.temperLbl.setText("\(currentCity)--\(date)--\(weather)--\(wind)--\(temperature)")
            
            
        }
        
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        self.getNetDatas()
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

var cityName = "深圳".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!

