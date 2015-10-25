//
//  Tools.h
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/4.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

+(NSArray *)getAnswerWithString:(NSString *)str;

+(CGSize)getSizeWithString:(NSString *)str with:(UIFont *)font whitSize:(CGSize)size;

@end
