//
//  BannerView.m
//  轮播图(循环和自动)
//
//  Created by 裴铎 on 2018/3/9.
//  Copyright © 2018年 裴铎. All rights reserved.
//

#import "AdLabelView.h"


#define ADSIZE   12
#define ADTEXTCOLOR  [UIColor whiteColor]

@interface AdLab()

@end

@implementation AdLab

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentLeft;
        self.font = [UIFont systemFontOfSize:16];
    }
    return self;
}
@end

/**
 定时器 用来自动播放图片
 */
static NSTimer * mv_timer;
static const double delaytime = 2.0;
static const double animationtime = 0.5;
/**
 定义私有变量
 遵守滚动式图的代理方法 实现拖拽效果
 */
@interface AdLabelView () <
UIScrollViewDelegate>{
    
    //banNerView的宽和高 私有成员变量用下划线开头(书写习惯)
    CGFloat mv_width;
    CGFloat mv_height;
}
/**
 scrollView
 */
@property (nonatomic , strong) UIScrollView * mainScrollView;
@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation AdLabelView



- (id)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)dataArray{
    //调用父类方法
    self = [super initWithFrame:frame];
        mv_width =frame.size.width;
        mv_height = frame.size.height;
    
    //判断是否是本类对象调用 并 外界传入的图片数量足够滚动
    if (self && dataArray.count >= 2) {
        
        //图片数组 1 2 3 4 5 6 把外界传入的图片数组赋值给本类的数组
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        
        [self.dataArray addObject:dataArray.firstObject];
        [self.dataArray insertObject:dataArray.lastObject atIndex:0];

        for (UIView *subview in self.subviews) {
            [subview removeFromSuperview];
        }
        [self addSubview:self.mainScrollView];
        
        //初始化时加载定时器
        [self addTimer];
    }
    
    if (dataArray.count == 1) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mv_width, mv_height)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = ADTEXTCOLOR;
        lab.font = FONTSIZE(ADSIZE);
        [self addSubview:lab];
        [lab setAttributedText:dataArray[0]];
    }

    return self;
}


-(void)updateDataWithArr:(NSMutableArray *)dataArr
{
    self.dataArray = dataArr;
    [self.dataArray addObject:dataArr.firstObject];
    [self.dataArray insertObject:dataArr.lastObject atIndex:0];
    [self.mainScrollView removeFromSuperview];
    self.mainScrollView = nil;
    [self addSubview:self.mainScrollView];
}

- (void)addTimer{
    if (mv_timer) {
        return;
    }
    mv_timer = [NSTimer scheduledTimerWithTimeInterval:delaytime target:self selector:@selector(timerFUNC:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:mv_timer forMode:NSRunLoopCommonModes];
}



#pragma mark --定时器触发

- (void)timerFUNC:(NSTimer *)timer{

    CGFloat currentY = self.mainScrollView.contentOffset.y;
    CGFloat nextY = currentY + mv_height;
    if (nextY == (self.dataArray.count - 1) * mv_height) {
        [UIView animateWithDuration:animationtime animations:^{
            self.mainScrollView.contentOffset = CGPointMake(0, nextY);
        } completion:^(BOOL finished) {
//            self.mainScrollView.contentOffset = CGPointMake(0, self->mv_height);
            [self.mainScrollView setContentOffset:CGPointMake(0, self->mv_height) animated:NO];
        }];
    }else{//如果滚动视图上要显示的图片不是最后一张时
        //显示下一张图片
        [UIView animateWithDuration:animationtime animations:^{
            //让下一个图片显示出来
            self.mainScrollView.contentOffset = CGPointMake( 0, nextY);
        } completion:^(BOOL finished) {
        }];
    }
}

- (UIScrollView *)mainScrollView{
    
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mv_width, mv_height)];
//        _mainScrollView.delegate = self;
        _mainScrollView.contentSize = CGSizeMake(mv_width, self.dataArray.count * mv_height);
        
        //分页滚动效果 yes
        _mainScrollView.pagingEnabled = NO;
        
        //能否滚动
        _mainScrollView.scrollEnabled = NO;
        
        //弹簧效果 NO
        _mainScrollView.bounces = NO;
        
        //滚动视图的起始偏移量
//        _mainScrollView.contentOffset = CGPointMake(0, mv_height);
        [_mainScrollView setContentOffset:CGPointMake(0, mv_height) animated:NO];
        
        //垂直滚动条
        _mainScrollView.showsVerticalScrollIndicator = NO;
        
        //水平滚动条
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        for (UIView *subview in _mainScrollView.subviews) {
            [subview removeFromSuperview];
        }
        for (int i = 0; i < self.dataArray.count; i ++) {
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, i * mv_height, mv_width, mv_height)];
            lab.backgroundColor = [UIColor clearColor];
            lab.font = FONTSIZE(ADSIZE);
            lab.textColor = ADTEXTCOLOR;
            lab.textAlignment = NSTextAlignmentCenter;
            NSMutableAttributedString *ResultStr = self.dataArray[i];
            [lab setAttributedText:ResultStr];
            [_mainScrollView addSubview:lab];
        }
    }
    return _mainScrollView;
}

- (void)destroyTimer{
    //  清理定时器
    [mv_timer invalidate];
    mv_timer = nil;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
