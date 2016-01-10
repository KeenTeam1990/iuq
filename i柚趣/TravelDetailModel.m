//
//  TravelDetailModel.m
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "TravelDetailModel.h"

@implementation TravelDetailModel
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"myId",@"description":@"desc"}];
}
@end
