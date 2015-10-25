//
//  AnswerScrollView.m
//  StudyDrive
//
//  Created by 刘荣华 on 15/10/4.
//  Copyright © 2015年 刘荣华. All rights reserved.
//

#import "AnswerScrollView.h"
#import "AnswerTableViewCell.h"
#import "AnswerModel.h"
#import "Tools.h"
#import "AnswerViewController.h"
#import "QuestionCollectManager.h"

#define SIZE self.frame.size

@interface AnswerScrollView()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
}

@end

@implementation AnswerScrollView
{
    //左边的view
    UITableView *_leftTableView;
    //中间的view
    UITableView *_mainTableView;
    //右边的view
    UITableView *_rightTableView;
}

//页面初始化
-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)array{
    self = [super initWithFrame:frame];
    
    if (self) {
        //初始化
        _currentPage = 0;
        //dataArray数组接收题目
        _dataArrry = [[NSArray alloc]initWithArray:array];
        //答题状态数组全部置0
        _hadAnswerArray = [[NSMutableArray alloc]init];
        _wrongOrRightArray = [[NSMutableArray alloc]init];
        for (int i=0; i<_dataArrry.count; i++) {
            [_hadAnswerArray addObject:@"0"];
            [_wrongOrRightArray addObject:@"0"];
        }
        
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        _scrollView.delegate = self;
        
        _leftTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _mainTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _rightTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        
        //tableView的上下拉动效果关闭
        _leftTableView.scrollEnabled = NO;
        _mainTableView.scrollEnabled = NO;
        _rightTableView.scrollEnabled = NO;
        
        //scrollview的三页效果打开
        _scrollView.pagingEnabled = YES;
        //scrollview的回弹效果关闭
        _scrollView.bounces =  NO;
        //scrollview的底下进度条效果关闭
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        //判断页数大于1页能滑动
        if (_dataArrry.count>1) {
            _scrollView.contentSize = CGSizeMake(SIZE.width*2, 0);
        }else{
            _scrollView.contentSize = CGSizeMake(SIZE.width, 0);
        }
        
        [self creatView];
    }
    
    return self;
}

//创建View
-(void)creatView{
    _leftTableView.frame = CGRectMake(0, 0, SIZE.width, SIZE.height);
    _mainTableView.frame = CGRectMake(SIZE.width, 0, SIZE.width, SIZE.height);
    _rightTableView.frame = CGRectMake(SIZE.width*2, 0, SIZE.width, SIZE.height);
    
    [_scrollView addSubview:_leftTableView];
    [_scrollView addSubview:_mainTableView];
    [_scrollView addSubview:_rightTableView];
    
    [self addSubview:_scrollView];
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //判断页面加载
    AnswerModel *anModel = [self getTheFitModel:tableView];
    //选择题时的处理
    if ([anModel.mtype intValue]==1) {
        return 4;
    }else{
        return 2;
    }
}

