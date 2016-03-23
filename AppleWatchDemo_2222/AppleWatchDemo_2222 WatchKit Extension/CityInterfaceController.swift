//
//  CityInterfaceController.swift
//  AppleWatchDemo_2222
//
//  Created by gaomingyang1987 on 16/3/22.
//  Copyright © 2016年 gaomingyang1987. All rights reserved.
//

import WatchKit
import Foundation


class CityInterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    let dataList = ["北京","上海","广州","深圳"]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    //设置展示多少行数据
    self.table.setNumberOfRows(dataList.count, withRowType: "CityRow")
    
        // Configure interface objects here.
        print("进入第二个界面!!!!")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        for var i=0; i<self.dataList.count ; i++ {
        //获取到每一个行
            let row:CityRow = self.table.rowControllerAtIndex(i) as! CityRow
            row.cityLbl.setText(self.dataList[i])
        }
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let name:String = self.dataList[rowIndex]
        cityName = name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
    }
}
