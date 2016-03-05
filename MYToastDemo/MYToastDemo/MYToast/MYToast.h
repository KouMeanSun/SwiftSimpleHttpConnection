//
//  MYToast.h
//  MYToastDemo
//
//  Created by gaomingyang1987 on 16/3/5.
//  Copyright © 2016年 gaomingyang1987. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TOAST_LENGTH){
  TOAST_SHORT = 1,
  TOAST_MIDDLE = 2,
  TOAST_LONG = 3
}NS_ENUM_AVAILABLE_IOS(6_0);

typedef enum {
    POSITION_TOP =0,
    POSITION_CENTER ,
    POSITION_BOTTOM
}POSITION;



@interface MYToast : UIView
/**
 参数1  显示的内容
 参数2  显示时长
 参数3  放到哪个view上显示
 
 */
+(void)showToastWithMessage:(NSString *)message length:(TOAST_LENGTH)length ParentView:(UIView *)parentView;
/**
 参数1  显示的内容
 参数2  显示时长
 参数3  放到哪个view上显示
 参数4  相对于父view的上，中，下位置

 */
+(void)showToastWithMessage:(NSString *)message length:(TOAST_LENGTH)length ParentView:(UIView *)parentView  position:(POSITION)position;
@end
