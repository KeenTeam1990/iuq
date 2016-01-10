
//
//  ChosenModel.m
//  i柚趣
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "ChosenModel.h"

@implementation ChosenModel
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"Id"}];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
