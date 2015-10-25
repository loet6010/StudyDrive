//
//  TestSelectViewController.h
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/3.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestSelectViewController : UIViewController

//接收数据库查找出的数据
@property(nonatomic,copy)NSArray *dataArray;
//导航栏标题
@property(nonatomic,copy)NSString *myTitle;
//练习模式：1，章节练习；4，专项练习
@property(nonatomic,assign) int myTestType;

@end