//tabelview的上部View的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString *answerStr;
    //获取题目
    AnswerModel *titleModel = [self getTheFitModel:tableView];
    //选择题和判断题的题目获取区别
    if ([titleModel.mtype intValue]==1) {
        answerStr = [[Tools getAnswerWithString:titleModel.mquestion]objectAtIndex:0];
    }else{
        answerStr = titleModel.mquestion;
    }
    //题目部分VIEW的区域设置
    NSString *viewStr = [NSString stringWithFormat:@"%d.%@",[self getNumberOfQuestion:tableView andCurrentPage:_currentPage],answerStr];
    
    CGFloat headerLabelHieght = [Tools getSizeWithString:viewStr with:[UIFont systemFontOfSize:17] whitSize:CGSizeMake(tableView.frame.size.width, 64)].height;
    
    if (![titleModel.mimage isEqualToString:@""]) {
        return 80+headerLabelHieght;
    }
    return 100;
}
//tableview的上部View的设置
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *answerStr;
    //获取题目
    AnswerModel *titleModel = [self getTheFitModel:tableView];
    
    //选择题和判断题的题目获取区别
    if ([titleModel.mtype intValue]==1) {
        answerStr = [[Tools getAnswerWithString:titleModel.mquestion]objectAtIndex:0];
    }else{
        answerStr = titleModel.mquestion;
    }
    
    //题目部分VIEW的区域设置
    NSString *viewStr = [NSString stringWithFormat:@"%d.%@",[self getNumberOfQuestion:tableView andCurrentPage:_currentPage],answerStr];
    
    CGFloat headerLabelHieght = [Tools getSizeWithString:viewStr with:[UIFont systemFontOfSize:17] whitSize:CGSizeMake(tableView.frame.size.width, 64)].height;
    
    //新建一个label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SIZE.width-20, headerLabelHieght)];
    //设置label的字体大小
    titleLabel.font = [UIFont systemFontOfSize:16];
    //设置label的自动换行
    titleLabel.numberOfLines = 0;

    //
    UIView *view;
    
    //给题目添加题号
    titleLabel.text = viewStr;
    
    if (![titleModel.mimage isEqualToString:@""]) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12+titleLabel.frame.size.height, SIZE.width-20,65)];
        NSMutableString *_trangGiftoPng = [NSMutableString stringWithString:titleModel.mimage];
        [_trangGiftoPng replaceCharactersInRange:NSMakeRange(4,3) withString:@"png"];
        [imageView setImage:[UIImage imageNamed:_trangGiftoPng]];
        //图片自动缩放适应view
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE.width,80+titleLabel.frame.size.height)];
        [view addSubview:titleLabel];
        [view addSubview:imageView];
    }else{
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE.width,100)];
        [view addSubview:titleLabel];
    }
    
    return view;
}

//cell选中时的处理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取题号
    int qNumber = [self getNumberOfQuestion:tableView andCurrentPage:_currentPage];
    //已经点过的题目_hadAnswerArray设置为1，2，3，4
    if ([_hadAnswerArray[qNumber-1] intValue]!=0) {
        return;
    }else{
        [_hadAnswerArray replaceObjectAtIndex:qNumber-1 withObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
    }
    
    
    //*********已答并答错的题目存储错题***********
    AnswerModel *anModel = [self getTheFitModel:tableView];
    //判断题时对答案的处理
    if ([anModel.mtype intValue]==2){
        //判断题将“对”设为“A”，错设为“B”
        if ([anModel.manswer isEqualToString:@"对"]||[anModel.manswer isEqualToString:@"A"]) {
            anModel.manswer = @"A";
        }
        else{
            anModel.manswer = @"B";
        }
    }
    if (![anModel.manswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+(int)indexPath.row]]) {
        //本地数组没有将进行存储
        if (![QuestionCollectManager selectWrongQuestiong:anModel.mid]) {
            [QuestionCollectManager addWrongQuestion:anModel.mid];
        }
    }
    
    
    //刷新页面
    [self reloadData];
}

