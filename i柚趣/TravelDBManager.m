//
//  TravelDBManager.m
//  i柚趣
//
//  Created by luyoudui on 15/10/17.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "TravelDBManager.h"
#import "FMDatabase.h"
#import "DestinaModel.h"
@implementation TravelDBManager{
    FMDatabase *_db;
}
+(id)sharedManager
{
    static TravelDBManager *manager=nil;
    @synchronized(self){
        if(manager==nil){
            manager=[[TravelDBManager alloc]init];
        }
    }
    return manager;
}
-(instancetype)init
{
    if(self=[super init]){
        NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/travel.db"];

        _db=[[FMDatabase alloc]initWithPath:path];
        if([_db open]){
            NSString *sql=@"create table if not exists travel(id integer primary key autoincrement,APPId varchar(1000),name_zh_cn varchar(255),name_en varchar(255),image_url varchar(1000))";
            BOOL ret=[_db executeUpdate:sql];
            if(!ret){
                NSLog(@"create table error:%@",_db.lastErrorMessage);
            }
        }else{
            NSLog(@"数据库打开失败");
        }
    }
    return self;
}
//添加数据
-(void)insertFavoriteData:(DestinaModel*)model
{
    
    NSString *sql=@"insert into travel(APPId,name_zh_cn,name_en,image_url)values(?,?,?,?)";
    //此方法中的参数必须是对象
    BOOL ret=[_db executeUpdate:sql,model.myId,model.name_zh_cn,model.name_en,model.image_url];
    if(!ret){
        NSLog(@"insert error:%@",_db.lastErrorMessage);
    }else{
        NSLog(@"插入成功");
    }
}
//根据应用的id删除该应用的记录
-(void)deleteDataById:(NSString *)APPId
{
    NSString *sql=@"delete from travel where APPId=?";
    BOOL ret=[_db executeUpdate:sql,APPId];
    if(!ret){
        NSLog(@"delete error:%@",_db.lastErrorMessage);
    }
}
//获取所有的应用信息
-(NSArray*)fetchAllData
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSString *sql=@"select * from travel";
    FMResultSet *rs=[_db executeQuery:sql];
    while ([rs next]) {
        DestinaModel *model=[[DestinaModel alloc]init];
        model.myId=[rs stringForColumn:@"APPId"];
        model.name_en=[rs stringForColumn:@"name_en"];
        model.name_zh_cn = [rs stringForColumn:@"name_zh_cn"];
        model.image_url = [rs stringForColumn:@"image_url"];
        
        [array addObject:model];
    }
    return array;
}
//根据应用的id判断其是否存在
-(BOOL)isAppExists:(NSString*)APPId
{
    NSString *sql=@"select * from travel where APPId=?";
    FMResultSet *rs=[_db executeQuery:sql,APPId];
    return [rs next];
}
@end
