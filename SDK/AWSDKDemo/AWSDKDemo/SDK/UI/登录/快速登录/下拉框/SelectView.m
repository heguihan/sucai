//
//  SelectView.m
//  testFunction
//
//  Created by admin on 2020/11/30.
//

#import "SelectView.h"
#import "SelectTableViewCell.h"

@interface SelectView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)UIView *redview;
@property(nonatomic, assign)CGRect currentFrame;
//@property(nonatomic, strong)NSTimer *timer;
@end

@implementation SelectView

+(instancetype)factory_SelectviewWithFrame:(CGRect)frame
{
    
    frame.size.height = 0;
    SelectView *selectv = [[SelectView alloc]initWithFrame:frame];
    return selectv;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self configTableviewWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)configTableviewWithFrame:(CGRect)frame
{
//    self.hidden = YES;
//    frame.size.height = 0;
//    self.frame = frame;

    [self addSubview:self.tableview];
    self.clipsToBounds = YES;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TFWidth, TFHeight/2.0)];
    headerView.backgroundColor =RGBA(236, 239, 246, 1);
    self.tableview.tableHeaderView = headerView;
    self.tableview.tableFooterView = [UIView new];
}

-(void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    CGRect frame = self.frame;
    NSInteger count = dataArr.count>4?4:dataArr.count;
    frame.size.height = count * TFHeight+TFHeight/2.0;
    self.frame = frame;
    CGRect bounds = self.bounds;
    bounds.origin.y += TFHeight/2.0;
    [self.tableview reloadData];
    
    if (dataArr.count<=0) {
        [self.delegate didSelectWithIndex:100 selectedDic:@{}];
    }
}

#pragma tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TFHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AWLog(@"selected indexpath=%ld",indexPath.row);
    NSDictionary *userinfo = self.dataArr[indexPath.row];
    [self.delegate didSelectWithIndex:indexPath.row selectedDic:userinfo];
}
#pragma tableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [UITableViewCell new];
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectcell"];
    if (!cell) {
        cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectcell"];
    }
    cell.selectionStyle = 0;
    NSDictionary *iconDict =  @{LOGIN_USER:@"AWSDK.bundle/zhanghao2.png",LOGIN_PHONE:@"AWSDK.bundle/shouji2.png",LOGIN_VISITOR:@"AWSDK.bundle/huojian2.png",LOGIN_GOOGLE:@"AWSDK.bundle/google2.png",LOGIN_FACEBOOK:@"AWSDK.bundle/facebook2.png"};
    NSDictionary *userinfo = self.dataArr[indexPath.row];
    NSString *imageName = [iconDict objectForKey:userinfo[@"type"]];
    cell.iconImageV.image = [UIImage imageNamed:imageName];
    cell.lab.text = userinfo[@"show_account"];
    
    __weak __typeof__(self) weakSelf = self;
    [cell setDeleteBlock:^{
        AWLog(@"delete");
        NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:weakSelf.dataArr];
        [mutableArr removeObjectAtIndex:indexPath.row];
        weakSelf.dataArr = [mutableArr copy];
    }];
    return cell;
}



-(void)show
{
    [UIView animateWithDuration:1.0 animations:^{
//        CGRect frame = self.frame;
//        frame.size.height = self.frame,si
        self.hidden = NO;
        self.frame = self.currentFrame;
        
    }];
}
-(void)hidden
{
    [UIView animateWithDuration:1.0 animations:^{
        CGRect frame = self.frame;
        frame.size.height = 0;
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
#pragma Lazy
-(UITableView *)tableview
{
    if (!_tableview) {
        CGRect newframe = self.currentFrame;
        newframe.origin.x = 0;
        newframe.origin.y = 0;
        _tableview = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
//        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 150) style:UITableViewStylePlain];
        _tableview.tableFooterView = [UIView new];
        [_tableview registerClass:[SelectTableViewCell class] forCellReuseIdentifier:@"selectcell"];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = RGBA(236, 239, 246, 1);
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.bounces = NO;
        _tableview.showsVerticalScrollIndicator = NO;
    }
    return _tableview;
}


@end
