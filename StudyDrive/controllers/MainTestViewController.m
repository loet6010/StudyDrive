//
//  MainTestViewController.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/13.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "MainTestViewController.h"
#import "AnswerViewController.h"

@interface MainTestViewController ()

{
    AnswerViewController *_avCon;
}
@end

@implementation MainTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //改变button的圆角
    _buttonTest1.layer.masksToBounds = YES;
    _buttonTest1.layer.cornerRadius = 8;
    _buttonTest2.layer.masksToBounds = YES;
    _buttonTest2.layer.cornerRadius = 8;
    
    
    
    [self.navigationItem setTitle:@"仿真模拟考试"];
}

- (IBAction)clickButton:(UIButton *)sender {
    
    switch (sender.tag) {
        case 501:
        {
            _avCon = [[AnswerViewController alloc]init];
            //仿真模拟考试
            _avCon.answerType = 5;
            //push到AnswerViewController
            [self.navigationController pushViewController:_avCon animated:YES];
        }
            break;
            
        default:
            break;
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
