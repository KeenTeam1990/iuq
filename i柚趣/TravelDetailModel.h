//
//  TravelDetailModel.h
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "JSONModel.h"

@interface TravelDetailModel : JSONModel
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *myId;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *plan_days_count;
@property (nonatomic,copy) NSString *plan_nodes_count;
@property (nonatomic,copy) NSString *image_url;
@end