//scrollview的中间tableView的设置
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"AnswerTableViewCell";
    AnswerTableViewCell *atCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    //初始化cell
    if (atCell==nil) {
        atCell = [[[NSBundle mainBundle]loadNibNamed:cellId owner:self options:nil]lastObject];
        atCell.numberLabel.layer.masksToBounds = YES;
        atCell.numberLabel.layer.cornerRadius = 10;
    }
    
    //取消选中效果
    atCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置cell选项
    atCell.numberLabel.text = [NSString stringWithFormat:@"%c",(char)('A'+indexPath.row)];
    //判断页面加载
    AnswerModel *anModel = [self getTheFitModel:tableView];

    NSArray *judgeArr = @[@"正确",@"错误"];
    //选择题时的处理
    if ([anModel.mtype intValue]==1) {
        atCell.answerLabel.text = [[Tools getAnswerWithString:anModel.mquestion]objectAtIndex:indexPath.row+1];
    }
    //判断题
    else{
        atCell.answerLabel.text = judgeArr[indexPath.row];
    }
    
    //获取题号
    int qNumber = [self getNumberOfQuestion:tableView andCurrentPage:_currentPage];
    //判断题目有没有答过
    if ([_hadAnswerArray[qNumber-1] intValue]!=0) {
        
        //判断题时对答案的处理
        if ([anModel.mtype intValue]==2){
            //判断题将“对”设为“A”，错设为“B”
            if ([anModel.manswer isEqualToString:@"对"]||[anModel.manswer isEqualToString:@"A"]) {
                anModel.manswer = @"A";
            }
            else{
                anModel.manswer = @"B";
            }
        }
        
        //点击后将正确答案显示为对勾
        if ([anModel.manswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+(int)indexPath.row]]) {
            atCell.numberImage.hidden = NO;
            atCell.numberImage.image = [UIImage imageNamed:@"19.png"];
        }
        //选择错误后将选择项显示为叉
        else if (![anModel.manswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+(int)indexPath.row]]&&indexPath.row==[_hadAnswerArray[qNumber-1] intValue]-1) {
            atCell.numberImage.hidden = NO;
            atCell.numberImage.image = [UIImage imageNamed:@"20.png"];
            //该题打错状态设置为“1”
            _wrongOrRightArray[qNumber-1] = @"1"; 
        }
        else{
            atCell.numberImage.hidden = YES;
        }
    }else{
        atCell.numberImage.hidden = YES;
    }
    
    return atCell;
}

//scrollview的下部View的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //获取答案解析
    AnswerModel *keyModel = [self getTheFitModel:tableView];
    NSString *keyStr = keyModel.mdesc;
    NSString *textStr = [NSString stringWithFormat:@"答案解析:\n%@",keyStr];
    
    //获取文本高度
    CGFloat textHeight = [Tools getSizeWithString:textStr with:[UIFont systemFontOfSize:16] whitSize:CGSizeMake(tableView.frame.size.width-20, 400)].height+20;
    
    return textHeight;
}
//scrollview的下部View的设置
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //获取答案解析
    AnswerModel *keyModel = [self getTheFitModel:tableView];
    NSString *keyStr = keyModel.mdesc;
    NSString *textStr = [NSString stringWithFormat:@"答案解析:\n%@",keyStr];
    
    //获取文本高度
    CGFloat textHeight = [Tools getSizeWithString:textStr with:[UIFont systemFontOfSize:16] whitSize:CGSizeMake(tableView.frame.size.width-20, 400)].height+20;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE.width, textHeight)];
    //新建一个label
    UILabel *keyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SIZE.width-20, textHeight-20)];
    //设置label的字体大小
    keyLabel.font = [UIFont systemFontOfSize:16];
    keyLabel.textColor = [UIColor greenColor];

    keyLabel.numberOfLines = 0;
    keyLabel.text = textStr;
    
    [view addSubview:keyLabel];
    
    //获取题号
    int qNumber = [self getNumberOfQuestion:tableView andCurrentPage:_currentPage];
    //已答并打错的题目才显示答案解析
    if ([_hadAnswerArray[qNumber-1] intValue]!=0 && [_wrongOrRightArray[qNumber-1] intValue]==1) {
        
        return view;
    }
    
    return nil;
}

//model的取得方法
-(AnswerModel *)getTheFitModel:(UITableView *)tableView{
    AnswerModel *asModel;
    if (_dataArrry.count>1) {
        if (tableView==_leftTableView&&_currentPage==0) {
            asModel = _dataArrry[_currentPage];
        }else if (tableView==_leftTableView&&_currentPage>0){
            asModel = _dataArrry[_currentPage-1];
        }else if (tableView==_mainTableView&&_currentPage==0){
            asModel = _dataArrry[_currentPage+1];
        }else if (tableView==_mainTableView&&_currentPage>0&&_currentPage<_dataArrry.count-1){
            asModel = _dataArrry[_currentPage];
        }else if (tableView==_mainTableView&&_currentPage==_dataArrry.count-1){
            asModel = _dataArrry[_currentPage-1];
        }else if (tableView==_rightTableView&&_currentPage==_dataArrry.count-1){
            asModel = _dataArrry[_currentPage];
        }else if (tableView==_rightTableView&&_currentPage<_dataArrry.count-1){
            asModel = _dataArrry[_currentPage+1];
        }
    }else{//只有一题的时候只返回一题
        asModel = _dataArrry[0];
    }
    
    
    return asModel;
}

