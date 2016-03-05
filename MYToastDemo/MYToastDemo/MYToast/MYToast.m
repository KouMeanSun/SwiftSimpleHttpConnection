//
//  MYToast.m
//  MYToastDemo
//
//  Created by gaomingyang1987 on 16/3/5.
//  Copyright © 2016年 gaomingyang1987. All rights reserved.
//

#import "MYToast.h"

@implementation MYToast

+(void)showToastWithMessage:(NSString *)message length:(TOAST_LENGTH)length ParentView:(UIView *)parentView{
    [[MYToast new] showWithMessage:message length:length ParentView:parentView];
}


+(void)showToastWithMessage:(NSString *)message length:(TOAST_LENGTH)length ParentView:(UIView *)parentView  position:(POSITION)position{
    [[MYToast new] showWithMessage:message length:length ParentView:parentView position:position];
}


//===============  减方法
-(void)showWithMessage:(NSString *)message length:(TOAST_LENGTH)length ParentView:(UIView *)parentView{
    [self showWithMessage:message length:length ParentView:parentView position:POSITION_BOTTOM];
}

-(void)showWithMessage:(NSString *)message length:(TOAST_LENGTH)length ParentView:(UIView *)parentView position:(POSITION)position{
    CGRect rect = parentView.bounds;
    rect.size.width = rect.size.width*(3/4.0);
    rect.size.height = 40;
    rect.origin.x = rect.size.width*(1/4.0);
    
    UILabel *label = [[UILabel alloc] init];
    label.text = message;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    CGPoint centerPoint = parentView.center;
    switch (position) {
            //上部
        case POSITION_TOP:
            centerPoint.y = parentView.bounds.size.height*0.2;
            break;
            //中间
        case POSITION_CENTER:
          centerPoint.y = parentView.bounds.size.height*0.5;
            break;
            //底部
        case POSITION_BOTTOM:
          centerPoint.y = parentView.bounds.size.height*0.8;
            break;
        default:
        centerPoint.y = parentView.bounds.size.height*0.8;
            break;
    }
    
//    label.layer.cornerRadius = 5;
//    label.layer.borderWidth  = 4;
    
    [label setFrame:rect];
    [label setCenter:centerPoint];
    
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 12.0f;
    label.layer.borderWidth = 1.0f;
    label.layer.borderColor =[UIColor grayColor].CGColor;
    
    label.alpha = 0;
    [parentView addSubview:label];
    [UIView animateWithDuration:1.0 animations:^{
        label.alpha = 0.8;
    }];
    
    //设置弹出显示时间
    CGFloat timerLong   = 2.5f;
    switch (length) {
        case TOAST_SHORT:
            timerLong = 2.5f;
            break;
        case TOAST_MIDDLE:
            timerLong  = 3.5f;
            break;
        case TOAST_LONG:
            timerLong = 5.5f;
            break;
        default:
            timerLong = 2.5f;
            break;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:timerLong target:self selector:@selector(TimerOver:) userInfo:label repeats:NO];
    
}

-(void)TimerOver:(NSTimer *)sender{
    UILabel *label = (UILabel *)[sender userInfo];
    [UIView animateWithDuration:1.0 animations:^{
        label.alpha = 0;
    }];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeView:) userInfo:label repeats:NO];
}

-(void)removeView:(NSTimer *)sender{
UILabel *label = (UILabel *)[sender userInfo];
    [label removeFromSuperview];
}

@end
