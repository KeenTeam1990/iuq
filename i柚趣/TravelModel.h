//
//  travelModel.h
//  i柚趣
//
//  Created by luyoudui on 15/10/12.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "JSONModel.h"

@interface TravelModel : JSONModel
@property (nonatomic,copy) NSString *name_zh_cn;
@property (nonatomic,copy) NSString *name_en;
@property (nonatomic,copy) NSString *image_url;
@property (nonatomic,copy) NSString *myId;
@end

