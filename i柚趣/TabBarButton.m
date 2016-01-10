//
//  TabBarButton.m
//  i柚趣
//
//  Created by luyoudui on 15/10/2.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "TabBarButton.h"

@implementation TabBarButton
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return self;
}

//重写图片在按钮上的位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width-30)/2, 2, 30, 30);
}
//重写文字在按钮上的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 32, contentRect.size.width, 15);
}
@end
