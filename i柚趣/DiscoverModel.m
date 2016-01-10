//
//  DiscoverModel.m
//  i柚趣
//
//  Created by luyoudui on 15/10/13.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"Id"}];
}
@end
