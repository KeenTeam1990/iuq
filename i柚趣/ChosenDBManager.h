//
//  ChosenDBManager.h
//  i柚趣
//
//  Created by luyoudui on 15/10/17.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChosenModel;
@interface ChosenDBManager : NSObject
+(id)sharedManager;
//添加数据
-(void)insertFavoriteData:(ChosenModel*)model;
//根据应用的id删除该应用的记录
-(void)deleteDataById:(NSString *)APPId;
//获取所有的应用信息
-(NSArray*)fetchAllData;
//根据应用的id判断是否存在
-(BOOL)isAppExists:(NSString*)APPId;
@end
