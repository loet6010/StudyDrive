//
//  TestSelectViewController.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/3.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "TestSelectViewController.h"
#import "TestSelectTableViewCell.h"
#import "TestSelectModel.h"
#import "AnswerViewController.h"
#import "SpecificTestModel.h"

@interface TestSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    //记录并传值用章节号
    NSMutableArray *_typeOneArray;
    //记录并传值用专项号
    NSMutableArray *_typeFourArray;
}

@end

@implementation TestSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tableview背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏下起算纵坐标为0
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置导航栏的标题
    [self.navigationItem setTitle:_myTitle];
    //数组初始化
    _typeOneArray = [[NSMutableArray alloc]init];
    _typeFourArray = [[NSMutableArray alloc]init];
    //调用初始化方法
    [self creatTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化tableView方法
-(void)creatTableView{
    //设置tableView的起始以及大小
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    //设置代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //添加视图
    [self.view addSubview:_tableView];
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
    return 80;
}
//table的cell设置
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"TestSelectTableViewCell";
    TestSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellId owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.numberLabel.layer.masksToBounds = YES;
        cell.numberLabel.layer.cornerRadius = 8;
    }
    
    //设置章节练习列表number号
//    [cell.numberLabel setText:tsModel.pid];
    [cell.numberLabel setText:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
    
    //设置练习列表标题
    if (_myTestType == 1) {//章节练习
        TestSelectModel *tsModel = _dataArray[indexPath.row];
        [cell.titleLabel setText:tsModel.pname];
        [_typeOneArray addObject:tsModel.pid];
        
    }else if(_myTestType == 4){//专项练习
        SpecificTestModel *stModel = _dataArray[indexPath.row];
        [cell.titleLabel setText:stModel.sname];
        [_typeFourArray addObject:stModel.sid];
    }
    
    
    return cell;
}

//tableView的选中跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
    item.title = @"";
    [self.navigationItem setBackBarButtonItem:item];
    
    AnswerViewController *avController = [[AnswerViewController alloc]init];
    
    //设置练习列表标题
    if (_myTestType == 1) {//章节练习
        //选中章节，将章节序号传值给AnswerViewController
        avController.number = _typeOneArray[indexPath.row];
        //将练习模式：1，章节练习 传值给AnswerViewController
        avController.answerType = 1;
        //设置导航栏标题
        avController.myTitle = @"章节练习";
    }else if(_myTestType == 4){//专项练习
        //选中章节，将专项练习序号传值给AnswerViewController
        avController.number = _typeFourArray[indexPath.row];
        //将练习模式：1，章节练习 传值给AnswerViewController
        avController.answerType = 4;
        //设置导航栏标题
        avController.myTitle = @"专项练习";
    }
    
    
    
    [self.navigationController pushViewController:avController animated:YES];
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
