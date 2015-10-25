//
//  QuestionCollectManager.h
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/17.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionCollectManager : NSObject

//判断数组中是否题目已经存在
+(BOOL)selectWrongQuestiong:(NSString *)mid;
//获取错题数组
+(NSArray *)getWrongQuestion;
//添加错题
+(void)addWrongQuestion:(NSString *)mid;
//移除错题
+(void)removeWrongQuestion:(NSString *)mid;
//清除错题
+(void)clearWrongQuestion;

//判断数组中是否题目已经存在
+(BOOL)selectCollectQuestiong:(NSString *)mid;
//获取收藏题数组
+(NSArray *)getCollectQuestion;
//添加收藏题
+(void)addCollectQuestion:(NSString *)mid;
//移除收藏题
+(void)removeCollectQuestion:(NSString *)mid;


@end
