//
//  HTTPConnection.m
//  HTTPConnection_自定义网络请求
//
//  Created by gaomingyang1987 on 16/1/25.
//  Copyright (c) 2016年 gaomingyang1987. All rights reserved.
//

#import "HTTPConnection.h"

@interface HTTPConnection ()<NSURLConnectionDataDelegate>
@property (nonatomic,strong)NSMutableData *bufData;
@end

@implementation HTTPConnection

+(void)getRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block{
//调用自己的➖方法
    HTTPConnection *connection = [[HTTPConnection alloc] init];
    [connection getRequetWithUrl:urlStr params:params block:block];
}

+(void)getRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate{
    HTTPConnection *connection = [[HTTPConnection alloc] init];
    [connection getRequestWithUrl:urlStr params:params delegate:delegate];
}

+(void)postRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block{
    HTTPConnection *connection = [[HTTPConnection alloc] init];
    [connection postWithUrlStr:urlStr params:params block:block];
}
+(void)postRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate{
    HTTPConnection *connection = [[HTTPConnection alloc] init];
    [connection postWithUrlStr:urlStr params:params delegate:delegate];

}
//=============session+ 方法
+(void)sessionGetRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block{
    HTTPConnection *connection = [HTTPConnection new];
    [connection sessionGetUrlStr:urlStr params:params block:block];
}
+(void)sessionGetRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate{
    HTTPConnection *connection = [HTTPConnection new];
    [connection sessionGetUrlStr:urlStr params:params delegate:delegate];
}
+(void)sessionPostRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block{
    HTTPConnection *connection = [HTTPConnection new];
    [connection sessionPostWithUrlStr:urlStr params:params block:block];
}
+(void)sessionPostRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate{
    HTTPConnection *connection = [HTTPConnection new];
    [connection sessionPostWithUrlStr:urlStr params:params delegate:delegate];
}

//==============sessio - 方法
-(void)sessionGetUrlStr:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block{
    //1. 赋值block
    self.block = block;
    //2.拼接参数
    if (params) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSString *key in params) {
            NSString *value = params[key];
            NSString *tmp = [NSString stringWithFormat:@"%@=%@",key,value];
            [list addObject:tmp];
        }
        //把可变数组转化成字符串，
        NSString *paramStr = [list componentsJoinedByString:@"&"];
        urlStr = [urlStr stringByAppendingFormat:@"?%@",paramStr];
    }
    NSLog(@"urlStr:%@",urlStr);
    //3.生成NSURL
    NSURL *url = [NSURL URLWithString:urlStr];
    //4.生成request
    NSURLRequest *request  = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession    *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task  = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (self.block) {
            self.block(data,error);
        }

    }];
    [task resume];
}
-(void)sessionGetUrlStr:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate{
    //1. 赋值block
    self.delegate = delegate;
    //2.拼接参数
    if (params) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSString *key in params) {
            NSString *value = params[key];
            NSString *tmp = [NSString stringWithFormat:@"%@=%@",key,value];
            [list addObject:tmp];
        }
        //把可变数组转化成字符串，
        NSString *paramStr = [list componentsJoinedByString:@"&"];
        urlStr = [urlStr stringByAppendingFormat:@"?%@",paramStr];
    }
    NSLog(@"urlStr:%@",urlStr);
    //3.生成NSURL
    NSURL *url = [NSURL URLWithString:urlStr];
    //4.生成request
    NSURLRequest *request  = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession    *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task  = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(failedConnection:)]) {
                [self.delegate failedConnection:error];
            }
  
        }else{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(finishedConnection:)]) {
            [self.delegate finishedConnection:data];
        }
        }
    }];
    [task resume];
}

-(void)sessionPostWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block{
    //1. 赋值block
    self.block = block;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    if (params) {//POST
        //拆分字典
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSString *key in params) {
            NSString *value = params[key];
            NSString *tmp = [NSString stringWithFormat:@"%@=%@",key,value];
            [list addObject:tmp];
        }
        
        //组装成字符串
        NSString *paramsStr = [list componentsJoinedByString:@"&"];
        
        //把字符串转化成NSData
        NSData *paramData = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
        //设置httpbody
        request.HTTPBody  = paramData;
    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession    *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task  = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (self.block) {
            self.block(data,error);
        }
        
    }];
    [task resume];
}

