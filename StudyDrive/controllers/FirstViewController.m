//
//  FirstViewController.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/2.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstTableViewCell.h"
#import "TestSelectViewController.h"
#import "MyDataManager.h"
#import "AnswerViewController.h"
#import "MainTestViewController.h"
#import "QuestionCollectManager.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景颜色为白色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏下起算纵坐标为0
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //初始化label的数组
    _dataArray = @[@"章节练习",@"顺序练习",@"随机练习",@"专项练习",@"仿真模拟"];
    
    //设置导航栏的标题
    [self.navigationItem setTitle:@"科目一 理论考试"];

    //调用初始化tableView方法
    [self creatTableView];
    //调用view的初始化方法
    [self creatView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化tableView方法
-(void)creatTableView{
    //设置tableView的起始以及大小
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250) style:UITableViewStylePlain];
    //设置代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //tableview的拉动效果关闭
    _tableView.scrollEnabled = NO;
    //添加视图
    [self.view addSubview:_tableView];
}

//初始化view方法
-(void)creatView{
    //初始化label对象
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64-140, self.view.frame.size.width, 30)];
    //设置字体居中
    label.textAlignment = NSTextAlignmentCenter;
    //设置label文字
    label.text = @"······················我的考试分析······················";
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    //初始化下边栏
    NSArray *arr = @[@"我的错题",@"我的收藏",@"我的成绩",@"练习统计"];
    for (int i=0; i<4; i++) {
        //设置button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(self.view.frame.size.width/4*i+self.view.frame.size.width/8-30, self.view.frame.size.height-64-100, 60, 60);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",12+i]] forState:UIControlStateNormal];
        //button添加点击事件
        btn.tag = i+201;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //将button添加到视图
        [self.view addSubview:btn];
        
        //设置label
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4*i+self.view.frame.size.width/8-30, self.view.frame.size.height-64-35, 60, 20)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont boldSystemFontOfSize:13];
        lab.textColor = [UIColor grayColor];
        lab.text = arr[i];
        [self.view addSubview:lab];
    }

}

//点击下方button
-(void)btnClick:(UIButton *)btn{
    UIBarButtonItem *fvcItem = [[UIBarButtonItem alloc]init];
    fvcItem.title = @"";
    switch (btn.tag) {
        case 201://我的错题
        {
            NSArray *wrongArray = [QuestionCollectManager getWrongQuestion];
            
            if (wrongArray.count>0) {
                AnswerViewController *avController = [[AnswerViewController alloc]init];
                //设置导航栏标题
                avController.myTitle = @"我的错题";
                //设置返回样式
                [self.navigationItem setBackBarButtonItem:fvcItem];
                //将练习模式：7，我的错题 传值给AnswerViewController
                avController.answerType = 7;
                
                //导航栏PUSH到下一个view
                [self.navigationController pushViewController:avController animated:YES];
            }else{
                UIAlertController *noWrongAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前没有错题" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                
                [noWrongAlert addAction:sureAction];
                [self presentViewController:noWrongAlert animated:YES completion:nil];
            }
            
            
        }
            break;
        case 202://我的收藏
        {
            NSArray *collectArray = [QuestionCollectManager getCollectQuestion];
            
            if (collectArray.count>0) {
                AnswerViewController *avController = [[AnswerViewController alloc]init];
                //设置导航栏标题
                avController.myTitle = @"我的收藏";
                //设置返回样式
                [self.navigationItem setBackBarButtonItem:fvcItem];
                //将练习模式：8，我的收藏 传值给AnswerViewController
                avController.answerType = 8;
                
                //导航栏PUSH到下一个view
                [self.navigationController pushViewController:avController animated:YES];
            }else{
                UIAlertController *noWrongAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前没有收藏" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                
                [noWrongAlert addAction:sureAction];
                [self presentViewController:noWrongAlert animated:YES completion:nil];
            }
            
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - tableview delegate
//table的分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//table的表格行数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
//table的表格行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//table的cell设置
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"FirstTableViewCell";
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellId owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row+7]];
    cell.myLabel.text = _dataArray[indexPath.row];
    return cell;
}
//table的跳转方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIBarButtonItem *fvcItem = [[UIBarButtonItem alloc]init];
    fvcItem.title = @"";
    
    switch (indexPath.row) {
        case 0://章节练习
        {
            TestSelectViewController *tsCon = [[TestSelectViewController alloc]init];
            
            //从MyDataManager的getData方法中得到数组值
            tsCon.dataArray = [MyDataManager getData:chapter];
            //设置导航栏标题
            tsCon.myTitle = @"章节练习";    
            //设置返回样式
            [self.navigationItem setBackBarButtonItem:fvcItem];
            //将练习模式：1，章节练习 传值给TestSelectViewController
            tsCon.myTestType = 1;
            
            //导航栏PUSH到下一个view
            [self.navigationController pushViewController:tsCon animated:YES];
        }
            break;
            
        case 1://顺序练习
        {
            AnswerViewController *avController = [[AnswerViewController alloc]init];
            //设置导航栏标题
            avController.myTitle = @"顺序练习";
            //设置返回样式
            [self.navigationItem setBackBarButtonItem:fvcItem];
            //将练习模式：2，顺序练习 传值给AnswerViewController
            avController.answerType = 2;
            
            //导航栏PUSH到下一个view
            [self.navigationController pushViewController:avController animated:YES];
        }
            break;
            
        case 2://随机练习
        {
            AnswerViewController *avController = [[AnswerViewController alloc]init];
            //设置导航栏标题
            avController.myTitle = @"随机练习";
            //设置返回样式
            [self.navigationItem setBackBarButtonItem:fvcItem];
            //将练习模式：3，随机练习 传值给AnswerViewController
            avController.answerType = 3;
            
            //导航栏PUSH到下一个view
            [self.navigationController pushViewController:avController animated:YES];
        }
            break;
        case 3://专项练习
        {
            TestSelectViewController *tsCon = [[TestSelectViewController alloc]init];
            
            //从MyDataManager的getData方法中得到数组值
            tsCon.dataArray = [MyDataManager getData:specific];
            //设置导航栏标题
            tsCon.myTitle = @"专项练习";
            //设置返回样式
            [self.navigationItem setBackBarButtonItem:fvcItem];
            //将练习模式：4，章节练习 传值给TestSelectViewController
            tsCon.myTestType = 4;
            
            //导航栏PUSH到下一个view
            [self.navigationController pushViewController:tsCon animated:YES];
        }
            break;
        case 4://模拟仿真考试
        {
            MainTestViewController *mtvCon = [[MainTestViewController alloc]init];
            
            //从MyDataManager的getData方法中得到数组值
//            tsCon.dataArray = [MyDataManager getData:specific];
            //设置导航栏标题
//            tsCon.myTitle = @"专项练习";
            //设置返回样式
            [self.navigationItem setBackBarButtonItem:fvcItem];
            //将练习模式：4，章节练习 传值给TestSelectViewController
//            tsCon.myTestType = 4;
            
            //导航栏PUSH到下一个view
            [self.navigationController pushViewController:mtvCon animated:YES];
        }
            break;
            
        default:
            break;
    }
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
