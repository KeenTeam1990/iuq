
//
//  travelModel.m
//  i柚趣
//
//  Created by luyoudui on 15/10/12.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "TravelModel.h"

@implementation TravelModel
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"myId"}];
}
@end
