//
//  DiscoverDetailModel.h
//  i柚趣
//
//  Created by luyoudui on 15/10/13.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "JSONModel.h"
#import "DiscoverPhotoModel.h"
@interface DiscoverDetailModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *msg;
@property (nonatomic,copy) NSString<Optional> *add_datetime_pretty;
@property (nonatomic,copy) NSString<Optional> *favorite_count;

@property (nonatomic,strong) DiscoverPhotoModel<Optional> *photo;
@end
