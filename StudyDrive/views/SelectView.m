//
//  SelectView.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/9/30.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "SelectView.h"

@implementation SelectView
{
    //创建成员变量，用于接收外界传入button
    UIButton *_button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//实现初始化方法
-(instancetype)initWithFrame:(CGRect)frame andBtn:(UIButton *)btn{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _button = btn;
        [self creatBtn];
    }
    return self;
}

//创建button界面
-(void)creatBtn{
    for (int i=0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        //设置button的位置
        btn.frame = CGRectMake(self.frame.size.width/4*i+self.frame.size.width/8-30, self.frame.size.height-80, 60, 60);
        //设置button的图片
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]] forState:UIControlStateNormal];
        //设置button的值
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        //显示button页面
        [self addSubview:btn];
    }
}

//点击画面渐变操作
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
}

//创建按键点击
-(void)click:(UIButton *)btn{
    //根据点击的按钮背景来获取更换的背景图片
    [_button setImage: [btn backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    //让画面渐变替换
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
}


@end
