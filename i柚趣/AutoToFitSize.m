//
//  AutoToFitSize.m
//  i柚趣
//
//  Created by luyoudui on 15/10/18.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "AutoToFitSize.h"

@implementation AutoToFitSize

+ (CGSize)string:(NSString *)string{
    UIFont *font=[UIFont systemFontOfSize:15];
    NSDictionary *dict=@{NSFontAttributeName:font};
    //计算显示desc字符串内容需要的大小
    CGSize descSize=[string boundingRectWithSize:CGSizeMake(__kScreenWidth, 9999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    return descSize;
}

@end
