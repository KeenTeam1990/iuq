//
//  ChosenModel.h
//  i柚趣
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "JSONModel.h"

@interface ChosenModel : JSONModel
//内容图片
@property (nonatomic,copy) NSString *contentImg;
//时间
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *Id;
//标题
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *typeId;
@property (nonatomic,copy) NSString *typeName;
//详情
@property (nonatomic,copy) NSString *url;
//用户头像
@property (nonatomic,copy) NSString *userLogo;
@property (nonatomic,copy) NSString *userLogo_code;
//用户名
@property (nonatomic,copy) NSString *userName;
@end
