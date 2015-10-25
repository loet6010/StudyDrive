//
//  ViewController.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/9/30.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "ViewController.h"
#import "SelectView.h"
#import "FirstViewController.h"

@interface ViewController ()
{
    SelectView *_selectView;
    
    __weak IBOutlet UIButton *selectBtn;
}

@end

@implementation ViewController

//关联SB上的button
- (IBAction)click:(UIButton *)sender {
    //改变导航栏返回样式
    UIBarButtonItem *vcItem = [[UIBarButtonItem alloc]init];
    vcItem.title = @"";
    
    //根据tag值判断是点击了那个botton
    switch (sender.tag) {
        case 100:{
            //渐变唤出
            [UIView animateWithDuration:0.3 animations:^{
                _selectView.alpha = 1;
            }];
        }
            break;
        //科目一
        case 101:{
            //改变导航栏的返回样式
            [self.navigationItem setBackBarButtonItem:vcItem];
            //导航栏push到下一个view
            [self.navigationController pushViewController:[[FirstViewController alloc]init] animated:YES];
        }
            break;
        case 102:{
            
        }
            break;
        case 103:{
            
        }
            break;
        //科目四
        case 104:{
            //改变导航栏的返回样式
            [self.navigationItem setBackBarButtonItem:vcItem];
            //导航栏push到下一个view
            [self.navigationController pushViewController:[[FirstViewController alloc]init] animated:YES];
        }
            break;
        case 105:{
            
        }
            break;
        case 106:{
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //子画面初始化
    _selectView = [[SelectView alloc]initWithFrame:self.view.frame andBtn:selectBtn];
    _selectView.alpha = 0;
    [self.view addSubview:_selectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
