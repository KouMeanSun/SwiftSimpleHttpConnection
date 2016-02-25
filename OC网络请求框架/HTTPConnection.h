//
//  HTTPConnection.h
//  HTTPConnection_自定义网络请求
//
//  Created by gaomingyang1987 on 16/1/25.
//  Copyright (c) 2016年 gaomingyang1987. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 参数1，返回值类型
 参数2，block的名字
 参数3，是需要返回给调用者的参数
 */
typedef void(^RequestCallBack)(NSData *data,NSError *error);

@protocol HTTPConnectionDelegate <NSObject>

-(void)finishedConnection:(NSData *)data;

-(void)failedConnection:(NSError *)error;

@end


@interface HTTPConnection : NSObject
@property (nonatomic,copy)RequestCallBack block;
@property (nonatomic,weak)id<HTTPConnectionDelegate> delegate;
/**
 参数1，字符串类型的url
 参数2，请求接口的参数
 参数3，回调的block
 */
+(void)getRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block;
/**
 参数1，字符串类型的url
 参数2，是请求接口的参数
 参数3，回调的delegate
 */
+(void)getRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate;

//封装post请求，
+(void)postRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block;

+(void)postRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate;
//==========================利用NSURLSession 封装网络请求
+(void)sessionGetRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block;
+(void)sessionGetRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate;
+(void)sessionPostRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params block:(RequestCallBack)block;
+(void)sessionPostRequestWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params delegate:(id)delegate;
@end
