//
//  AnswerViewController.h
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/4.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerViewController : UIViewController

//根据点击cell获取章节号，展现对应章节题目
@property(nonatomic,copy)NSString *number;

//练习模式：1，章节练习；2，顺序练习；3，随机练习；4，专项练习；5，仿真模拟考试；7，我的错题；8，我的收藏
@property(nonatomic,assign)int answerType;
@property(nonatomic,copy)NSString *myTitle;

@end
