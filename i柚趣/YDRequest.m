//
//  YDRequest.m
//  项目工具
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "YDRequest.h"
#import "NSString+URL.h"
@implementation YDRequest
- (void)startRequestDataWithUrl:(NSString *)urlString httpUrl:(NSString *)httpUrl api:(NSString *)api{
    NSString *encodedString = [urlString URLEncodedString];
    NSString *httpArg = encodedString;
    [self requestHttpUrl:httpUrl withHttpArg:httpArg api:api];
}
-(void)requestHttpUrl: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg api:(NSString *)api {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: api forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue]completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
        if (error) {
            if (self.failed) {
                self.failed(error.localizedDescription);
            }
        } else if (data) {
            if (self.finished) {
                self.finished(data);
            }
        }
    }];
}

@end
