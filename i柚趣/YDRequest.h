//
//  YDRequest.h
//  项目工具
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^FinishedBlock) (NSData *data);
typedef void (^FailedBlock) (NSString *errorMessage);
@interface YDRequest : NSObject
//定义block
@property (nonatomic,copy) FinishedBlock finished;
@property (nonatomic,copy) FailedBlock failed;
//开始请求方法
- (void)startRequestDataWithUrl:(NSString *)urlString httpUrl:(NSString *)httpUrl api:(NSString *)api;
@end
