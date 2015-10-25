//
//  AnswerViewController.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/4.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerScrollView.h"
#import "MyDataManager.h"
#import "AnswerModel.h"
#import "SheetView.h"
#import "MainTestViewController.h"
#import "QuestionCollectManager.h"

@interface AnswerViewController ()<SheetViewDelegate,ChangeLabelDelegate>
{
    AnswerScrollView *_anScrollView;
    SheetView *_sheetView;
    
    CGPoint point;
    
    //*********************
    UILabel *changeLabel;
    //*********************
    
    //考试计时器
    NSTimer *_testTimer;
    //显示倒计时label
    UILabel *_timeLabel;
    int _testTime;
    //收藏题目时用的view
    UIView *_collectView;
    UILabel *_collectLabel;
}

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置view背景颜色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //设置导航栏下起算纵坐标为0
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    //设置导航栏标题
    [self.navigationItem setTitle:_myTitle];
    
    //练习模式选择
    [self creatAnswerType];

    //*********************
    _anScrollView.clDelegate =self;
    //*********************
    
    //调用答题界面工具栏
    [self creatToolBar];
    //调用抽屉视图初始化：SheetView
    [self creatSheetView];
    //点击收藏提示view
    [self creatCollectView];
}

//练习模式选择
-(void)creatAnswerType{
    //取数据库中的元素
    NSArray *array = [MyDataManager getData:answer];
    //接收数据
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    //取随机数据
    NSMutableArray *arrRandom = [[NSMutableArray alloc]init];

    switch (_answerType) {
        case 1:{//章节练习
            for (int i=0; i<array.count; i++) {
                AnswerModel *model = array[i];
                if ([model.pid isEqualToString:_number]) {
                    [arr addObject:model];
                }
            }
        }
            break;
        case 2:{//顺序练习
            for (int i=0; i<array.count; i++) {
                AnswerModel *model = array[i];
                [arr addObject:model];
            }
            
        }
            break;
        case 3:{//随机练习
            [arrRandom addObjectsFromArray:array];
            
            for (int i=0; i<array.count; i++) {
                int indexRandom = (int)random()%(arrRandom.count);
                AnswerModel *model = array[indexRandom];
                [arr addObject:model];
                [arrRandom removeObjectAtIndex:indexRandom];
            }
        }
            break;
        case 4:{//专项练习
            for (int i=0; i<array.count; i++) {
                AnswerModel *model = array[i];
                if ([model.sid isEqualToString:_number]) {
                    [arr addObject:model];
                }
            }
        }
            break;
        case 5:{//仿真模拟考试
            [arrRandom addObjectsFromArray:array];
            for (int i=0; i<100; i++) {
                int indexRandom = (int)random()%(arrRandom.count);
                AnswerModel *model = array[indexRandom];
                [arr addObject:model];
                [arrRandom removeObjectAtIndex:indexRandom];
            }
            
            //改变导航栏样式
            [self creatNavBtn];
            //显示计时器
            [self creatTimeLabel];
        }
            break;
        case 7:{//我的错题
            NSArray *midArray = [QuestionCollectManager getWrongQuestion];
            for (int i=0; i<array.count; i++) {
                AnswerModel *model = array[i];
                for (int j=0; j<midArray.count; j++) {
                    if ([model.mid isEqualToString:midArray[j]]) {
                        [arr addObject:model];
                        continue;
                    }
                }
            }
            
            //在导航栏增加错题清空按钮
            [self creatWrongQuestionClear];
        }
            break;
        case 8:{//我的收藏
            NSArray *midArray = [QuestionCollectManager getCollectQuestion];
            for (int i=0; i<array.count; i++) {
                AnswerModel *model = array[i];
                for (int j=0; j<midArray.count; j++) {
                    if ([model.mid isEqualToString:midArray[j]]) {
                        [arr addObject:model];
                        continue;
                    }
                }
            }
        }
            break;
        default:
            break;
            
    }
    
    //调用AnswerScrollView
    _anScrollView = [[AnswerScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-75) withDataArray:arr];
    [self.view addSubview:_anScrollView];
}

