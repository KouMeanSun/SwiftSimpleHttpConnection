//
//  ViewController.m
//  MYToastDemo
//
//  Created by gaomingyang1987 on 16/3/5.
//  Copyright © 2016年 gaomingyang1987. All rights reserved.
//

#import "ViewController.h"
#import "MYToast.h"
@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)shortClick:(id)sender {
[MYToast showToastWithMessage:@"短时间测试" length:TOAST_SHORT ParentView:self.view position:POSITION_TOP];
}

- (IBAction)middelClick:(id)sender {
    [MYToast showToastWithMessage:@"普通时间测试" length:TOAST_MIDDLE ParentView:self.view position:POSITION_CENTER];
}
- (IBAction)longClick:(id)sender {
      [MYToast showToastWithMessage:@"长时间测试" length:TOAST_LONG ParentView:self.view];
}

@end
