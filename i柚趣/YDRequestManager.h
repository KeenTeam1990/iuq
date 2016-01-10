//
//  YDRquestManager.h
//  项目工具
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDRequest.h"
@interface YDRequestManager : NSObject
//定义单例类
+ (id)sharedManager;
//请求数据
- (void)GETWithUrl:(NSString *)urlString httpUrl:(NSString *)httpUrl api:(NSString *)api finished:(FinishedBlock)finished failed:(FailedBlock)failed;

@end