//题号的取得方法
-(int)getNumberOfQuestion:(UITableView *)tableView andCurrentPage:(int)page{
    if (_dataArrry.count>1) {
        if (tableView==_leftTableView&&page==0) {
            return 1;
        }else if (tableView==_leftTableView&&page>0){
            return page;
        }else if (tableView==_mainTableView&&page==0){
            return 2;
        }else if (tableView==_mainTableView&&page>0&&page<_dataArrry.count-1){
            return page+1;
        }else if (tableView==_mainTableView&&page==_dataArrry.count-1){
            return page;
        }else if (tableView==_rightTableView&&page==_dataArrry.count-1){
            return page+1;
        }else if (tableView==_rightTableView&&page<_dataArrry.count-1){
            return page+2;
        }
    }else{//只有一题的时候只返回题号为“1”
        return 1;
    }
    
    return 0;
}

//scrollview调用结束后的方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint currentOffset = scrollView.contentOffset;
    int page = (int)currentOffset.x/SIZE.width;
    
    //正常范围滑动时的处理
    if (page<_dataArrry.count-1&&page>0) {
        //_scrollView的可移动范围
        _scrollView.contentSize = CGSizeMake(currentOffset.x+SIZE.width*2, SIZE.height);
        
        //scrollview的三个页面重新设定
        _leftTableView.frame = CGRectMake(currentOffset.x-SIZE.width, 0, SIZE.width, SIZE.height);
        _mainTableView.frame = CGRectMake(currentOffset.x, 0, SIZE.width, SIZE.height);
        _rightTableView.frame = CGRectMake(currentOffset.x+SIZE.width, 0, SIZE.width, SIZE.height);
        
    }
    
    //跳转到第一题时的处理
    else if(page<_dataArrry.count-1&&page==0){
        //_scrollView的可移动范围
        _scrollView.contentSize = CGSizeMake(currentOffset.x+SIZE.width*2, 0);
        
        //scrollview的三个页面重新设定
        _leftTableView.frame = CGRectMake(currentOffset.x, 0, SIZE.width, SIZE.height);
        _mainTableView.frame = CGRectMake(currentOffset.x+SIZE.width, 0, SIZE.width, SIZE.height);
        _rightTableView.frame = CGRectMake(currentOffset.x+SIZE.width*2, 0, SIZE.width, SIZE.height);
    }
    
    //跳转到最后一题时的处理
    else if(page==_dataArrry.count-1){
        //_scrollView的可移动范围
        _scrollView.contentSize = CGSizeMake(currentOffset.x+SIZE.width, 0);
        
        //scrollview的三个页面重新设定
        _leftTableView.frame = CGRectMake(currentOffset.x-SIZE.width*2, 0, SIZE.width, SIZE.height);
        _mainTableView.frame = CGRectMake(currentOffset.x-SIZE.width, 0, SIZE.width, SIZE.height);
        _rightTableView.frame = CGRectMake(currentOffset.x, 0, SIZE.width, SIZE.height);
    }

    //设置当前页的页数
    _currentPage = page;
    //重新加载数据
    [self reloadData];
    
    //*********************
    //给协议传值
    [_clDelegate changeLabelText:_currentPage];
    //*********************
}

//重新加载数据方法
-(void)reloadData{
    [_leftTableView reloadData];
    [_mainTableView reloadData];
    [_rightTableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