//答题界面工具栏方法
-(void)creatToolBar{
    //新建下方工具栏view
    UIView *tbView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64-75, self.view.frame.size.width, 75)];
    tbView.backgroundColor = [UIColor whiteColor];
    
    NSArray *tbArray = @[@"查看答案",@"收藏本题"];
    //新建view上的button
    for (int i=0; i<3; i++) {
        //模拟考试界面没有“查看答案”按钮
        if ((_answerType==5||_answerType==6)&&i==1){
            continue;
        }else{
            //设置button
            UIButton *tbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tbBtn.frame = CGRectMake(self.view.frame.size.width/3*i+self.view.frame.size.width/6-18, 10, 36, 36);
            //设置图片
            [tbBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",16+i]] forState:UIControlStateNormal];
            //设置选中的高亮图片
            [tbBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-2.png",16+i]] forState:UIControlStateHighlighted];
            //
            tbBtn.tag = 301+i;
            //
            [tbBtn addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
            
            //设置label
            UILabel *tbLabel = [[UILabel alloc]initWithFrame:CGRectMake(tbBtn.center.x-30, 50, 60, 20)];
            //
            tbLabel.textAlignment = NSTextAlignmentCenter;
            tbLabel.font = [UIFont systemFontOfSize:13];
            //第一个按钮的设计
            if (i==0) {
                tbLabel.text = [NSString stringWithFormat:@"%d/%lu",_anScrollView.currentPage+1,(unsigned long)_anScrollView.dataArrry.count];
                //*********************
                changeLabel = tbLabel;
                //*********************
                
            }else{
                tbLabel.text = tbArray[i-1];
            }
            
            //第三个按钮的设计（从我的收藏进，将我的收藏改为解除收藏）
            if (i==2&&_answerType==8) {
                tbLabel.text = @"取消收藏";
            }
            
            [tbView addSubview:tbLabel];
            [tbView addSubview:tbBtn];
        }

    }
    [self.view addSubview:tbView];
}

//改变导航栏样式
-(void)creatNavBtn{
    //新建导航栏左按键
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]init];
    //按键标题
    [leftItem setTitle:@"返回"];
    //设置target
    [leftItem setTarget:self];
    //设置点击方法
    [leftItem setAction:@selector(clickLeftItem)];
    //新建的左按键添加到导航栏左按键位置
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]init];
    [rightItem setTitle:@"交卷"];
    [rightItem setTarget:self];
    [rightItem setAction:@selector(clickRightItem)];
    [self.navigationItem setRightBarButtonItem:rightItem];
}
//点击导航栏左按键
-(void)clickLeftItem{
    UIAlertController *leftAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定离开考试吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okeyAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [leftAlert addAction:cancelAction];
    [leftAlert addAction:okeyAction];
    
    [self presentViewController:leftAlert animated:YES completion:nil];
    
}
//点击导航栏右按键
-(void)clickRightItem{
    UIAlertController *rightAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要交卷吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelRAcion = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okeyRAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *actionRight){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [rightAlert addAction:cancelRAcion];
    [rightAlert addAction:okeyRAction];
    
    [self presentViewController:rightAlert animated:YES completion:nil];
}
//导航栏计时器
-(void)creatTimeLabel{
    _testTime = 2700;

    _testTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(testRunTime) userInfo:nil repeats:YES];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 64)];
    _timeLabel.text = @"45:00";
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:_timeLabel];
}
//倒计时
-(void)testRunTime{
    _testTime = _testTime - 1;
    _timeLabel.text = [NSString stringWithFormat:@"%d:%d",_testTime/60,_testTime%60];
    NSLog(@"%@",_timeLabel.text);
}
//画面消失后关闭计时器
-(void)viewDidDisappear:(BOOL)animated{
    [_testTimer setFireDate:[NSDate distantFuture]];
}

//在导航栏增加错题清空按钮
-(void)creatWrongQuestionClear{
    UIBarButtonItem *wrongClear = [[UIBarButtonItem alloc]init];
    [wrongClear setTitle:@"清空错题"];
    [wrongClear setTarget:self];
    [wrongClear setAction:@selector(clearWrongQuestion)];
    [self.navigationItem setRightBarButtonItem:wrongClear];
}
//清空我的错题
-(void)clearWrongQuestion{
    UIAlertController *clearAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要把错题全部清空吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okeyAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *actionRight){
        [QuestionCollectManager clearWrongQuestion];
        NSLog(@"%@",@"quxiao");
    }];
    
    [clearAlert addAction:cancelAction];
    [clearAlert addAction:okeyAction];
    
    [self presentViewController:clearAlert animated:YES completion:nil];
}

//抽屉视图初始化：SheetView
-(void)creatSheetView{
    //视图初始化
    _sheetView = [[SheetView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-100) withSuperView:self.view andQuestionCount:(int)_anScrollView.dataArrry.count];
    
    //********给_sheetView的代理设置为当前（很关键）********
    _sheetView.svDelegate = self;
    //添加视图
    [self.view addSubview:_sheetView];
}

