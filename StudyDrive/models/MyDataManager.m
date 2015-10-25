//
//  MyDataManager.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/3.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "MyDataManager.h"
#import "FMDatabase.h"
#import "TestSelectModel.h"
#import "AnswerModel.h"
#import "SpecificTestModel.h"

@implementation MyDataManager

+(NSArray *)getData:(DataType)type{
    static FMDatabase *dataBase;
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if (dataBase==nil) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"sqlite"];
        dataBase = [[FMDatabase alloc]initWithPath:path];
    }
    
    if ([dataBase open]) {
//        NSLog(@"open success");
    }else{
        return array;
    }
    
    switch (type) {
        case chapter://章节练习
        {
            NSString *sql = @"select pid,pname,pcount FROM firstlevel";
            FMResultSet *fmResult = [dataBase executeQuery:sql];
            
            while ([fmResult next]) {
                TestSelectModel *tsModel = [[TestSelectModel alloc]init];
                [tsModel setPid:[NSString stringWithFormat:@"%d",[fmResult intForColumn:@"pid"]]];
                [tsModel setPname:[fmResult stringForColumn:@"pname"]];
                [tsModel setPcount:[NSString stringWithFormat:@"%d",[fmResult intForColumn:@"pcount"]]];
                
                [array addObject:tsModel];
            }
        }
            break;
            
        case answer://答题内容
        {
            NSString *sql = @"select mquestion,mdesc,mid,manswer,mimage,pid,pname,sid,sname,mtype FROM leaflevel";
            FMResultSet *fmResult = [dataBase executeQuery:sql];
            
            while ([fmResult next]) {
                AnswerModel *asModel = [[AnswerModel alloc]init];
                
                [asModel setMquestion:[fmResult stringForColumn:@"mquestion"]];
                [asModel setMdesc:[fmResult stringForColumn:@"mdesc"]];
                [asModel setMid:[NSString stringWithFormat:@"%d",[fmResult intForColumn:@"mid"]]];
                [asModel setManswer:[fmResult stringForColumn:@"manswer"]];
                [asModel setMimage:[fmResult stringForColumn:@"mimage"]];
                [asModel setPid:[NSString stringWithFormat:@"%d",[fmResult intForColumn:@"pid"]]];
                [asModel setPname:[fmResult stringForColumn:@"pname"]];
                [asModel setSid:[fmResult stringForColumn:@"sid"]];
                [asModel setSname:[fmResult stringForColumn:@"sname"]];
                [asModel setMtype:[NSString stringWithFormat:@"%d",[fmResult intForColumn:@"mtype"]]];
                
                [array addObject:asModel];
            }
        }
            break;
            
        case specific://专项练习
        {
            NSString *sql = @"select sid,sname FROM secondlevel";
            FMResultSet *fmResult = [dataBase executeQuery:sql];
            
            while ([fmResult next]) {
                SpecificTestModel *stModel = [[SpecificTestModel alloc]init];
                [stModel setSid:[fmResult stringForColumn:@"sid"]];
                [stModel setSname:[fmResult stringForColumn:@"sname"]];
                
                [array addObject:stModel];
            }
        }
            break;
            
        default:
            break;
    }
    
    return array;
}

@end
