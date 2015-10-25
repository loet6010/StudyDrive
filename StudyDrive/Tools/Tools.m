//
//  Tools.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/4.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "Tools.h"

@implementation Tools

//数据切分方法
+(NSArray *)getAnswerWithString:(NSString *)str{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *arr = [str componentsSeparatedByString:@"<BR>"];
    [array addObject:arr[0]];
    for (int i=0; i<4; i++) {
        [array addObject:[arr[i+1] substringFromIndex:2]];
    }
    
    return array;
}

//文字自适应对齐(文本上端对齐）
+(CGSize)getSizeWithString:(NSString *)str with:(UIFont *)font whitSize:(CGSize)size{
    
//    CGSize newSize = [str sizeWithFont:font constrainedToSize:size];
    CGSize newSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil].size;
    
    
    return newSize;
}

@end
