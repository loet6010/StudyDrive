//
//  QuestionCollectManager.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/17.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "QuestionCollectManager.h"

@implementation QuestionCollectManager


//判断数组中是否题目已经存在
+(BOOL)selectWrongQuestiong:(NSString *)mid{
    //获取本地错误题目数组
    NSArray *wrongArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"WRONG_QUESTION"];
    
    for (int i=0; i<wrongArray.count; i++) {
        if ([wrongArray[i] isEqualToString:mid]) {
            return YES;
        }
    }
    return NO;
}
//获取错题数组
+(NSArray *)getWrongQuestion{
    //获取本地错误题目数组
    NSArray *wrongArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"WRONG_QUESTION"];
    //返回数组
    if (wrongArray==nil) {
        return @[];
    }else{
        return wrongArray;
    }
}
//添加错题
+(void)addWrongQuestion:(NSString *)mid{
    //获取本地错误题目数组
    NSArray *wrongArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"WRONG_QUESTION"];
    //创建可变数组接收本地数组
    NSMutableArray *wrongMutable = [NSMutableArray arrayWithArray:wrongArray];
    //添加新的错题
    [wrongMutable addObject:mid];
    //将数组存储到本地
    [[NSUserDefaults standardUserDefaults]setObject:wrongMutable forKey:@"WRONG_QUESTION"];
    //同步到磁盘
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%lu",(unsigned long)wrongMutable.count);
    
    
}
//移除错题
+(void)removeWrongQuestion:(NSString *)mid{
    //获取本地错误题目数组
    NSArray *wrongArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"WRONG_QUESTION"];
    //创建可变数组接收本地数组
    NSMutableArray *wrongMutable = [NSMutableArray arrayWithArray:wrongArray];
    //将等于mid的数据移除
    for (int i=(int)wrongMutable.count-1; i>0; i--) {
        if ([wrongMutable[i] isEqualToString:mid]) {
            [wrongMutable removeObjectAtIndex:i];
        }
    }
    //将数组存储到本地
    [[NSUserDefaults standardUserDefaults] setObject:wrongMutable forKey:@"WRONG_QUESTION"];
    //同步到磁盘
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//清除错题
+(void)clearWrongQuestion{
    //创建一个空数组
    NSArray *clearArray = @[];
    //将数组存储到本地
    [[NSUserDefaults standardUserDefaults] setObject:clearArray forKey:@"WRONG_QUESTION"];
    //同步到磁盘
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%lu",(unsigned long)clearArray.count);
}



//判断数组中是否题目已经存在
+(BOOL)selectCollectQuestiong:(NSString *)mid{
    //获取本地错误题目数组
    NSArray *collectArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"COLLECT_QUESTION"];
    
    for (int i=0; i<collectArray.count; i++) {
        if ([collectArray[i] isEqualToString:mid]) {
            return YES;
        }
    }
    return NO;
}
//获取收藏题数组
+(NSArray *)getCollectQuestion{
    //获取本地错误题目数组
    NSArray *collectArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"COLLECT_QUESTION"];
    //返回数组
    if (collectArray==nil) {
        return @[];
    }else{
        return collectArray;
    }
}
//添加收藏题
+(void)addCollectQuestion:(NSString *)mid{
    //获取本地错误题目数组
    NSArray *collectArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"COLLECT_QUESTION"];
    //创建可变数组接收本地数组
    NSMutableArray *collectMutable = [NSMutableArray arrayWithArray:collectArray];
    //添加新的错题
    [collectMutable addObject:mid];
    //将数组存储到本地
    [[NSUserDefaults standardUserDefaults]setObject:collectMutable forKey:@"COLLECT_QUESTION"];
    //同步到磁盘
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%lu",(unsigned long)collectMutable.count);
    
    
}
//移除收藏题
+(void)removeCollectQuestion:(NSString *)mid{
    //获取本地错误题目数组
    NSArray *collectArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"COLLECT_QUESTION"];
    //创建可变数组接收本地数组
    NSMutableArray *collectMutable = [NSMutableArray arrayWithArray:collectArray];
    //将等于mid的数据移除
    for (int i=0; i<collectMutable.count; i++) {
        if ([collectMutable[i] isEqualToString:mid]) {
            [collectMutable removeObjectAtIndex:i];
            continue;
            
        }
    }
    //将数组存储到本地
    [[NSUserDefaults standardUserDefaults] setObject:collectMutable forKey:@"COLLECT_QUESTION"];
    //同步到磁盘
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
