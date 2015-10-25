//
//  SheetView.h
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/8.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import <UIKit/UIKit.h>

//********设置代理，声明代理方法********
@protocol SheetViewDelegate
-(void)SheetViewClick:(int)index;
@end


@interface SheetView : UIView
{
    //声明背景View
    @public UIView *_backView;
}
//********代理的成员变量********
@property(nonatomic,weak)id<SheetViewDelegate> svDelegate;

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView andQuestionCount:(int)count;
//点击根据题号显示button底色的方法
-(void)clickBtnColor:(int)quesNum;

@end
