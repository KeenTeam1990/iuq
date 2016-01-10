//
//  TravelToDetailModel.h
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "JSONModel.h"

@interface TravelToDetailModel : JSONModel
@property (nonatomic,copy) NSString *entry_name;
@property (nonatomic,copy) NSString *image_url;
@property (nonatomic,copy) NSString *tips;
@end