-(void)sessionPostWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate{
    //1. 赋值block
    self.delegate = delegate;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    if (params) {//POST
        //拆分字典
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSString *key in params) {
            NSString *value = params[key];
            NSString *tmp = [NSString stringWithFormat:@"%@=%@",key,value];
            [list addObject:tmp];
        }
        
        //组装成字符串
        NSString *paramsStr = [list componentsJoinedByString:@"&"];
        
        //把字符串转化成NSData
        NSData *paramData = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
        //设置httpbody
        request.HTTPBody  = paramData;
    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession    *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task  = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(failedConnection:)]) {
                [self.delegate failedConnection:error];
            }
            
        }else{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(finishedConnection:)]) {
                [self.delegate finishedConnection:data];
            }
        }
    }];
    [task resume];
}

//============================connection -==================

-(void)postWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block{
    self.block = block;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    if (params) {//POST
        //拆分字典
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSString *key in params) {
            NSString *value = params[key];
            NSString *tmp = [NSString stringWithFormat:@"%@=%@",key,value];
            [list addObject:tmp];
        }
        
        //组装成字符串
        NSString *paramsStr = [list componentsJoinedByString:@"&"];

        //把字符串转化成NSData
        NSData *paramData = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
        //设置httpbody
        request.HTTPBody  = paramData;
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (self.block) {
            self.block(data,connectionError);
        }
    }];
    
}
-(void)postWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate{
    self.delegate = delegate;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    if (params) {//POST
        //拆分字典
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSString *key in params) {
            NSString *value = params[key];
            NSString *tmp = [NSString stringWithFormat:@"%@=%@",key,value];
            [list addObject:tmp];
        }
        
        //组装成字符串
        NSString *paramsStr = [list componentsJoinedByString:@"&"];
        
        //把字符串转化成NSData
        NSData *paramData = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
        //设置httpbody
        request.HTTPBody  = paramData;
    }
    [NSURLConnection connectionWithRequest:request delegate:self];
}


-(void)getRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate{
//1.给delegate赋值
    self.delegate = delegate;
//2.拼接url参数
    if (params) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSString *key in params) {
            NSString *value = params[key];
            NSString *tmp = [NSString stringWithFormat:@"%@=%@",key,value];
            [list addObject:tmp];
        }
        NSString *paramStr = [list componentsJoinedByString:@"&"];
        urlStr = [urlStr stringByAppendingFormat:@"?%@",paramStr];
    }
    NSLog(@"urlStr:%@",urlStr);
//3.创建NSURL
    NSURL *url = [NSURL URLWithString:urlStr];
//4.创建请求的request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//5.利用NSURLConnection进行网络连接
    [NSURLConnection connectionWithRequest:request delegate:self];
}


/**
 对应＋方法的-方法
 
 */
-(void)getRequetWithUrl:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block{
//1. 赋值block
    self.block = block;
//2.拼接参数
    if (params) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSString *key in params) {
            NSString *value = params[key];
            NSString *tmp = [NSString stringWithFormat:@"%@=%@",key,value];
            [list addObject:tmp];
        }
        //把可变数组转化成字符串，
        NSString *paramStr = [list componentsJoinedByString:@"&"];
        urlStr = [urlStr stringByAppendingFormat:@"?%@",paramStr];
    }
    NSLog(@"urlStr:%@",urlStr);
 //3.生成NSURL
    NSURL *url = [NSURL URLWithString:urlStr];
//4.生成request
    NSURLRequest *request  = [NSURLRequest requestWithURL:url];
//5.利用NSURLConnection进行网络连接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (self.block) {
            self.block(data,connectionError);
        }
    }];
}

#pragma mark -- NSURLConnectionDataDelegate
//接收到服务器响应，
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"接收到服务器响应");
    if (_bufData == nil) {
        _bufData = [[NSMutableData alloc] init];
    }else{
        _bufData.length = 0;
    }
}
//接收到服务器数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"接收到服务器数据");
    [_bufData appendData:data];
}
//完成连接
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"完成连接");
    //把数据传给调用者
//    [self.delegate finishedConnection:_bufData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishedConnection:)]) {
        [self.delegate finishedConnection:_bufData];
    }
}
//连接失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"连接失败");
    //把错误信息传给调用者
    if (self.delegate && [self.delegate respondsToSelector:@selector(failedConnection:)]) {
        [self.delegate failedConnection:error];
    }
}
@end
