//
//  MyDataManager.h
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/3.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    chapter,//章节练习数据
    answer,//答题数据
    specific//专项练习
}DataType;
@interface MyDataManager : NSObject

+(NSArray *)getData:(DataType)type;

@end
