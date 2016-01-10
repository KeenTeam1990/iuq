//
//  YDRquestManager.m
//  项目工具
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "YDRequestManager.h"

@implementation YDRequestManager

+ (id)sharedManager{
    static YDRequestManager *manager = nil;
    @synchronized(self){
        if (manager == nil) {
            manager = [[YDRequestManager alloc] init];
        }
    }
    return manager;
}

- (void)GETWithUrl:(NSString *)urlString httpUrl:(NSString *)httpUrl api:(NSString *)api finished:(FinishedBlock)finished failed:(FailedBlock)failed{
    YDRequest *request = [[YDRequest alloc] init];
    request.finished = finished;
    request.failed = failed;
    [request startRequestDataWithUrl:urlString httpUrl:httpUrl api:api];
}
@end
