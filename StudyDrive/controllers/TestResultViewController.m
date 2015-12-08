//
//  TestResultViewController.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/12/8.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "TestResultViewController.h"

@interface TestResultViewController ()

@end

@implementation TestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *kakuninButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    
    kakuninButton.backgroundColor = [UIColor redColor];
    [kakuninButton setTitle:@"确定" forState:UIControlStateNormal];
    kakuninButton.layer.masksToBounds = YES;
    kakuninButton.layer.cornerRadius = 8;
    
    [kakuninButton addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:kakuninButton];
}

- (void)clickBtn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)testResultLabel:(NSUInteger)wrongCount andHadnot:(NSUInteger)hadNotCount {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
    label.backgroundColor = [UIColor greenColor];
    
    label.font = [UIFont systemFontOfSize:16];
    
    NSUInteger testResult = 100 - wrongCount - hadNotCount;
    
    label.text = [NSString stringWithFormat:@"本次成绩:%lu分",(unsigned long)testResult];
    
    [self.view addSubview:label];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