//********实现代理方法********
#pragma mark - delegete
-(void)SheetViewClick:(int)index{
    //新建并接受_anScrollView对象
    UIScrollView *scrollView = _anScrollView->_scrollView;
    //给_anScrollView的contentOffset设置
    scrollView.contentOffset=CGPointMake((index-1)*scrollView.frame.size.width, 0);
    //调用_anScrollView的代理方法
    [scrollView.delegate scrollViewDidEndDecelerating:scrollView];
}

//*********************
//实现AnswerScrollView的委托方法
-(void)changeLabelText:(int)titleNum{
    changeLabel.text = [NSString stringWithFormat:@"%d/%lu",titleNum+1,(unsigned long)_anScrollView.dataArrry.count];;
}
//*********************


//点击收藏的提示VIEW
-(void)creatCollectView{
    _collectView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-30-64, 100, 100)];
    _collectView.backgroundColor = [UIColor grayColor];
    _collectView.layer.masksToBounds = YES;
    _collectView.layer.cornerRadius = 10;
    _collectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, 100, 24)];
    _collectLabel.backgroundColor = [UIColor grayColor];
//    _collectLabel.text = @"已收藏";
    _collectLabel.textAlignment = NSTextAlignmentCenter;
    _collectLabel.textColor = [UIColor whiteColor];
    [_collectView addSubview:_collectLabel];
    _collectView.alpha = 0;
    [self.view addSubview:_collectView];
}
//下方工具栏按钮点击事件
-(void)clickToolBar:(UIButton *)btn{
    
    switch (btn.tag) {
        case 301:{//抽屉视图：查看题号
            //做持续时间0.3秒的动作
            [UIView animateWithDuration:0.3 animations:^{
                //改变_sheetView的位子，让其显示
                _sheetView.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
                //改变_backView的alpha值让背景颜色显现
                _sheetView->_backView.alpha = 0.8;
                //改变_sheetView的alpha值让_sheetView显现
                _sheetView.alpha = 1;
            }];
            [_sheetView clickBtnColor:_anScrollView.currentPage];
        }
            break;
        case 302:{//查看答案
            if ([_anScrollView.hadAnswerArray[_anScrollView.currentPage] intValue]!=0) {
                return;
            }else{
                //获取当前题目的数据
                AnswerModel *model = [_anScrollView.dataArrry objectAtIndex:_anScrollView.currentPage];
                NSString *answer = model.manswer;
                char an = [answer characterAtIndex:0];
                //设置已答状态
                [_anScrollView.hadAnswerArray replaceObjectAtIndex:_anScrollView.currentPage withObject:[NSString stringWithFormat:@"%d",an-'A'+1]];
                _anScrollView.wrongOrRightArray[_anScrollView.currentPage] = @"1";
                [_anScrollView reloadData];
            }
        }
            break;
        case 303:{//收藏本题
            
            //获取当前题目的数据
            AnswerModel *model = [_anScrollView.dataArrry objectAtIndex:_anScrollView.currentPage];

            //从我的收藏进页面点击是移除收藏
            if (_answerType==8) {
                _collectLabel.text = @"已取消";
                _collectView.alpha = 1;
                [QuestionCollectManager removeCollectQuestion:model.mid];
                
                //画面持续一秒后逐渐消失
                [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                    _collectView.alpha = 0;
                } completion:nil];
            }else{
                _collectLabel.text = @"已收藏";
                _collectView.alpha = 1;
                //判断没收藏过的进行收藏
                if (![QuestionCollectManager selectCollectQuestiong:model.mid]) {
                    [QuestionCollectManager addCollectQuestion:model.mid];
                }
                
                //画面持续一秒后逐渐消失
                [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                    _collectView.alpha = 0;
                } completion:nil];
            }
            
        }
            break;
            
        default:
            break;
    }
}

//获取开始点击屏幕时的点击点
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //新建touch对象，获取touches集合
    UITouch *touch = [touches anyObject];
    //获取主屏幕的屏幕点击点
    point = [touch locationInView:self.view];
}
//点击并离开屏幕后动作
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //判断点击点的位子隐藏_sheetView和_backView
    if (point.y<100) {
        [UIView animateWithDuration:0.3 animations:^{
            _sheetView.alpha = 0;
            _sheetView->_backView.alpha = 0;
        }];
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
