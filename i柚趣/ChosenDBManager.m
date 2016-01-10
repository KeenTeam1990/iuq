//
//  ChosenDBManager.m
//  i柚趣
//
//  Created by luyoudui on 15/10/17.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "ChosenDBManager.h"
#import "FMDatabase.h"
#import "ChosenModel.h"
@implementation ChosenDBManager{
    FMDatabase *_db;
}
+(id)sharedManager
{
    static ChosenDBManager *manager=nil;
    @synchronized(self){
        if(manager==nil){
            manager=[[ChosenDBManager alloc]init];
        }
    }
    return manager;
}
-(instancetype)init
{
    if(self=[super init]){
        NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/chosen.db"];
//        NSLog(@"%@",path);
        _db=[[FMDatabase alloc]initWithPath:path];
        if([_db open]){
            NSString *sql=@"create table if not exists chosen(id integer primary key autoincrement,APPId varchar(1000),userName varchar(1000),userLogo varchar(1000),url varchar(1000),title varchar(1000),contentImage varchar(1000),typedName varchar(1000),date varchar(1000))";
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
-(void)insertFavoriteData:(ChosenModel*)model
{

    NSString *sql=@"insert into chosen(APPId,userName,userLogo,url,title,contentImage,typedName,date)values(?,?,?,?,?,?,?,?)";
    //此方法中的参数必须是对象
    BOOL ret=[_db executeUpdate:sql,model.Id,model.userName,model.userLogo,model.url,model.title,model.contentImg,model.typeName,model.date];
    if(!ret){
        NSLog(@"insert error:%@",_db.lastErrorMessage);
    }else{
        NSLog(@"插入成功");
    }
}
//根据应用的id删除该应用的记录
-(void)deleteDataById:(NSString *)APPId
{
    NSString *sql=@"delete from chosen where APPId=?";
    BOOL ret=[_db executeUpdate:sql,APPId];
    if(!ret){
        NSLog(@"delete error:%@",_db.lastErrorMessage);
    }
}
//获取所有的应用信息
-(NSArray*)fetchAllData
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSString *sql=@"select * from chosen";
    FMResultSet *rs=[_db executeQuery:sql];
    while ([rs next]) {
        ChosenModel *model=[[ChosenModel alloc]init];
        model.Id=[rs stringForColumn:@"APPId"];
        model.userName=[rs stringForColumn:@"userName"];
        model.userLogo = [rs stringForColumn:@"userLogo"];
        model.url = [rs stringForColumn:@"url"];
        model.title = [rs stringForColumn:@"title"];
        model.contentImg = [rs stringForColumn:@"contentImage"];
        model.typeName = [rs stringForColumn:@"typedName"];
        model.date = [rs stringForColumn:@"date"];
        [array addObject:model];
    }
    return array;
}
//根据应用的id判断其是否存在
-(BOOL)isAppExists:(NSString*)APPId
{
    NSString *sql=@"select * from chosen where APPId=?";
    FMResultSet *rs=[_db executeQuery:sql,APPId];
    return [rs next];
}

@end
