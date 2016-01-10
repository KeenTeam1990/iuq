//
//  DestinaModel.h
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "JSONModel.h"

@interface DestinaModel : JSONModel
@property (nonatomic,copy) NSString *name_zh_cn;
@property (nonatomic,copy) NSString *name_en;
@property (nonatomic,copy) NSString *myId;
@property (nonatomic,copy) NSString *image_url;
@end
