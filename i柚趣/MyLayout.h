//
//  MyLayout.h
//  TestWaterFlow
//
//  Created by gaokunpeng on 15/9/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyLayoutDelegate <NSObject>

//返回多少列
- (NSInteger)numberOfColumns;
//返回每一个cell的高度
- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyLayout : UICollectionViewLayout
/*
 @param sectionInsets:网格视图每一组的上下左右的间距
 @param itemSpace:cell的横向间距
 @param lineSpace:cell的纵向间距
 */
- (instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace;
//代理属性
@property (nonatomic,weak)id<MyLayoutDelegate> delegate;

@end
