//
//  MyLayout.m
//  TestWaterFlow
//
//  Created by gaokunpeng on 15/9/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MyLayout.h"

@implementation MyLayout
{
    //上下左右的间距
    UIEdgeInsets _sectionInsets;
    //横向间距
    CGFloat _itemSpace;
    //纵向间距
    CGFloat _lineSpace;
    //列数
    NSInteger _column;
    
    //存储每一列的当前高度
    NSMutableArray *_heightArray;
    
    //存储attribute对象的数组
    NSMutableArray *_attrArray;
}

-(instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace
{
    if (self = [super init]) {
        _sectionInsets = sectionInsets;
        _itemSpace = itemSpace;
        _lineSpace = lineSpace;
        //默认为2列
        _column = 2;
    }
    return self;
}

//在每一次需要重新对网格视图进行布局的时候调用
-(void)prepareLayout
{
    [super prepareLayout];
    
    //1、计算有多少列
    _column = [self.delegate numberOfColumns];
    
    //属性
    _attrArray = [NSMutableArray array];
    
    _heightArray = [NSMutableArray array];
    //高度
    for (int i=0; i<_column; i++) {
        NSNumber *n = [NSNumber numberWithFloat:_sectionInsets.top];
        [_heightArray addObject:n];
    }
    
    //计算宽度
    CGFloat w = (self.collectionView.bounds.size.width-_sectionInsets.left-_sectionInsets.right-_itemSpace*(_column-1))/_column;

    //一共有多少个cell
    NSInteger cellCnt = [self.collectionView numberOfItemsInSection:0];
    
    //计算每一个cell的frame
    for (int i=0; i<cellCnt; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //高度
        CGFloat h = [self.delegate heightAtIndexPath:indexPath];
        
        //x的值
        //找到当前的cell应该放在第几列
        NSInteger colIndex = [self lowestColumnIndex];
        
        //colIndex==0  _sectionInsets.left
        //colIndex==1  _sectionInsets.left+ (w+_itemSpace)
        //colIndex==2  _sectionInsets.left +(w+_itemSpace)*2
        CGFloat x = _sectionInsets.left + (w+_itemSpace)*colIndex;
        
        //y的值
        CGFloat y = [_heightArray[colIndex] floatValue];
        
        //更新高度值
        _heightArray[colIndex] = [NSNumber numberWithFloat:y+h+_lineSpace];
        
        //设置frame值
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = CGRectMake(x, y, w, h);
        
        [_attrArray addObject:attr];
    }
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attrArray;
}

//返回网格视图的大小
- (CGSize)collectionViewContentSize
{
    //获取所有列中最高的那一列的高度
    CGFloat h = [self highestColumnHeight];
    return CGSizeMake(self.collectionView.bounds.size.width, h+_sectionInsets.bottom);
}

//获取所有列中最高的那一列的高度
- (CGFloat)highestColumnHeight
{
    CGFloat h = CGFLOAT_MIN;
    
    for (int i=0; i<_heightArray.count; i++) {
        NSNumber *n = _heightArray[i];
        if (n.floatValue > h) {
            h = n.floatValue;
        }
    }    
    return h;
}

//找到高度最小的那一列的序号
- (NSInteger)lowestColumnIndex
{
    NSInteger index = -1;
    CGFloat h = CGFLOAT_MAX;
    
    //试数
    //_heightArray = @[ 50, 30 , 40 ];
    
    //n == 50   index==0  h==50
    //n == 30  30 < 50成立   index = 1  h == 30
    //n == 40   40 < 30不成立
    
    for (int i=0; i<_heightArray.count; i++) {
        NSNumber *n = _heightArray[i];

        if (n.floatValue < h) {
            index = i;
            h = n.floatValue;
        }
        
    }
    
    return index;
}



@end
