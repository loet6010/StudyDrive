//
//  SheetView.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/8.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "SheetView.h"

#define BTNSIZE self.frame.size.width

@interface SheetView()
{    
    //接收父视图用view
    UIView *_superView;
    //判断移动用
    BOOL _startingMove;
    //当前抽屉view的高度
    float _height;
    //当前抽屉view的宽度
    float _width;
    //y轴坐标（屏幕最低端）
    float _y;
    //声明一个scrollview
    UIScrollView *_stScrollView;
    //接收题目数量用的count
    int _count;
}
@end

@implementation SheetView

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView andQuestionCount:(int)count{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景色
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        //调用背景view
        _superView = superView;
        //题目数
        _count = count;
        //视图的纵坐标高度赋值给_y
        _y=frame.origin.y;
        _width=frame.size.width;
        _height=frame.size.height;
        //背景view
        [self creatBackView];
        //答案状态view
        
        //滚动题号视图view
        [self creatScrollView];
    }
    return self;
}

//创建背景view
-(void)creatBackView{
    _backView = [[UIView alloc]initWithFrame:_superView.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha=0;
    [_superView addSubview:_backView];
}

//
-(void)creatScrollView{
    _stScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width, self.frame.size.height-60)];
    _stScrollView.backgroundColor = [UIColor redColor];
    for (int i=0; i<_count; i++) {
        //创建显示题号button：qtBtn
        UIButton *qtBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        //button的位子
        qtBtn.frame = CGRectMake((self.frame.size.width-6*44)/2+2+44*(i%6), 44*(i/6), 40, 40);
        //button的背景色
        qtBtn.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        //button的圆角设置
        qtBtn.layer.masksToBounds = YES;
        qtBtn.layer.cornerRadius = 8;
        //button的显示序号（button的显示内容）
        [qtBtn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        
        //添加button的点击事件
        qtBtn.tag = 101+i;
        [qtBtn addTarget:self action:@selector(qtBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_stScrollView addSubview:qtBtn];
    }
    //设置_stScrollView的可滑动范围
    int tip = (_count%6)?1:0;
    _stScrollView.contentSize = CGSizeMake(0,20+44*(_count/6+1+tip));
    //scrollview的右侧进度条效果关闭
    _stScrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:_stScrollView];
}

//点击根据题号显示button底色的方法
-(void)clickBtnColor:(int)quesNum{
    for (int i=0; i<_count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+101];
        if(i!=quesNum){
            button.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        }else{
            button.backgroundColor = [UIColor orangeColor];
        }
    }
}

//点击题号button的方法
-(void)qtBtnClick:(UIButton *)btn{
    int index = (int)btn.tag-100;
    for (int i=0; i<_count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+101];
        if(i!=index-1){
            button.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        }else{
            button.backgroundColor = [UIColor orangeColor];
        }
    }
    
    //********给代理传值,实现代理方法********
    [_svDelegate SheetViewClick:index];
    [UIView animateWithDuration:0.3 animations:^{
        //隐藏背景
        _backView.alpha = 0;
        //视图下移不可见
        self.frame = CGRectMake(0, _y, _width, _height);
    }];

}

//手指在屏幕上点击移动时
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //新建touch对象，获取touches集合
    UITouch *touch = [touches anyObject];
    //获取屏幕点击点
    CGPoint point = [touch locationInView:[touch view]];
    //设置可移动范围：纵坐标25以内
    if (point.y < 25) {
        _startingMove = YES;
    }
    //移动中的视图效果
    if (_startingMove&&self.frame.origin.y >= _y-_height&&[self convertPoint:point toView:_superView].y>=100) {
        self.frame = CGRectMake(0, [self convertPoint:point toView:_superView].y, _width, _height);
        
        //让背景view随着移动颜色渐变
        float offSet = (_y-self.frame.origin.y)/_height*0.8;
        _backView.alpha = offSet;
    }
}

//手指离开屏幕时
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //判断移动的距离让view自动调整
    if (self.frame.origin.y > _y-_height/2) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, _y, _width, _height);
        }];
        _backView.alpha = 0;
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, _y-_height, _width, _height);
        }];
        _backView.alpha = 0.8;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
