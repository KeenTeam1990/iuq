//
//  ScrollModel.h
//  i柚趣
//
//  Created by luyoudui on 15/10/13.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "JSONModel.h"
#import "PhotoModel.h"
@interface ScrollModel : JSONModel
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,copy) NSString *favorite_count;
@property (nonatomic,copy) NSString *add_datetime_pretty;
@property (nonatomic,strong) PhotoModel *photo;
@end
