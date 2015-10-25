//
//  AnswerScrollView.h
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/4.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import <UIKit/UIKit.h>

//*********************
//声明协议
@protocol ChangeLabelDelegate
-(void)changeLabelText:(int)titleNum;
@end
//*********************

@interface AnswerScrollView : UIView
{
//可滑动的scrollview
@public UIScrollView *_scrollView;
}
//用于判断页数
@property(nonatomic,assign,readonly)int currentPage;

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *) array;
-(void)reloadData;
//存放题目的数组
@property(nonatomic,strong) NSArray *dataArrry;
//存放答题状态的数组（题目未答存“0”,已答存“1”，"2"，"3"，"4"）
@property(nonatomic,strong) NSMutableArray *hadAnswerArray;
//存放答题对错状态的数组（答对“0”,打错存“1”）
@property(nonatomic,strong) NSMutableArray *wrongOrRightArray;

//*********************
//协议成员变量
@property(nonatomic,weak)id<ChangeLabelDelegate> clDelegate;
//*********************

@end
